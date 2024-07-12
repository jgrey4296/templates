#!/usr/bin/env python3
"""

See EOF for license/metadata/notes as applicable
"""

##-- builtin imports
from __future__ import annotations

# import abc
import datetime
import enum
import functools as ftz
import itertools as itz
import logging as logmod
import pathlib as pl
import re
import time
import types
import weakref
# from copy import deepcopy
# from dataclasses import InitVar, dataclass, field
from typing import (TYPE_CHECKING, Any, Callable, ClassVar, Final, Generic,
                    Iterable, Iterator, Mapping, Match, MutableMapping,
                    Protocol, Sequence, Tuple, TypeAlias, TypeGuard, TypeVar,
                    cast, final, overload, runtime_checkable, Generator)
from uuid import UUID, uuid1

##-- end builtin imports

##-- lib imports
import more_itertools as mitz
##-- end lib imports

##-- logging
logging = logmod.getLogger(__name__)
##-- end logging
printer = logmod.getLogger("doot._printer")

from collections import defaultdict
from bibtexparser.model import Field, Entry
import doot
import doot.errors
from doot.structs import DKey
from dootle.actions.xml import DootSaxHandler

MAPPINGS = DKey("mappings")
PATTERNS = DKey("patterns")
UPDATE   = DKey("update_")
FROM_K   = DKey("from")
ENTRIES  = DKey("entries")

##-- regex
skip_re = re.compile(r"(?i)dickin")

##-- end regex

def extract_entries(spec, state):
    """ map files -> found entries """
    mappings = MAPPINGS.expand(spec, state)
    source   = FROM_K.expand(spec, state)
    update   = UPDATE.redirect(spec)
    results  = source.entries.copy()

    printer.warning("-- Found %s results", len(results))
    return { update : results }

def flatten_results(spec, state):
    """
      merge {file -> [entry]} results,
      and return them as a list of dicts ready for write.xml.entries of
      [{ fpath: x, entries: [] }]

    """
    source = FROM_K.expand(spec, state)
    update = UPDATE.redirect(spec)
    flat_mapping = defaultdict(list)
    for mapping in source:
        for key,val in mapping.items():
            flat_mapping[key] += val

    result = [{"fpath": x, "entries": y} for x,y in flat_mapping.items()]
    printer.info("Flattened results to %s groups", len(result))
    return { update : result }

class DBLPHandler(DootSaxHandler):
    """ A SAX handler for the DBLP dataset
      Assembles bibtexparser entries and fields from matching keys/crossref entries
    """

    class _State(enum.Enum):
        wait    = enum.auto()
        active  = enum.auto()
        check   = enum.auto()

    def __init__(self, spec, state):
        # Get explicit key mapping
        match MAPPINGS.expand(spec, state, on_fail=[]):
            case [dict() as x]:
                self._mapping = x
            case []:
                self._mapping = {}
                printer.info("No Mappings Found")
                # raise doot.errors.DootActionError("No mappings found")
            case [*xs]:
                raise doot.errors.DootActionError("Too Many Mappings Found")

        # Get pattern mapping
        match PATTERNS.expand(spec, state, on_fail=None):
            case [dict() as x]:
                self._patterns : dict[str, pl.Path]    = x
                self._regexs   : dict[str, re.Pattern] = { k : re.compile(k) for k in x.keys() }
            case _:
                printer.info("No Patterns Found")
                self._patterns = {}
                self._regexs = {}
                pass
        # Store entries connected to each key:
        self.entries : dict[pl.Path, list]   = defaultdict(list)
        # Search state
        self._state      = DBLPHandler._State.wait
        # Looking for entries:
        self._entry_fields = ENTRIES.expand(spec, state, type_=list, on_fail=["proceedings", "inproceedings"])
        self._key_fields   = ["crossref"]
        # field any characters relates to
        self._curr_fields = []
        # the current entry being created
        self._curr_entry = None
        # keys the current entry matches on
        self._curr_keys       = []
        self._suffix          = ".bib"
        self._ignore_elements = ["i"]

    def startElement(self, name, attrs):
        match self._state:
            case DBLPHandler._State.wait if name.lower() in self._entry_fields:
                self._state      = DBLPHandler._State.active
                self._curr_entry = Entry(name, key=attrs['key'], fields=[])
                self._curr_keys.append(attrs['key'])
                if 'publtype' in attrs:
                    self._curr_fields.append(Field("pubtype", attrs['publtype']))
            case DBLPHandler._State.active if name in self._ignore_elements:
                pass
            case DBLPHandler._State.active:
                self._curr_fields.append(Field(name, ""))
            case DBLPHandler._State.wait:
                pass
            case _:
                raise doot.errors.DootTaskError("Shouldn't be able to get here", name)

    def endElement(self, name):
        match self._state:
            case DBLPHandler._State.wait:
                pass
            case DBLPHandler._State.active if name.lower() in self._entry_fields:
                self._state = DBLPHandler._State.check
                self._curr_entry.fields = self._curr_fields[:]
            case DBLPHandler._State.active if name.lower() in self._key_fields:
                self._curr_keys.append(self._curr_fields[-1].value)
            case DBLPHandler._State.active:
                pass
            case _:
                raise doot.errors.DootTaskError("Shouldn't be able to get here", name)

        if self._state != DBLPHandler._State.check:
            return

        # See if this entry is one I want
        self._maybe_store_entry()

        self._state = DBLPHandler._State.wait
        self._clear()

    def characters(self, content):
        match self._state:
            case _ if not bool(content.strip()):
                pass
            case DBLPHandler._State.wait:
                pass
            case DBLPHandler._State.active if "https://doi.org" in content:
                self._curr_fields[-1].key = "doi"
                self._curr_fields[-1].value += content
            case DBLPHandler._State.active if bool(self._curr_fields):
                self._curr_fields[-1].value += content

    def _clear(self):
        """ Clear the current entry info """
        self._curr_fields = []
        self._curr_entry  = None
        self._curr_keys   = []

    def _maybe_store_entry(self):
        # if theres an explicit key -> file mapping:
        for field in self._curr_entry.fields:
            if field.key.lower().strip() != "author":
                continue

            if skip_re.search(field.value):
                self._clear()
                return

        match_keys = [y for x in self._curr_keys if (y:=self._mapping.get(x, None))]
        if bool(match_keys):
            self.entries[match_keys[0]].append(self._curr_entry)

        match self._curr_entry.entry_type:
            case "proceedings" | "inproceedings":
                self._handle_proceedings()
            case "article":
                self._handle_article()

    def _handle_proceedings(self):
        for k in self._patterns:
            regex = self._regexs[k]
            base  = self._patterns[k]
            if any(regex.match(x) for x in self._curr_keys):
                if "crossref" in self._curr_entry.fields_dict:
                    crossref = self._curr_entry.fields_dict['crossref'].value
                    clean    = crossref.replace("/", "_").removeprefix("conf_")
                    target   = base / clean
                else:
                    key    = self._curr_entry.key
                    clean  = key.replace("/", "_").removeprefix("conf_")
                    target = base / clean

                self.entries[target.with_suffix(self._suffix)].append(self._curr_entry)


    def _handle_article(self):
        for k in self._patterns:
            regex = self._regexs[k]
            base  = self._patterns[k]
            if any(regex.match(x) for x in self._curr_keys):
                key    = self._curr_entry.key
                match self._curr_entry.fields_dict.get("year", None):
                    case None:
                        year = "0000"
                    case x:
                        year = x.value
                clean = key.split("/")[1] + "_" + year
                target = base / clean
                self.entries[target.with_suffix(self._suffix)].append(self._curr_entry)
