#!/usr/bin/env python3
"""

"""
# ruff: noqa:
from __future__ import annotations
# Imports:

# ##-- stdlib imports
import datetime
import enum
import functools as ftz
import itertools as itz
import logging as logmod
import pathlib as pl
import re
import time
import collections
import contextlib
import hashlib
from copy import deepcopy
from uuid import UUID, uuid1
from weakref import ref
import atexit # for @atexit.register
import faulthandler
# ##-- end stdlib imports

from docutils.statemachine import StringList # type: ignore[import-untyped]
from sphinx.parsers import RSTParser as SphinxParser # type: ignore[import-untyped]
from sphinx.util.logging import getLogger as getSphinxLogger
from sphinx_bib_domain._interface import TEMPLATES_DIR
import bibble as BM
import bibble._interface as API
from bibble.io import JinjaWriter, Reader

# ##-- types
# isort: off
# General
import abc
import collections.abc
import typing
import types
from typing import cast, assert_type, assert_never
from typing import Generic, NewType, Never
from typing import no_type_check, final, override, overload
# Protocols and Interfaces:
from typing import Protocol, runtime_checkable
# isort: on
# ##-- end types

# ##-- type checking
# isort: off
if typing.TYPE_CHECKING:
    from typing import Final, ClassVar, Any, Self
    from typing import Literal, LiteralString
    from typing import TypeGuard
    from collections.abc import Iterable, Iterator, Callable, Generator
    from collections.abc import Sequence, Mapping, MutableMapping, Hashable

    from jgdv import Maybe
    from docutils import nodes
## isort: on
# ##-- end type checking

##-- logging
logging = logmod.getLogger(__name__)
sphlog = getSphinxLogger(__name__)
##-- end logging

# Vars:
DOMAIN_TEMPLATE_DIR : Final[str] = "{{cookiecutter.proj_name}}_domain"

DEFAULT_TEMPLATES : Final[dict] = {
    "lib"     : f"{DOMAIN_TEMPLATE_DIR}/lib.rst.jinja",
    "header"  : f"{DOMAIN_TEMPLATE_DIR}/header.rst.jinja",
    "entry"   : f"{DOMAIN_TEMPLATE_DIR}/entry.rst.jinja",
    "footer"  : f"{DOMAIN_TEMPLATE_DIR}/footer.rst.jinja",
}

# Body:

class DomainParser(SphinxParser):
    """
    A Sphinx Parser for bibtex files.
    """
    supported : tuple[str, ...] = ()
    _stack : API.PairStack_p
    reader : Reader
    writer : JinjaWriter

    def __init__(self, *args, **kwargs) -> None:
        super().__init__(*args, **kwargs)
        self._stack = self.build_stack()
        self.reader = Reader(self._stack)
        self._templates = DEFAULT_TEMPLATES.copy()

    @override
    def set_application(self, app) -> None:
        super().set_application(app)
        self.writer = JinjaWriter(self._stack,
                                  templates=[self.config.bib_domain_templates, TEMPLATES_DIR])
        self.writer.update_templates(self._templates)

    def build_stack(self) -> API.PairStack_p:
        """ Make the parse/write stack for bibtex """
        stack = BM.PairStack()
        extra = BM.metadata.DataInsertMW()
        stack.add(read=[extra])
        stack.add(read=[BM.bidi.BraceWrapper()])
        stack.add(read=[BM.bidi.BidiNames(authors=True, parts=False)])
        stack.add(read=[BM.failure.DuplicateKeyHandler()],
                  write=[BM.failure.FailureHandler()])
        stack.add(write=[extra])
        return stack

    def parse(self, inputstring:str|StringList, document:nodes.document) -> None:
        """ Parse a bibtex file, generate equivalent rst, and parse that.

        """
        doc_source  = pl.Path(document['source'])
        lib         = self.reader.read(inputstring)
        rst         = self.writer.write(lib, title=doc_source.stem)
        # TODO use write_as_data
        super().parse(rst, document)
        if self.config.bib_domain_entries_to_context:
            document.raw_lib = lib # type: ignore[attr-defined]
