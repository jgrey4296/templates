#  .bashrc -*- mode: bash-ts -*-
#
#set -o errexit
set -o nounset
set -o pipefail

[[ -n "${XDG_CACHE_HOME:-}" ]] || export XDG_CACHE_HOME="$HOME/.cache"

export GOPATH="$XDG_CACHE_HOME/go"
export GOBIN="$GOPATH/bin"
export ASDF_DATA_DIR="$XDG_CACHE_HOME/asdf"
export ASDF_DIR="${ASDF_HOME:-}"
export PATH="${ASDF_DATA_DIR}/shims:$GOBIN:$PATH"
