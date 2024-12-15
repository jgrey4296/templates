#!/usr/bin/env python3
"""


"""

from __future__ import annotations

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
from typing import (TYPE_CHECKING, Any, Callable, ClassVar, Final, Generator,
                    Generic, Iterable, Iterator, Mapping, Match,
                    MutableMapping, Protocol, Sequence, Tuple, TypeAlias,
                    TypeGuard, TypeVar, cast, final, overload,
                    runtime_checkable)
from uuid import UUID, uuid1

##-- logging
logging = logmod.getLogger(__name__)
##-- end logging

from doot.structs import DKeyed

check_re = re.compile(r"\d+.\d+.\d+")

@DKeyed.formats("from")
@DKeyed.redirects("update_")
def get_version(spec, state, _from, _update):
    assert(bool(_from))
    lines       = _from.split("\n")
    _, curr_ver = lines[0].split(":")
    assert(check_re.match(curr_ver.strip()))
    return {_update : curr_ver.strip() }
