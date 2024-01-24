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

import doot
import doot.errors
from doot.structs import DootKey

UPDATE = DootKey.make("update_")
FROM_K = DootKey.make("from")
FPATH  = DootKey.make("fpath")

def split_keys(spec, state):
    """ convert text to a tuple of (source_dir, [patterns]) """
    update = UPDATE.redirect(spec)
    text   = FROM_K.expand(spec, state)
    clean  = [y for x in text.split("\n") if (y:=x.strip()) ]
    fpath  = FPATH.to_path(spec, state).parent
    return { update : (fpath, clean) }

def map_keys(spec, state):
    """ collect [(source_dir, [patterns])]
      into { key_pattern -> source_dir }
    """
    update = UPDATE.redirect(spec)
    keys   = FROM_K.to_type(spec, state)
    keymap = { v2 : k for k,v in keys for v2 in v}

    printer.info("Collected %s patterns", len(keymap))
    printer.info(keymap)
    return { update : keymap }
