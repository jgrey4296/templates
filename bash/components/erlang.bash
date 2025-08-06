#!/usr/bin/env bash
# shellcheck disable=SC2034,SC1091

jgdebug "Erlang Setup"

# Don't use a symlink to it:
# ASDF_HOME="/media/john/data/github/__libs/erlang/asdf"
# ASDF_HOME="${HOME}/github/__libs/erlang/asdf"
ASDF_DATA_DIR="${BASE_CACHE}/asdf"
ASDF_DIR="${ASDF_HOME}"

PATH="${ASDF_DATA_DIR}/shims:${HOME}/go/bin:$PATH"
# . <(asdf completion bash)
