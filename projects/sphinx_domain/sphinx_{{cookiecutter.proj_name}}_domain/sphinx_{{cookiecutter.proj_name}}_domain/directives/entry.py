#!/usr/bin/env python3
"""

"""
# mypy: disable-error-code="import-untyped, import-not-found"
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
from uuid import UUID, uuid1
from urllib.parse import urlparse

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

from sphinx.util.docfields import DocFieldTransformer
from sphinx.util.logging import getLogger as getSphinxLogger
from .. import _interface as API

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

    from sphinx.util.typing import ExtensionMetadata, OptionSpec
    type desc_signature = addnodes.desc_signature
    type Node = nodes.Node
##--|

# isort: on
# ##-- end types

##-- logging
logging  = logmod.getLogger(__name__)
sphlog   = getSphinxLogger(__name__)
##-- end logging

class EntryDirective(ObjectDescription):
    """ Custom Directive for Entries.
    Note: use 'within' for volume, number, issue, pages.
    concat title with subtitle

    TODO: legal fields (status, plaintiff, defendant etc)
    """

    has_content             : bool = True
    required_arguments      : int = 1
    option_spec             : ClassVar[OptionSpec] = {
        'title'             : directives.unchanged_required,
        'subtitle'          : directives.unchanged_required,
        'year'              : directives.unchanged_required,
        'tags'              : directives.unchanged_required,
        'author'            : directives.unchanged,
        'editor'            : directives.unchanged,
        'journal'           : directives.unchanged,
        'booktitle'         : directives.unchanged,
        'within'            : directives.unchanged, # TODO remove this
        "volume"            : directives.unchanged,
        "number"            : directives.unchanged,
        'platform'          : directives.unchanged,
        'publisher'         : directives.unchanged,
        'institution'       : directives.unchanged,
        'series'            : directives.unchanged,
        'url'               : directives.unchanged,
        'doi'               : directives.unchanged,
        'isbn'              : directives.unchanged,
        'edition'           : directives.unchanged,
        'edition_year'      : directives.unchanged,
        'crossref'          : directives.unchanged,
        'identifier'        : directives.unchanged,
        # TODO              : thesis type
        'no-index'          : directives.flag,
        'no-index-entry'    : directives.flag,
        'no-contents-entry' : directives.flag,
        'no-typesetting'    : directives.flag,
    }

    def _toc_entry_name(self, sig_node:desc_signature) -> str:
        return ""

    def handle_signature(self, sig:str, signode:addnodes.desc_signature) -> str:
        """ parses the signature and passes the name and type on """
        if signode['is_multiline']:
                signode += addnodes.desc_signature_line('', sig)
        else:
                signode += addnodes.desc_name(text=sig)
        return sig

    def add_target_and_index(self, name_cls, sig, signode):
        """ links the node to the index and back """
        signode['ids'].append(API.anchor(sig))
        signode['ids'].append(sig)
        self.state.document.note_explicit_target(signode)
        domain = self.env.get_domain(API.DOMAIN_NAME)
        domain.add_entry(sig)
        for x,y in self.options.items():
            match x:
                case "author" | "editor":
                    # TODO handle '{x and y}'
                    domain.link_authors([a.strip() for a in y.split(" | ")])
                case "tags":
                    domain.link_tags([x.strip() for x in y.split(",")])
                case "publisher":
                    domain.link_publisher(y)
                case "institution":
                    domain.link_institution(y)
                case "series":
                    domain.link_series(y)
                case "journal":
                    domain.link_journal(y)
                case _:
                    pass

    def before_content(self):
        """ Set the content to be rendered from the options passed in """
        adapted                        = []
        title, authors, tags, crossref = "", "", "", ""
        loc, loc_details               = "", ""
        url, doi                       = "", ""

        for x,y in self.options.items():
            match x:
                case "subtitle" | "title" | "short_parties":
                    pass
                case "crossref":
                    crossref = f"| see :ref:`{y}`"
                case "author" | "editor":
                    _authors = " and ".join(f":author:`{a.strip()}`" for a in y.split(" | "))
                    eds = " (eds)." if x == "editor" else ""
                    authors  = f"| {_authors}{eds}"
                case "tags":
                    tags    = ", ".join(f":tag:`{t.strip()}`" for t in y.split(","))
                case "crossref":
                    simple_crossref = y
                    crossref = f"(See :ref:`{simple_crossref}`)"
                case "edition" | "edition_year":
                    adapted.append(f"| {y} Edition")
                case "url":
                    url_ = urlparse(y)
                    url = f"| `Link <{y}>`__"
                case "doi":
                    doi = f"| :doi:`{y}`"
                case "within":
                    adapted.append(f"| in *{y}*")
                case "journal":
                    adapted.append(f"| in :journal:`{y}`")
                case "series":
                    adapted.append(f"| *Series*: :series:`{y}`")
                case "institution":
                    adapted.append(f"| :institution:`{y}`")
                case "publisher":
                    adapted.append(f"| :publisher:`{y}`")
                case "isbn":
                    adapted.append(f"| isbn: {y}")
                case "booktitle":
                    adapted.append(f"| in *{y}*")
                case "identifier":
                    adapted.append(f"| ID: {y}")
                case "year":
                    pass
                case x:
                    adapted.append(f"| {x.title()}: {y}")

        label  = f".. _{self.arguments[0]}:\n\n"
        key    = f"| *Key*: {self.arguments[0]}"
        # Ensure title and authors are first
        # and tags + crossref are last
        if doi:
            adapted.append(doi)
        if url:
            adapted.append(url)
        if tags:
            adapted.append(f"| {tags}")

        match crossref:
            case None | "":
                adapted = [authors, *adapted]
            case _:
                adapted = [crossref, authors, *adapted]

        self.content = "\n".join(adapted)

    def run(self) -> list[Node]:
        result : list[Node]
        ##--|
        result                     = []
        self.domain, self.objtype  = self.name.split(':', 1)
        self.indexnode             = addnodes.index(entries=[])
        source, line               = self.get_source_info()
        if line is not None:
            line -= 1
        self.state.document.note_source(source, line)

        node             = addnodes.desc()
        node.document    = self.state.document
        node['domain']   = self.domain
        node['objtype']  = self.objtype
        node['classes'].append(self.domain)
        node['classes'].append(self.objtype)

        # TODO break into multiple lines if too long:
        signode = addnodes.desc_signature(is_multiline=True)
        match self.options:
            case {"title": title, "subtitle": sub}:
                self.handle_signature(f"{title}: {sub}", signode)
            case {"title": title}:
                self.handle_signature(title, signode)
            case {"short_parties": short}:
                self.handle_signature(short, signode)

        self.set_source_info(signode)
        node.append(signode)

        for sig in self.get_signatures():
            self.add_target_and_index(sig, sig, signode)
            self.handle_signature(f"({sig})", signode)

        ##--|
        self.before_content()
        content_children = self.parse_content_to_nodes(allow_section_headings=True)
        content_node = addnodes.desc_content('', *content_children)
        self.transform_content(content_node)
        self.env.events.emit(
            'object-description-transform', self.domain, self.objtype, content_node
        )
        DocFieldTransformer(self).transform_all(content_node)
        node += content_node

        self.after_content()

        return [self.indexnode, node, nodes.transition()]
