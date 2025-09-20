#!/usr/bin/env bash
# shellcheck disable=SC2034,SC1091

jgdebug "Erlang Setup"

ASDF_DATA_DIR="${BASE_CACHE}/asdf"
ASDF_DIR="${ASDF_HOME}"

PATH="${ASDF_DATA_DIR}/shims:${HOME}/go/bin:$PATH"
# . <(asdf completion bash)
