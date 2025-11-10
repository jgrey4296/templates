#!/usr/bin/env python3
# Imports:
from __future__ import annotations

# ##-- stdlib imports
import pathlib as pl
from collections.abc import Iterator
from importlib import metadata
from typing import Any, Final, Iterable

# ##-- end stdlib imports

# ##-- 3rd party imports
import bibble
from jgdv import Maybe
from sphinx.errors import ExtensionError

# ##-- end 3rd party imports

from . import _interface as API
from .bib_domain import BibTexDomain
from .builder import BibDomainHTMLBuilder
from .parser import BibtexParser

__version__ = metadata.version("sphinx_bib_domain")
##--|

def bib_collect_pages(app) -> Iterable:
    return []

def bib_page_context(app, page, template, context, doctree) -> Maybe[str]:
    """ Modify context and use custom templates for bib documents """
    domain      = app.env.get_domain(API.DOMAIN_NAME)
    bib_doc     = ('page_source_suffix' in context
                   and context['page_source_suffix'] == ".bib")
    bib_context = app.config.bib_domain_entries_to_context

    match bib_doc, bib_context:
        case True, True:
            context['entries'] = doctree.raw_lib.entries
            return API.TEMPLATES["lib"]
        case True, False:
            return API.TEMPLATES["lib"]
        case _:
            return None

def setup(app):
    # app.connect("html-page-context", bib_page_context)
    app.add_domain(BibTexDomain)
    # For multi-page indices:
    app.add_builder(BibDomainHTMLBuilder)
    # Parse bibtex files:
    app.add_source_suffix(".bib", "bibtex")
    app.add_source_parser(BibtexParser)
    # TODO: app.set_translator?

    ## Config values:
    # absolute or relative to templates_path
    app.add_config_value("bib_domain_split_index", True, "html", bool)
    app.add_config_value("bib_domain_entries_to_context", False, "html", bool)
    app.add_config_value("bib_domain_templates", API.TEMPLATES_DIR, pl.Path)
