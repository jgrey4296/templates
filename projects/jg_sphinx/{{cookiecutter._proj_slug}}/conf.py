#!/usr/bin/env python3
# Configuration file for the Sphinx documentation builder.
# https://www.sphinx-doc.org/en/master/usage/configuration.html
# Imports:
import datetime
import os
import sys
import pathlib as pl

`(+snippet-expand "docutils.imports")

# -- Project information -----------------------------------------------------

release        = "0.1.0"
project        = 'TODO'
author         = 'John Grey'
copyright      = '{}, {}'.format(datetime.datetime.now().strftime("%Y"), author)
primary_domain = "py"
extensions = [
    `(+snippet-expand "default.extensions")`
    ]

`(+snippet-expand "jinja.ext")

# -- Path setup --------------------------------------------------------------

# If extensions (or modules to document with autodoc) are in another directory,
# add these directories to sys.path here. If the directory is relative to the
# documentation root, use pl.Path.resolve to make it absolute, like shown here.
#
local_mod = str(pl.Path('../').resolve())
sys.path.insert(0, local_mod)

# (Relative to this file):
templates_path   = ['_static/templates']
html_static_path = ['_static']

# Relative to static dir, or fully qualified urls
html_css_files = ["css/custom.css"]
html_js_files  = ["js/base.js"]

toc_object_entries            = True
master_doc                    = "index"

# List of patterns, relative to source directory, that match files and
# directories to ignore when looking for source files.
# This pattern also affects html_static_path and html_extra_path.
exclude_patterns = ['**/flycheck_*.py', "**/__tests/*", '/obsolete/*', "README.md"]

# suppress_warnings = ["autoapi", "docutils"]

# -- General configuration ---------------------------------------------------
# https://www.sphinx-doc.org/en/master/usage/configuration.html#general-configuration

maximum_signature_line_length = 50
toc_object_entries            = True
master_doc                    = "index"
show_warning_types            = True

# -- Options for HTML output -------------------------------------------------
`(+snippet-expand "rtd.options")`

# -- Extension Options -------------------------------------------------
`(+snippet-expand "autoapi.options")`
