#!/usr/bin/env bash
# 15.rocq.bash -*- mode: sh -*-
#set -o errexit
set -o nounset
set -o pipefail

tag=$(gh release list --repo qpdf/qpdf --json tagName | jq .[0].tagName | sed -E "s/v//")
target="qpdf-${tag}-bin-linux-x86_64.zip"
directory="$HOME/Downloads"

gh release download --repo qpdf/qpdf -p "$target" -D "$directory"

if [[ ! -e "${directory}/${target}" ]]; then
    echo "Failed to download qpdf"
    exit 1
fi

# unzip into .local
mkdir -p "$HOME/.local/qpdf"
unzip "${directory}/${target}" -d "$HOME/.local/qpdf"

# symlink to .local/bin
ln -s "$HOME/.local/qpdf/bin/qpdf" "$HOME/.local"

# cleanup
rm "${directory}/${target}"
