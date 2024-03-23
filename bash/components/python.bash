#!/usr/bin/env bash

jgdebug "Python setup"

PYTHONSTARTUP="$HOME/github/_templates/python/repl_startup.py"
IPYTHONDIR="$HOME/github/_templates/python/"

PRE_COMMIT_USE_MICROMAMBA=1

#Caffe Stuff:
#DYLD_FALLBACK_LIBRARY_PATH=/usr/local/cuda/lib:$HOME/.pyenv/versions/anaconda-2.2.0/lib:/usr/local/lib/:/usr/lib
DYLD_FALLBACK_LIBRARY_PATH="${HOME}/.local/modules/:${DYLD_FALLBACK_LIBRARY_PATH}"

#NLTK:
NLTK_DATA="${JGCACHE}/assets/nlg/nltk"

MANPATH="${ANACONDA_HOME}/man:$MANPATH"
