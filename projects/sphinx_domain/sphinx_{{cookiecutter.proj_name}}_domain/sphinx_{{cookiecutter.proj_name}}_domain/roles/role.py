#!/usr/bin/env python3
"""

"""
# mypy: disable-error-code="import-untyped,import-not-found"

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
import weakref
from uuid import UUID, uuid1

# ##-- end stdlib imports

# ##-- 3rd party imports
from docutils import nodes
from sphinx.roles import AnyXRefRole, ReferenceRole, XRefRole

# ##-- end 3rd party imports

# ##-- 1st party imports
from .._interface import DOMAIN_NAME

# ##-- end 1st party imports

# ##-- types
# isort: off
import abc
import collections.abc
from typing import TYPE_CHECKING, cast, assert_type, assert_never
from typing import Generic, NewType
# Protocols:
from typing import Protocol, runtime_checkable
# Typing Decorators:
from typing import no_type_check, final, override, overload

if TYPE_CHECKING:
    from jgdv import Maybe
    from typing import Final
    from typing import ClassVar, Any, LiteralString
    from typing import Never, Self, Literal
    from typing import TypeGuard
    from collections.abc import Iterable, Iterator, Callable, Generator
    from collections.abc import Sequence, Mapping, MutableMapping, Hashable

    from docutils.nodes import Element, Node, TextElement, system_message

##--|

# isort: on
# ##-- end types

##-- logging
logging = logmod.getLogger(__name__)
##-- end logging

class DomainRole(XRefRole):
    """ A Role for linking to doi's"""

    classes   = ['xref', 'doi']
    refdomain = DOMAIN_NAME
    reftype   = "doi"

    def run(self) -> tuple[list[Node], list[system_message]]:
        # log("Doi: {} in {}", self.title, self.env.docname)
        uri = f"https://doi.org/{self.title}"
        ref = nodes.reference('', '', internal=False, refuri=uri, classes=self.classes)
        ref += nodes.literal("DOI", "DOI")

        return [ref], []
