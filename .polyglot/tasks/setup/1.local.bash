#!/usr/bin/env bash
# 1.local.bash -*- mode: sh -*-
#set -o errexit
set -o nounset
set -o pipefail

echo "---- Building local directories"

mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.local/modules"
mkdir -p "$HOME/.local/share/fonts"

mkdir -p "$XDG_CONFIG_HOME/git"
mkdir -p "$XDG_CONFIG_HOME/gh"
