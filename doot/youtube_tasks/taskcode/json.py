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

import jsonlines
import pandas
import tomlguard
import doot
import doot.errors
from doot.structs import DootKey, Keyed
from doot.mixins.action.human_numbers import Human_M

to_k       = DootKey.build("to")
from_k     = DootKey.build("from")
update_k   = DootKey.build("update_")
focus_k    = DootKey.build("focus_keys")

# https://developers.google.com/youtube/v3/docs/videos

focus_keys           = [
                     "fulltitle", "title", "description", "duration_string", "view_count", "webpage_url",
                     "chapters", "playlist", "playlist_id", "playlist_title", "was_live", "language",
                     "like_count", "comment_count", "view_count", "chapters"
]

watch_url            = "https://www.youtube.com/watch?v={}" # add the ID
json_date_format     = "%Y%m%d"
output_date_format   = "%Y-%m-%d"

@Keyed.redirects("update_")
@Keyed.types("from")
def reduce_video_metadata(spec, state, update_, from_ex):
    update           = update_k.redirect(spec)
    json : TomlGuard = from_ex
    keys             = set(json.keys())
    focus            = set(focus_keys)
    reduced              = {}
    reduced['date']      = datetime.datetime.strptime(json.on_fail("30000101").upload_date(), json_date_format).strftime(output_date_format)

    if 'filesize_approx' in json:
        reduced['file_size'] = fsize = Human_M.human_sizes(json.filesize_approx)
    elif 'filesize' in json:
        reduced['file_size'] = fsize = Human_M.human_sizes(json.filesize)

    for key in focus & keys:
        match json[key]:
            case [*xs] if isinstance(xs[0], tomlguard.TomlGuard):
                reduced[key] = [dict(x.items()) for x in xs]
            case _:
                reduced[key] = json[key]

    tags            = json.on_fail([]).tags() + json.on_fail([]).categories()
    clean_tags      = set([x.lower().replace(" ", "_") for x in tags])
    reduced['tags'] = list(clean_tags)
    return { update_ : reduced }
