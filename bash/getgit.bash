#!/usr/bin/env bash
set -euo pipefail

function getgit () {
    # Prints the remote urls for each git repo found directly below the cwd
    for D in $(find . -maxdepth 1 -type d); do
        if [[ -d "${D}/.git" ]]; then
            echo "Is Git: ${D}"
            cd "./${D}"
            git remote -v
            cd ..
        fi
    done
}
