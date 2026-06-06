#!/usr/bin/env bash
# 20.user.bash -*- mode: sh -*-
#set -o errexit
set -o nounset
set -o pipefail

base="$POLYGLOT_ROOT/usr_home"

echo "---- Copying user config files"

# Base Files
fdfind -d 1 -t f -H "$base"
# cp "$base/" "$HOME/"

mkdir -p "$HOME/.config/secrets"
# .config
# .config/gpg : by system
# .local/share/applications
# .ssh
