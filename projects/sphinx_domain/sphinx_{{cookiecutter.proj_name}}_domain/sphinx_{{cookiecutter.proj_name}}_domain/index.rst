.. ..  index.rst -*- mode: ReST -*-

.. _index:

==========================
Sphinx {{cookiecutter.proj_name}} Domain
==========================

.. contents:: Table of Contents


------------
Introduction
------------

A `sphinx`_ `extension`_ for a domain.

------------
Installation
------------

To install, run ``uv add sphinx_{{cookiecutter.proj_name}}_domain`` and sync
Then, in your ``conf.py``:

.. code:: python
 
   extensions =  ["sphinx_{{cookiecutter.proj_name}}_domain"]

.. _repo:

---------------
Repo And Issues
---------------

The repo can be found `here <https://github.com/jgrey4296/sphinx_{{cookiecutter.proj_name}}_domain>`_.

If you find a bug, bug me, unsurprisingly, on the `issue tracker <https://github.com/jgrey4296/sphinx_{{cookiecutter.proj_name}}_domain/issues>`_.


.. .. Main Sidebar TocTree
.. toctree::
   :maxdepth: 3
   :glob:
   :hidden:
      
   [a-z]*/index

   _docs/*
   genindex
   modindex
   API Reference <_docs/_autoapi/sphinx_{{cookiecutter.proj_name}}_domain/index>
   

.. .. Links

.. _sphinx: https://www.sphinx-doc.org/en/master/

.. _extension: https://www.sphinx-doc.org/en/master/development/index.html

.. _directive: https://www.sphinx-doc.org/en/master/glossary.html#term-directive

.. _roles: https://www.sphinx-doc.org/en/master/glossary.html#term-role

