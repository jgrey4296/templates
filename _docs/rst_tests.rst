.. ..  rst_tests.rst -*- mode: ReST -*-

=========
RST Tests
=========

.. contents:: Contents
   :local:


Math Test
#########

.. math::
   :name: Fourier transform

   (\mathcal{F}f)(y)
    = \frac{1}{\sqrt{2\pi}^{\ n}}
      \int_{\mathbb{R}^n} f(x)\,
      e^{-\mathrm{i} y \cdot x} \,\mathrm{d} x.



Container Test
##############

.. container:: jgcontainer

   .. code-block:: python
      :name: this.py
      :linenos:

      print('This is inside a container blah')

Production List Test
####################


.. container:: highlight

    .. productionlist:: prodlist
       action  : "{" "do" "=" `str` ["," arglist] ["," kwarg]+ "}"
       arglist : "args"   "=" "[" `arg` ["," `arg`]+ "]"
       kwarg   : `var`    "=" `val`



-------------

Graphviz Test
#############

.. graphviz::

   digraph foo {
   "bar" -> "baz";
   "bar" -> "awef";
   "baz" -> "qqq";
   "awef" -> "qqq";
   }


Image Test
##########

.. image:: _static/afghan.jpg
   :width: 400
   :alt: description


