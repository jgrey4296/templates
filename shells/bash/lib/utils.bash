#!/usr/bin/env bash

function fail () {
    echo "Failed: $*"
    exit 1
}

# shellcheck disable=SC1091
source "$root_dir/lib/prompt.bash"
# shellcheck disable=SC1091
source "$root_dir/lib/tmux.bash"
# shellcheck disable=SC1091
source "$root_dir/lib/user_switch.bash"
# shellcheck disable=SC1091
source "$root_dir/lib/components.bash"
