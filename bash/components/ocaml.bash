#!/usr/bin/env bash
# https://coq.inria.fr/doc/V8.19.0/refman/practical-tools/coq-commands.html
jgdebug "Ocaml/Coq Setup"


OPAM_SWITCH_PREFIX="$BASE_CACHE/opam/default"
CAML_LD_LIBRARY_PATH="$BASE_CACHE/opam/default/lib/stublibs"
OCAML_TOPLEVEL_PATH="$BASE_CACHE/opam/default/lib/toplevel"

# PATH="$BASE_CACHE/opam/default/bin":$PATH

# COQPATH
# COQ_COLORS
