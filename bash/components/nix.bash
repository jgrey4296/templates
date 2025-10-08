#!/usr/bin/env bash
# https://nix.dev/manual/nix/2.28/command-ref/env-common.html
# set -euo pipefail

NIX_HOME="/nix/var/nix/profiles/default"

# NIX_PATH
# NIX_IGNORE_SYMLINK_STORE
# NIX_[STORE,DATA,LOG,STATE,CONF]_DIR
# NIX_CONFIG
# NIX_USER_CONF_FILE
# TMPDIR
# NIX_REMOTE
# NIX_SHOW_STATES
# NIX_COUNT_CALLS
# GC_INITIAL_HEAP_SIZE

PATH="$NIX_HOME/bin:$PATH"

source "$NIX_HOME/etc/profile.d/nix-daemon.sh"
