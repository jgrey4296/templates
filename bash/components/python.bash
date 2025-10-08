#!/usr/bin/env bash

jgdebug "Python setup"

PYTHONSTARTUP="${XDG_CONFIG_HOME/python/repl_startup.py"
IPYTHONDIR="${XDG_CONFIG_HOME}/python/ipython/"
MYPY_CACHE_DIR="${XDG_CACHE_HOME}/mypy"

#Caffe Stuff:
DYLD_FALLBACK_LIBRARY_PATH="${HOME}/.local/modules/:${DYLD_FALLBACK_LIBRARY_PATH}"

#NLTK:
# NLTK_DATA="${JGCACHE}/assets/nlg/nltk"

USE_EMOJI=0
