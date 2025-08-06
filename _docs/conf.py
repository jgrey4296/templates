#!/usr/bin/env python3
"""
Configuration file for the Sphinx documentation builder.
https://www.sphinx-doc.org/en/master/usage/configuration.html

"""
# ruff: noqa: TC003, A001, DTZ005, ERA001, PLR2044, ARG001, ANN001, ANN201, TC002, F401
# Imports --------------------------------
from __future__ import annotations
import os
import sys
import pathlib as pl
import datetime
from collections.abc import Sequence, Callable
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
project    = "Templates"
author     = "John Grey"
copyright  = "{}, {}".format(datetime.datetime.now().strftime("%Y"), author)
language   = "en"

"""https://www.sphinx-doc.org/en/master/usage/configuration.html#general-configuration"""
root_doc                       = "index"
primary_domain                 = "py"
default_role                   = None

root_doc                       = "index"
suppress_warnings              = ["autoapi", "docutils"]
maximum_signature_line_length  = 50
toc_object_entries             = True
add_function_parentheses       = True
show_warning_types             = True
nitpick_ignore                 = set()
nitpick_ignore_regex           = set()
# Pygments: https://pygments.org/docs/lexers
highlight_options              = {}
pygments_style                 = "sphinx"

"""List of patterns, relative to source directory, that match files and
directories to incldue/ignore when looking for source files.
These also affects html_static_path and html_extra_path.
"""
include_patterns = [
    "**",
]
exclude_patterns = [
    ".venv",
    "code/*",
    "projects/*/*",
    "man",
    "**/flycheck_*.py",
    "**/__tests/*",
    "_docs/_templates/*",
    "README.md",
]
source_suffix = {
    ".rst"  : "restructuredtext",
    ".md"   : "markdown",
}

# ##-- b: Extensions -----------------------------
extensions      = [
"myst_parser",
"sphinx_rtd_theme",
# Shorten external links: https://www.sphinx-doc.org/en/master/usage/extensions/extlinks.html
"sphinx.ext.extlinks",
# imagemagick conversion: https://www.sphinx-doc.org/en/master/usage/extensions/imgconverter.html
"sphinx.ext.imgconverter",
# Graph diagrams: https://www.sphinx-doc.org/en/master/usage/extensions/graphviz.html
"sphinx.ext.graphviz",
# Link to other projects: https://www.sphinx-doc.org/en/master/usage/extensions/intersphinx.html
"sphinx.ext.intersphinx",
# Refernce sections by title: https://www.sphinx-doc.org/en/master/usage/extensions/autosectionlabel.html
# "sphinx.ext.autosectionlabel",
#--
# Extensions which IMPORT CODE:
]
needs_extensions  = {
    # ExtName : Version
}

# -- Path setup ----------------------------------
# local_mod = str(pl.Path.cwd().parent.parent)
# sys.path.insert(0, local_mod)

# ##-- Templates ---------------------------------
# Fully qualified class of TemplateBridge
template_bridge = ""
# Relative to this file:
templates_path    = ["_templates"]

# ##-- HTML --------------------------------------
"""By default, the read the docs theme.
https://www.sphinx-doc.org/en/master/usage/configuration.html#options-for-html-output
"""
html_use_index                = True
html_split_index              = False
html_permalinks               = True
html_copy_source              = True
html_show_sourcelink          = True
html_show_search_summary      = False
html_codeblock_linenos_style  = "inline"  # or "table"
supported_image_types = ["image/svg+xml", "image/png", "image/gif", "image/jpeg"]
# --
html_theme_options            = {}
html_sidebars                 = {} # Maps doc names -> templates
html_additional_pages         = {} # Maps doc names -> templates
html_context                  = {}
html_search_options           = {}
# (Relative to this file):
html_theme_path   = []
html_static_path  = ["_static"]
html_extra_path   = []  # for things like robots.txt
# html_style        = []
# html_logo       = ""
# html_favicon    = ""
# Relative to static dir, or fully qualified urls
html_css_files       = ["custom.css"]
html_js_files        = ["custom.js"]
# Generate additional domain specific indices
html_domain_indices  = []
#
html_additional_pages.update({})
html_context.update({
    "collapse_index_py": True,
})

# ##-- HTML Theme: ReadTheDocs -------------------
"""https://sphinx-rtd-theme.readthedocs.io/en/stable/configuring.html"""
html_theme                = "sphinx_rtd_theme"
#
html_theme_options.update({
    "logo_only"                   : False,
    # "version_selector"             : True,
    "prev_next_buttons_location"  : "bottom",
    "style_external_links"        : False,
    "vcs_pageview_mode"           : "",
    "style_nav_header_background" : "grey",
    # TOC options:
    "collapse_navigation"         : True,
    "sticky_navigation"           : True,
    "navigation_depth"            : 4,
    "includehidden"               : True,
    "titles_only"                 : False,
})

# ##-- RST Options -------------------------------
# rst_prolog = ""
# rst_epilog = ""


# ##-- c: Extension Options ----------------------

# ##-- Extlinks ----------------------------------
extlinks : dict[str, tuple[str, str]]
#--
extlinks_detect_hardcoded_links = False
# create roles to simplify urls. format: {rolename: [linkpattern, caption]}
extlinks = {
    # Add ':issue:' role:
    "issue": ("https://github.com/jgrey4296/jgdv/issues/%s", "issue %s"),
}

# ##-- Intersphinx -------------------------------
# https://www.sphinx-doc.org/en/master/usage/extensions/intersphinx.html
type InterTuple      = tuple[str, tuple[str, str | None] | None]
intersphinx_mapping      : dict[str, InterTuple]
intersphinx_cache_limit  : int
intersphinx_timeout      : int | float | None
#--
# Map to other documentation using :external:
intersphinx_mapping = {
    # eg: :external+python:ref:`comparisons`
    "python" : ("https://docs.python.org/3", None),

}
intersphinx_cache_limit  = 5 # days
intersphinx_timeout      = None

# ##-- Graphviz ----------------------------------
# https://www.sphinx-doc.org/en/master/usage/extensions/graphviz.html
#--
# Command name to invoke dot:
graphviz_dot            =  "dot"
graphviz_dot_args       = ()
graphviz_output_format  = "svg"  # or "png"

# ##-- imgconvert --------------------------------
# https://www.sphinx-doc.org/en/master/usage/extensions/imgconverter.html
#--
# Path to conversion command:
image_converter       = "convert"
image_converter_args  = ()


# ##-- d: Sphinx App Customisation ---------------
# ##-- Jinja -------------------------------------
try:
    import jinja2
except ImportError:
    jinja2 = None
else:

    def filter_contains(val:list|str, *needles:str) -> bool:
        match val:
            case str():
                return any(x in val for x in needles)
            case list():
                joined = " ".join(val)
                return any(x in joined for x in needles)
            case _:
                return False

    def autoapi_prepare_jinja_env(jinja_env: jinja2.Environment) -> None:
        jinja_env.add_extension("jinja2.ext.debug")
        jinja_env.tests['contains'] = filter_contains

    def add_jinja_ext(app):
        app.builder.templates.environment.add_extension("jinja2.ext.debug")

# ##-- Sphinx and Jinja configuration ------------

def setup(app):
    if jinja2 is not None:
        app.events.connect("builder-inited", add_jinja_ext, 1)
