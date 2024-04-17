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
printer = logmod.getLogger("doot._printer")
##-- end logging

from random import choice, choices

import bibtexparser as BTP
from bibtexparser import middlewares as ms

import doot
import doot.errors
from doot.structs import DootKey
import bib_middleware as BM

MYBIB                              = "#my_bibtex"
MAX_TAGS                           = 7

@DootKey.kwrap.paths("lib-root")
@DootKey.kwrap.redirects("update_")
def build_working_parse_stack(spec, state, _libroot, _update):
    """ read and clean the file's entries, without handling latex encoding """
    read_mids = [
        BM.DuplicateHandler(),
        ms.ResolveStringReferencesMiddleware(),
        ms.RemoveEnclosingMiddleware(),
        BM.PathReader(lib_root=_libroot),
        BM.IsbnValidator(),
        BM.TagsReader(),
        ms.SeparateCoAuthors(),
        BM.NameReader(),
        BM.TitleReader()
    ]
    return { _update : read_mids }

@DootKey.kwrap.paths("lib-root")
@DootKey.kwrap.redirects("update_")
def build_working_write_stack(spec, state, _libroot, _update):
    """ Doesn't encode into latex """
    write_mids = [
        BM.NameWriter(),
        ms.MergeCoAuthors(allow_inplace_modification=False),
        BM.IsbnWriter(),
        BM.TagsWriter(),
        BM.PathWriter(lib_root=_libroot),
        ms.AddEnclosingMiddleware(allow_inplace_modification=False, default_enclosing="{", reuse_previous_enclosing=False, enclose_integers=True),
    ]
    return { _update : write_mids }
