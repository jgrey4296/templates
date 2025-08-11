#!/usr/bin/env python3
"""
Configuration file for the Sphinx documentation builder.
https://www.sphinx-doc.org/en/master/usage/configuration.html

"""
# ruff: noqa: TC003, A001, DTZ005, ERA001, PLR2044, ARG001, ANN001, ANN201, TC002
# Imports --------------------------------
from __future__ import annotations
import os
import sys
import pathlib as pl
import datetime
from collections.abc import Sequence, Callable
import tomllib
from typing import Literal
from docutils import nodes
from docutils.parsers.rst import directives
from docutils.statemachine import StringList
from sphinx.locale import __
from sphinx.util.docutils import SphinxDirective
# Types ----------------------------------
exclude_patterns       : list[str]
extensions             : list[str]
highlight_options      : dict
html_domain_indices    : bool|Sequence[str]
html_additional_pages  : dict
html_search_options    : dict
html_js_files          : list
html_sidebars          : dict
html_static_path       : list
html_theme_path        : list
html_extra_path        : list
html_style             : list[str] | str
include_patterns       : list[str]
needs_extensions       : dict[str, str]
nitpick_ignore         : set[tuple[str, str]]
nitpick_ignore_regex   : set[tuple[str, str]]
source_suffix          : dict[str, str]
templates_path         : list
napoleon_type_aliases  : dict
# ##--|

# ##-- a: Project information --------------------
`(+snippet-expand "project.info")`

# ##-- b: Extensions -----------------------------
extensions      = [
`(+snippet-expand "default.extensions" 4)`
    
]
needs_extensions  = {
    # ExtName : Version
}

`(+snippet-expand "path.extension")`

`(+snippet-expand "template.options")`

`(+snippet-expand "html.options")`

`(+snippet-expand "rtd.theme.options")`

`(+snippet-expand "rst.options")`

`(+snippet-expand "python.options")`

# ##-- c: Extension Options ----------------------
`(+snippet-expand "autodoc.ext.options")`

`(+snippet-expand "autoapi.ext.options")`

`(+snippet-expand "extlinks.ext.options")`

`(+snippet-expand "intersphinx.ext.options")`

`(+snippet-expand "graphviz.ext.options")`

`(+snippet-expand "imgconvert.ext.options")`

`(+snippet-expand "viewcode.ext.options")`

`(+snippet-expand "autosection.ext.options")`

`(+snippet-expand "napoleon.ext.options")`
                  
# ##-- d: Sphinx App Customisation ---------------
`(+snippet-expand "sphinx.app.setup")`
