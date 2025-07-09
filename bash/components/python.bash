#!/usr/bin/env bash

jgdebug "Python setup"

PYTHONSTARTUP="$HOME/github/_templates/python/repl_startup.py"
IPYTHONDIR="${BASE_CONFIG}/ipython/"
MYPY_CACHE_DIR="${JGCACHE}/mypy"

PRE_COMMIT_USE_MICROMAMBA=1

#Caffe Stuff:
#DYLD_FALLBACK_LIBRARY_PATH=/usr/local/cuda/lib:$HOME/.pyenv/versions/anaconda-2.2.0/lib:/usr/local/lib/:/usr/lib
DYLD_FALLBACK_LIBRARY_PATH="${HOME}/.local/modules/:${DYLD_FALLBACK_LIBRARY_PATH}"

#NLTK:
NLTK_DATA="${JGCACHE}/assets/nlg/nltk"

MANPATH="${ANACONDA_HOME}/man:$MANPATH"

# Pipx for uv
PIPX_HOME="$HOME/.local/pipx"
PIPX_BIN_DIR="$HOME/.local/bin"
PIPX_DEFAULT_PYTHON=

USE_EMOJI=0

