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
# import more_itertools as mitz
# from boltons import
##-- end lib imports

##-- logging
logging = logmod.getLogger(__name__)
##-- end logging

printer = logmod.getLogger("doot._printer")

import doot
import doot.errors
from doot.structs import DootKey
from doot.enums import ActionResponseEnum

@DootKey.kwrap.paths("fpath")
@DootKey.kwrap.expands("maxMB")
def skip_if_too_big(spec, state, fpath, max):
    """
      Skip a file if it is larger than max megabyes
    """
    match max:
        case int():
            max *= 1000000
        case str():
            max = int(max) * 1000000

    if fpath.stat().st_size >= max:
        return ActionResponseEnum.SKIP
