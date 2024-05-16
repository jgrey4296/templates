#!/usr/bin/env bash

jgdebug "Erlang Setup"

# Don't use a symlink to it:
ASDF_HOME="/media/john/data/github/__libs/erlang/asdf"
# ASDF_HOME="${HOME}/github/__libs/erlang/asdf"
ASDF_DATA_DIR="${BASE_CACHE}/asdf"
ASDF_DIR="${ASDF_HOME}"

echo "SOURCING ASDF: ${ASDF_HOME}"
. "${ASDF_HOME}/asdf.sh"
