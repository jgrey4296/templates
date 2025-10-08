#!/usr/bin/env bash
# shellcheck disable=SC2034,SC1091

jgdebug "ASDF Setup"

ASDF_DATA_DIR="${XDG_CONFIG_HOME}/asdf"
ASDF_DIR="${ASDF_HOME}"

PATH="${ASDF_DATA_DIR}/shims:${HOME}/go/bin:$PATH"
# . <(asdf completion bash)
