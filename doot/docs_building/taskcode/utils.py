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

import doot
from doot.structs import DKeyed

@DKeyed.paths("target")
@DKeyed.formats("fallback", fallback="default")
@DKeyed.redirects("update_")
def get_env(spec, state, target, fallback, _update):
    """ Determine the environment to use, from a target path """
    env_name = fallback

    return { _update : env_name }
