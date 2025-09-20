#!/usr/bin/env bash

jgdebug "Python setup"

PYTHONSTARTUP="$HOME/github/_templates/python/repl_startup.py"
IPYTHONDIR="${BASE_CONFIG}/ipython/"
MYPY_CACHE_DIR="${JGCACHE}/mypy"

#Caffe Stuff:
DYLD_FALLBACK_LIBRARY_PATH="${HOME}/.local/modules/:${DYLD_FALLBACK_LIBRARY_PATH}"

#NLTK:
# NLTK_DATA="${JGCACHE}/assets/nlg/nltk"

USE_EMOJI=0
