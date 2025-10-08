#!/usr/bin/env bash
# https://coq.inria.fr/doc/V8.19.0/refman/practical-tools/coq-commands.html
# https://ocaml.org/docs/installing-ocaml#1-install-opam
#
jgdebug "Ocaml/Rocq Setup"

OPAMROOT="$XDG_CACHE_HOME/opam"
OPAM_SWITCH_PREFIX="$XDG_CACHE_HOME/opam/default"
CAML_LD_LIBRARY_PATH="$XDG_CACHE_HOME/opam/default/lib/stublibs"
OCAML_TOPLEVEL_PATH="$XDG_CACHE_HOME/opam/default/lib/toplevel"

# PATH="$XDG_CACHE_HOME/opam/default/bin":$PATH

# COQPATH
# COQ_COLORS

test -r '/home/john/_cache_/opam/opam-init/init.sh' && . '/home/john/_cache_/opam/opam-init/init.sh' > /dev/null 2> /dev/null || true
