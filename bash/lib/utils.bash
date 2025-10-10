#!/usr/bin/env bash

function fail () {
    echo "Failed: $*"
    exit 1
}

function ppath () {
    echo "Path: "
    local count=0
    local IFS=":"
    for i in $PATH; do
        echo "- $i"
        ((count++))
    done
    echo "Size: $count"
}

# shellcheck disable=SC1091
source "$root_dir/lib/debug.bash"
# shellcheck disable=SC1091
source "$root_dir/lib/prompt.bash"
# shellcheck disable=SC1091
source "$root_dir/lib/tmux.bash"
# shellcheck disable=SC1091
source "$root_dir/lib/user_switch.bash"
# shellcheck disable=SC1091
source "$root_dir/lib/components.bash"
