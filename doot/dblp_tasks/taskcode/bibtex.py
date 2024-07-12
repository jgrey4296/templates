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
from doot.structs import DKey
import bib_middleware as BM
import bibtexparser as BTP
from bibtexparser import middlewares as ms
from bibtexparser.middlewares.middleware import BlockMiddleware
from task_code.xml import skip_re

MYBIB                              = "#my_bibtex"
MAX_TAGS                           = 7
UPDATE        : Final[DKey]        = DKey("update_")
FROM_KEY      : Final[DKey]        = DKey("from")
FPATH                              = DKey("fpath")
LIB_ROOT                           = DKey("lib_root")

KEY_CLEAN_RE = re.compile(r"[/:{}]")
KEY_SUB_CHAR = "_"


def build_simple_parse_stack(spec, state):
    update = UPDATE.redirect(spec)
    read_mids = [
        ms.ResolveStringReferencesMiddleware(True),
        ms.RemoveEnclosingMiddleware(True),
        BM.LatexReader(True, keep_braced_groups=True, keep_math_mode=True),
        BM.TitleReader(True)
    ]
    return { update : read_mids}

def build_simple_write_stack(spec, state):
    update = UPDATE.redirect(spec)
    write_mids = [
        BM.MergeMultipleAuthorsEditors(True),
        BM.LockCrossrefKeys(True),
        BM.CleanUrls(True),
        BM.LatexWriter(keep_math=True, enclose_urls=False),
        ms.AddEnclosingMiddleware(allow_inplace_modification=True, default_enclosing="{", reuse_previous_enclosing=False, enclose_integers=True),
    ]
    return { update : write_mids }



def map_urls(spec, state):
    """ convert found entries to dblp keys"""
    base    = FPATH.expand(spec, state)
    db      = FROM_KEY.expand(spec, state)
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
    mappings : list[dict] = FROM_KEY.expand(spec, state)
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
    db      = UPDATE.expand(spec, state)
    entries = FROM_KEY.expand(spec, state)
    db.add(entries)

    return { update : db }

def get_fstem_fpar(spec, state):
    fpath   = DKey("fpath").expand(spec, state)
    return { "fstem" : fpath.stem, "fpar": fpath.parent }
