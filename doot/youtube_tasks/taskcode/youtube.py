#!/usr/bin/env python3
"""


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

import pandas
from sh import yt_dlp
import sys

import doot
import doot.errors
import doot.structs as DS
from doot.enums import ActionResponse_e

SUBS        = DS.DKey("subs")
TARGET      = DS.DKey("target")
TITLE       = DS.DKey("title")
CHANNEL     = DS.DKey("channel")
FLAG_FILE   = DS.DKey("flag_file")
DL_ARCHIVE  = DS.DKey("archive")

base_call = yt_dlp.bake("-i", "--skip-download", "--restrict-filenames", "--write-description", "--write-info-json", "--no-overwrite",
                        "--write-playlist-metafiles", "--no-clean-infojson", "--force-write-archive", _out=sys.stdout, _err=sys.stderr)

def generate_tasks(spec, state):
    """ Read the subscriptions csv file, generate as many tasks as necessary """
    sub_files = [DS.DKey(x, mark=DS.DKey.mark.PATH).expand(spec,state) for x in SUBS.expand(spec.extra)]
    printer.info("Got: %s", sub_files)
    frames = []
    for sub in sub_files:
        frames.append(pandas.read_csv(sub, skip_blank_lines=True, sep=","))

    frame = pandas.concat(frames, ignore_index=True)

    base              = spec.name
    flag_file         = FLAG_FILE.expand(state=spec.extra)
    for row in frame.itertuples():
        safe_name   = row[3].replace(":", "_").replace(" ","_")
        sub_name    = base.subtask(row[0], safe_name)
        target      = "{data}/{safe_name}"
        spec        = DS.DootTaskSpec.from_dict(dict(name=sub_name,
                                                    channel=row[2],
                                                    safe_name=safe_name,
                                                    title=row[3],
                                                    target=target,
                                                    flag_file=flag_file))
        yield spec

    yield None

def get_channel(spec, state):
    target     = TARGET.expand(spec, state) / "%(title)s.%(ext)s"
    channel    = CHANNEL.expand(spec, state)
    name       = TITLE.expand(spec, state)
    dl_archive = doot.locs[DL_ARCHIVE]
    printer.info("Starting to Archive: %s", name)
    base_call("--output", target, "--download-archive", dl_archive, channel)



def select_tars(target:pl.Path):
    if target.is_dir():
        return False
    return target.name.endswith(".tar.gz")
