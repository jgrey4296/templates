#!/usr/bin/env python2
"""

"""
# mypy: disable-error-code="import-untyped, attr-defined"
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
from collections import defaultdict
from sys import stderr
from urllib.parse import urlparse
from uuid import UUID, uuid1

# ##-- end stdlib imports

# ##-- 3rd party imports
from docutils import nodes
from docutils.parsers.rst import directives
from sphinx import addnodes
from sphinx.directives import ObjectDescription
from sphinx.domains import Domain, Index, IndexEntry, ObjType
from sphinx.domains.std import StandardDomain
from sphinx.roles import AnyXRefRole, ReferenceRole, XRefRole
from sphinx.util.nodes import make_refnode
# ##-- end 3rd party imports

from sphinx.util.logging import getLogger as getSphinxLogger
from . import _interface as API
from .directives import BibEntryDirective
from . import roles, indices

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

    from docutils import nodes
    from docutils.nodes import Element, Node
    from docutils.parsers.rst import Directive
    from docutils.parsers.rst.states import Inliner
    from sphinx.addnodes import pending_xref
    from sphinx.builders import Builder
    from sphinx.environment import BuildEnvironment
    from sphinx.roles import XRefRole
    from sphinx.util.typing import RoleFunction, TitleGetter
    type Role      = Any


##--|

# isort: on
# ##-- end types

##-- logging
logging = logmod.getLogger(__name__)
sphlog = getSphinxLogger(__name__)
##-- end logging

class BibTexDomain(Domain):
    """ Custom Domain for sphixn
    register with app.add_domain(StandardDomain)
    """
    name                  : str                                = API.DOMAIN_NAME
    label                 : str                                = API.DOMAIN_NAME
    data_version          : int                                = 0
    # directives, roles, indices to be registered rather than in setup:
    directives            : dict[str,type[Directive]]
    roles                 : dict[str, Role]
    indices               : list[type[Index]]
    _last_signature       : Maybe[str]
    # initial data to copy to env.domaindata[domain_name]
    _virtual_names        : dict[str, tuple[str, str]]
    ##--|
    _static_virtual_names : ClassVar[dict]       = {}

    _new_roles            : ClassVar[list[type]] = [ roles.TagRole, roles.DOIRole,
                                                     roles.AuthorRole, roles.JournalRole,
                                                     roles.PublisherRole, roles.SeriesRole,
                                                     roles.InstitutionRole]
    _new_indices          : ClassVar[list[type]] = [indices.TagIndex,
                                                    indices.AuthorIndex,
                                                    indices.PublisherIndex,
                                                    indices.JournalIndex,
                                                    indices.InstitutionIndex,
                                                    indices.SeriesIndex]
    initial_data : ClassVar[dict[str, dict]] = {
        'entries'       : {},
        'tags'          : defaultdict(list),
        'authors'       : defaultdict(list),
        'publishers'    : defaultdict(list),
        'journals'      : defaultdict(list),
        'institutions'  : defaultdict(list),
        'series'        : defaultdict(list),
    }

    def __init__(self, env:BuildEnvironment) -> None:
        super().__init__(env)

        self._last_signature = None

        # directives, roles, indices to be registered rather than in setup:
        self.directives   = {'entry'        : BibEntryDirective}
        self.indices        = BibTexDomain._new_indices[:]
        self.roles        = {'ref'          : XRefRole()}
        self.roles.update({x.reftype : x() for x in BibTexDomain._new_roles})

        self._virtual_names = {x.shortname : (f"{self.name}-{x.name}", x.localname) for x in self.indices}
        self._virtual_names.update(self._static_virtual_names)

        # Add any virtual indices to the standard domain:
        StandardDomain._virtual_doc_names.update(self._virtual_names)

    @override
    def get_full_qualified_name(self, node) -> str:
        return cast("str", API.fsig(node.arguments[0]))

    @override
    def get_objects(self) -> Iterator[tuple[str, str, str, str, str, int]]:
        yield from self.data['entries'].values()

    @override
    def resolve_xref(self, env:BuildEnvironment, fromdocname:str, builder:Builder, typ:str, target:str, node:pending_xref, contnode:Element):
        """
        typ: cross ref type,
        target: target name
        """
        vname_key : str
        first_letter = target[0].upper()
        cap_target   = "cap-{}".format(target[0].upper())
        match typ:
            case "entry" | "ref":
                 entry = self.data['entries'][API.fsig(target)]
                 return make_refnode(builder,
                                     fromdocname,
                                     entry[2],
                                     entry[3],
                                     contnode,
                                     entry[3],
                                     )
            case "tag":
                data_key = "tags"
                vname_key = "tagindex"
            case "author":
                data_key = "authors"
                vname_key = "authorindex"
            case "publisher":
                data_key = "publishers"
                vname_key = "pubindex"
            case "journal":
                data_key = "journals"
                vname_key = "jourindex"
            case "institution":
                data_key = "institutions"
                vname_key = "instindex"
            case "series":
                data_key = "series"
                vname_key = "seriesindex"
            case _:
                sphlog.info("Found other XRef Type: %s : (%s)", typ, target)
                return None

        if target not in self.data[data_key]:
            logging.debug("Failed to find target in data: %s : %s", target, data_key)
            return None

        to_base = self._virtual_names[vname_key][0]
        todocname = f"{to_base}-{target[0].upper()}"
        target_text = f":~:text={target}"
        return make_refnode(builder, fromdocname, todocname, target_text, contnode, target_text)

    def add_entry(self, signature):
        """Add a new entry to the domain."""
        self._last_signature = API.fsig(signature)
        anchor_s             = API.anchor(signature)
        # name, dispname, type, docname, API.anchor, priority
        self.data['entries'][self._last_signature] = (
            self._last_signature,
            signature,
            self.env.docname,
            anchor_s,
            '',
            1,
            )

    def link_data(self, target:str, data:list[str]) -> None:
        if not self._last_signature:
            logging.debug("Tried to link data without a signature")
            return

        assert(target in self.data)
        sig_s = self._last_signature
        for val in data:
            if not bool(val):
                continue
            self.data[target][val].append(sig_s)

    def link_tags(self, tags:list[str]):
        self.link_data("tags", tags)

    def link_authors(self, authors:list[str]):
        self.link_data("authors", authors)

    def link_publisher(self, publisher:str):
        self.link_data("publishers", [publisher.strip()])

    def link_journal(self, journal:str):
        self.link_data("journals", [journal.strip()])

    def link_institution(self, institution:str):
        self.link_data("institutions", [institution.strip()])

    def link_series(self, series:str):
        self.link_data("series", [series.strip()])
