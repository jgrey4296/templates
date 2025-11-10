#!/usr/bin/env python3
"""

"""
# ruff: noqa:

# Imports:
from __future__ import annotations

# ##-- stdlib imports
import datetime
import enum
import functools as ftz
import itertools as itz
import logging as logmod
import pathlib as pl
import re
import time
import types
import collections
import contextlib
import hashlib
from copy import deepcopy
from uuid import UUID, uuid1
from weakref import ref
import atexit # for @atexit.register
import faulthandler
# ##-- end stdlib imports

import jinja2.exceptions
import os
import html
from sphinx.util.osutil import relative_uri
from sphinx.builders.html import StandaloneHTMLBuilder
from sphinx.builders.html._assets import _JavaScript, _CascadingStyleSheet, _file_checksum
from sphinx.errors import ConfigError, ThemeError
from sphinx.util.logging import getLogger as getSphinxLogger

# ##-- types
# isort: off
import abc
import collections.abc
from typing import TYPE_CHECKING, cast, assert_type, assert_never
from typing import Generic, NewType, Never
# Protocols:
from typing import Protocol, runtime_checkable
# Typing Decorators:
from typing import no_type_check, final, override, overload
# from dataclasses import InitVar, dataclass, field
# from pydantic import BaseModel, Field, model_validator, field_validator, ValidationError

if TYPE_CHECKING:
    from jgdv import Maybe
    from typing import Final
    from typing import ClassVar, Any, LiteralString
    from typing import Self, Literal
    from typing import TypeGuard
    from collections.abc import Iterable, Iterator, Callable, Generator
    from collections.abc import Sequence, Mapping, MutableMapping, Hashable

##--|

# isort: on
# ##-- end types

##-- logging
logging = logmod.getLogger(__name__)
sphlog = getSphinxLogger(__name__)
##-- end logging

# Vars:

# Body:

class DomainHTMLBuilder(StandaloneHTMLBuilder):
    """ Customised Sphinx HTML builder

    Primarily for enabling split domain indices.

    """

    name = "bibhtml"

    ##--| index writers

    def write_domain_indices(self) -> None:
        for index_name, index_cls, content, collapse in self.domain_indices:
            index_context = {
                'indextitle'     : index_cls.localname,
                'content'        : content,
                'collapse_index' : collapse,
            }
            logging.info("%s ", index_name)
            if self.config.bib_domain_split_index:
                sphlog.info("Domain Index (split): %s", index_name)
                self._split_domain_into_subpages(index_name, index_context, "domainindex-split.html", "domainindex-single.html")
            else:
                sphlog.info("Domain Index: %s", index_name)
                self.handle_page(index_name, index_context, "domainindex.html")

    def _split_domain_into_subpages(self, name:str, context:dict, template_overview:str, template_part:str) -> None:
        """ Adapted from sphinx's write_genidex """
        context['subpages'] = []
        for (key, entries) in context['content']:
            if not bool(entries):
                continue
            context['subpages'].append((key,
                                        f"{name}-{key}",
                                        len([x for x in entries if x[1] == 1]),
                                        len([x for x in entries if x[1] == 2]),
                                        ))
            ctx = {
                'title'            : f"{context['indextitle']}: {key}",
                'basename'         : name,
                'key'              : key,
                'entries'          : entries,
                'genindexentries'  : [],
            }
            self.handle_page(f"{name}-{key}", ctx, template_part)
        else:
            self.handle_page(name, context, template_overview)
