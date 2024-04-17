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

import doot
import doot.errors
from doot.structs import DootKey
import bib_middleware as BM
import bibtexparser as BTP
from bibtexparser import middlewares as ms

UPDATE_K        : Final[DootKey] = DootKey.build("update_")
FROM_KEY        : Final[DootKey] = DootKey.build("from")

def build_chunking_parse_stack(spec, state):
    read_mids = [
        BM.DuplicateHandler(),
        ms.ResolveStringReferencesMiddleware(True),
        ms.RemoveEnclosingMiddleware(True),
    ]
    return {spec.kwargs.update_ : read_mids}

def split_library(spec, state):
    max_count = spec.kwargs.on_fail(250).target.bib_size()
    update = UPDATE_K.redirect(spec)
    base = FROM_KEY.to_type(spec, state, type_=BTP.Library)
    libs = []
    curr = BTP.Library()
    curr.source_files = base.source_files.copy()
    curr.split_count = 0
    for entry in base.entries:
        if len(curr._blocks) > max_count:
            libs.append(curr)
            curr = BTP.Library()
            curr.source_files = base.source_files.copy()
            curr.split_count = libs[-1].split_count + 1

        curr.add(entry)
    else:
        libs.append(curr)
    printer.info("Split Into %s Sub Libraries", len(libs))
    return { update : libs }

def generate_stem(spec, state):
    base = FROM_KEY.to_type(spec, state)
    update = UPDATE_K.redirect(spec)

    source = list(base.source_files)[0]
    count  = base.split_count
    fstem = f"{source.stem}_{count}"

    return { update : fstem }
