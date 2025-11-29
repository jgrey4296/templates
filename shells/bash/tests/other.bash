#!/usr/bin/env bash
set -euo pipefail

my_val="bloo"

current_script_path="${BASH_SOURCE[0]}"
current_dir=$(dirname "$current_script_path")

source "$current_dir/a_test.bash"

function bloo () {
    echo "my_val = $my_val"
    blah
}

bloo
