#!/usr/bin/env bash
# 0.check.bash -*- mode: sh -*-
#set -o errexit
set -o nounset
set -o pipefail

if [[ -z "$XDG_CONFIG_HOME" ]]; then
    echo "no XDG_CONFIG_HOME"
    exit 1
fi

if [[ ! -h "$XDG_CONFIG_HOME/.templates" ]]; then
    echo "no templates symlink"
    exit 1
fi
