#!/usr/bin/env bash
# 15.rocq.bash -*- mode: sh -*-
#set -o errexit
set -o nounset
set -o pipefail

# use https://ocaml.org/releases or:
# opam switch list-available
opam switch create default 5.4.0

opam install ocaml-lsp-server odoc ocamlformat utop dune

# rocq
opam pin add rocq-prover 9.0.0

# https://rocq-prover.org/docs/using-opam#platform
opam repo add rocq-released https://rocq-prover.org/opam/released
