#  asdf.bash -*- mode: sh -*-
# shellcheck disable=SC2034,SC1091

jg-debug "ASDF Setup"

ASDF_DATA_DIR="${XDG_CACHE_HOME}/asdf"
ASDF_DIR="${ASDF_HOME:-}"

PATH="${ASDF_DATA_DIR}/shims:${HOME}/go/bin:$PATH"
# . <(asdf completion bash)
