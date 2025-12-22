#!/usr/bin/env bash
# sshconfig.bash -*- mode: sh -*-
#set -o errexit
# set -o nounset
# set -o pipefail

function init-ssh () {
    echo "Initialising SSH"
    base="$XDG_CONFIG_HOME/secrets"
    targets=("ssh" "github" "gitlab" "android")

    for val in "${targets[@]}"
    do
        echo "- adding $val"
        for file in "$base/$val/"*
        do
            statres=$(stat -c "%a" "$file")
            if [[ -f "$file" ]] && [[ "$statres" = "600" ]]; then
                ssh-add "$file"
            fi
        done
    done

}
