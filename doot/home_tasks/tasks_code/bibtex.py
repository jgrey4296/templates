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

import doot
import doot.errors
from doot.structs import DootKey
import bib_middleware as BM
import bibtexparser as BTP
from bibtexparser import middlewares as ms

MYBIB                              = "#my_bibtex"
MAX_TAGS                           = 7
UPDATE        : Final[DootKey] = DootKey.make("update_")
FROM_KEY      : Final[DootKey] = DootKey.make("from")

def select_one_entry(spec, state):
    bib_db     = FROM_KEY.to_type(spec, state, type_=BTP.Library)
    update_key = UPDATE.redirect(spec)
    entries    = bib_db.entries
    entry      = choice(entries)
    # TODO have white/black list

    if bool(entry):
        return {update_key : entry}

def build_parse_stack(spec, state):
    read_mids = [
        ms.ResolveStringReferencesMiddleware(True),
        ms.RemoveEnclosingMiddleware(True),
        BM.LatexReader(True, keep_braced_groups=True, keep_math_mode=True),
        BM.PathsReader(lib_root=doot.locs["{lib-root}"]),
        BM.TagsReader(),
        ms.SeparateCoAuthors(True),
        BM.NameReader(True),
    ]
    return {spec.kwargs.update_ : read_mids}

def build_write_stack(spec, state):
    write_mids = [
        BM.NameWriter(True),
        ms.MergeCoAuthors(True),
        BM.LatexWriter(keep_math=True, enclose_urls=False),
        BM.TagsWriter(),
        BM.PathsWriter(lib_root=doot.locs["{lib-root}"]),
        ms.AddEnclosingMiddleware(allow_inplace_modification=True, default_enclosing="{", reuse_previous_enclosing=False, enclose_integers=True),
    ]
    return {spec.kwargs.update_ : write_mids}


def write_tag_set(spec, state):
    update_key = UPDATE.redirect(spec, state)
    result     = BM.ParseTagsMiddleware.tags_to_str()

    return { update_key : result }

def write_name_set(spec, state):
    update_key = UPDATE.redirect(spec, state)
    result     = BM.MergeLastNameFirstName.names_to_str()

    return { update_key : result }
