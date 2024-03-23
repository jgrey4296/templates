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
from doot.structs import DootKey
from dootle.actions.xml import DootSaxHandler

UPDATE   = DootKey.build("update_")
FROM_K   = DootKey.build("from")

def extract_results(spec, state):
    """  """
    source   = FROM_K.to_type(spec, state)
    journals = source._journals.copy()
    confs    = source._conferences.copy()
    jraw = source._journals_set.copy()
    craw = source._conferences_set.copy()

    printer.warning("Found %s journals, %s confs", len(journals), len(confs))
    return { "journals": journals, "confs": confs, "jraw": jraw, "craw": craw}

def flatten_dicts(spec, state):
    """ """
    source = FROM_K.to_type(spec, state)
    update = UPDATE.redirect(spec)
    flat = {}
    for d in source:
        flat.update(d)

    printer.warning("Collected %s %s", len(flat), spec.kwargs['from_'])
    result_str = "\n".join(f"{k:10} : {flat[k]}" for k in sorted(flat.keys()))
    return { update : result_str }

def flatten_raw(spec, state):
    source = FROM_K.to_type(spec, state)
    update = UPDATE.redirect(spec)
    result_str = "\n".join(source)
    return { update : result_str }

class DBLPSelector(DootSaxHandler):
    """ A SAX handler for the DBLP dataset
      Assembles bibtexparser entries and fields from matching keys/crossref entries
    """

    class _StateE(enum.Enum):
        wait       = enum.auto()
        proceeding = enum.auto()
        article    = enum.auto()
        title      = enum.auto()
        journal    = enum.auto()
        check      = enum.auto()

    def __init__(self, spec, state):
        # Store entries connected to each key:
        self.entries : dict[pl.Path, list]   = defaultdict(list)
        # Search state
        self._state           = self._StateE.wait
        self._curr_key        = ""
        self._curr_content    = []
        self._journals        = {}
        self._conferences     = {}
        self._journals_set    = set()
        self._conferences_set = set()


    def startElement(self, name, attrs):
        if 'key' in attrs:
            key = pl.Path(attrs['key'])
            self._curr_key = "/".join(key.parts[:-1]).strip()

        match self._state, name.lower():
            case self._StateE.wait, "proceedings":
                self._state = self._StateE.proceeding
            case self._StateE.wait, "journal":
                self._state = self._StateE.journal
            case self._StateE.proceeding, "title":
                self._state = self._StateE.title
            case _:
                pass

    def endElement(self, name):
        match self._state:
            case self._StateE.title if self._curr_key not in self._conferences:
                self._state = self._StateE.wait
                name = "".join(self._curr_content).replace("\n", " ").strip()
                self._conferences[self._curr_key] = name
                self._conferences_set.add(name)
                # printer.warning("Storing Conf     : %s : %s", self._curr_key, self._conferences[self._curr_key])
                self._clear()
                pass
            case self._StateE.journal if self._curr_key not in self._journals:
                self._state = self._StateE.wait
                name = "".join(self._curr_content).replace("\n", " ").strip()
                self._journals[self._curr_key] = name
                self._journals_set.add(name)
                # printer.warning("Storing: Journal : %s : %s", self._curr_key, self._journals[self._curr_key])
                self._clear()
                pass
            case self._StateE.title:
                self._state = self._StateE.wait
                name = "".join(self._curr_content).replace("\n", " ").strip()
                self._conferences_set.add(name)
                self._clear()
            case self._StateE.journal:
                self._state = self._StateE.wait
                name = "".join(self._curr_content).replace("\n", " ").strip()
                self._journals_set.add(name)
                self._clear()
            case _:
                pass

    def characters(self, content):
        match self._state:
            case self._StateE.title | self._StateE.journal:
                self._curr_content.append(content)
            case _:
                pass

    def _clear(self):
        """ Clear the current entry info """
        self._curr_content = []
        self._curr_key = ""
