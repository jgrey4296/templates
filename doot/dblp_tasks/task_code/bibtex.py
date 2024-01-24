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
from random import choice, choices
from urllib.parse import urlparse

import doot
import doot.errors
from doot.structs import DootKey
from dootle.bibtex import middlewares as dmids
import bibtexparser as BTP
from bibtexparser import middlewares as ms
from bibtexparser.middlewares.middleware import BlockMiddleware

MYBIB                              = "#my_bibtex"
MAX_TAGS                           = 7
UPDATE        : Final[DootKey]     = DootKey.make("update_")
FROM_KEY      : Final[DootKey]     = DootKey.make("from")
FPATH                              = DootKey.make("fpath")
LIB_ROOT                           = DootKey.make("lib_root")

KEY_CLEAN_RE = re.compile(r"[/:{}]")
KEY_SUB_CHAR = "_"

class MergeMultipleAuthorsEditors(BlockMiddleware):
    """ Merge multiple fields of the same name """

    def metadata_key(self):
        return str(self.__class__.__name__)

    def transform_entry(self, entry, library):
        fields  = []
        authors = []
        editors = []
        for x in entry.fields:
            match x.key.lower():
                case "author":
                    authors.append(x.value)
                case "editor":
                    editors.append(x.value)
                case _:
                    fields.append(x)

        if bool(authors):
            fields.append(BTP.model.Field("author", " and ".join(authors)))
        if bool(editors):
            fields.append(BTP.model.Field("editor", " and ".join(editors)))

        entry.fields = fields
        return entry

class LockCrossrefKeys(BlockMiddleware):
    """ ensure crossref consistency by appending _ to keys and removing chars i don't like"""

    def metadata_key(self):
        return str(self.__class__.__name__)

    def transform_entry(self, entry, library):
        clean_key = KEY_CLEAN_RE.sub(KEY_SUB_CHAR, entry.key)
        entry.key = f"{clean_key}_"
        if "crossref" in entry.fields_dict:
            orig = entry.fields_dict['crossref'].value
            clean_ref = KEY_CLEAN_RE.sub(KEY_SUB_CHAR, orig)
            entry.set_field(BTP.model.Field("crossref", f"{clean_ref}_"))

        return entry

class CleanUrls(BlockMiddleware):

    def metadata_key(self):
        return str(self.__class__.__name__)

    def transform_entry(self, entry, library):
        fields_dict = entry.fields_dict
        if "doi" in fields_dict:
            clean = fields_dict['doi'].value.removeprefix("https://doi.org/")
            fields_dict['doi'] = BTP.model.Field("doi", clean)

        if "url" in fields_dict:
            url = fields_dict['url'].value
            if url.startswith("db/"):
                joined                   = "".join(["https://dblp.org/", url])
                fields_dict['biburl']    = BTP.model.Field("biburl", joined)
                fields_dict['bibsource'] = BTP.model.Field('bibsource', "dblp computer science bibliography, https://dblp.org")
                del fields_dict['url']


        entry.fields = list(fields_dict.values())
        return entry


def build_simple_parse_stack(spec, state):
    update = UPDATE.redirect(spec)
    read_mids = [
        ms.ResolveStringReferencesMiddleware(True),
        ms.RemoveEnclosingMiddleware(True),
        dmids.FieldAwareLatexDecodingMiddleware(True, keep_braced_groups=True, keep_math_mode=True),
        dmids.TitleStripMiddleware(True)
    ]
    return { update : read_mids}

def build_simple_write_stack(spec, state):
    update = UPDATE.redirect(spec)
    write_mids = [
        MergeMultipleAuthorsEditors(True),
        LockCrossrefKeys(True),
        CleanUrls(True),
        dmids.FieldAwareLatexEncodingMiddleware(keep_math=True, enclose_urls=False),
        ms.AddEnclosingMiddleware(allow_inplace_modification=True, default_enclosing="{", reuse_previous_enclosing=False, enclose_integers=True),
    ]
    return { update : write_mids }



def map_urls(spec, state):
    """ convert found entries to dblp keys"""
    base    = FPATH.to_path(spec, state)
    db      = FROM_KEY.to_type(spec, state)
    update  = UPDATE.redirect(spec)
    mapping = {}
    for entry in db.entries:
        if entry.entry_type.lower() == "inproceedings":
            mapping = {}
            break

        if entry.entry_type.lower() != "proceedings":
            continue

        fields = entry.fields_dict
        url    = fields.get('biburl')
        if url is not None:
            key = urlparse(url.value).path.removesuffix(".bib").removeprefix("/rec/")
            mapping[key] = base
            continue

    if len(mapping) > 1:
        mapping = {x:y.with_stem("gen_" + x.split("/")[-1]) for x,y in mapping.items()}

    printer.info("-- Mapped %s keys", len(mapping))
    return { update : mapping }

def join_mappings(spec, state):
    """ flatten mappings of key->file into a single dict """
    mappings : list[dict] = FROM_KEY.to_type(spec, state)
    update = UPDATE.redirect(spec)
    total = {}
    for mapping in mappings:
        conflict = set(total.keys()).intersection(mapping.keys())
        if bool(conflict):
            raise doot.errors.DootActionError("Conflicting Mapping", conflict)
        total.update(mapping)

    printer.warning("-- Collected %s mappings : %s", len(total), list(total.keys()))
    return { update : total }



def insert_entries(spec, state):
    """ insert xml sourced entries into a db, """
    update  = UPDATE.redirect(spec)
    db      = UPDATE.to_type(spec, state)
    entries = FROM_KEY.to_type(spec, state)
    db.add(entries)

    return { update : db }

def get_fstem_fpar(spec, state):
    fpath   = DootKey.make("fpath").to_path(spec, state)
    return { "fstem" : fpath.stem, "fpar": fpath.parent }
