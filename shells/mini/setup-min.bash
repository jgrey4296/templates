#!/usr/bin/env bash
# setup-min.bash -*- mode: sh -*-
#set -o errexit
set -o nounset
set -o pipefail

go install github.com/asdf-vm/asdf/cmd/asdf@v0.18.0

asdf plugin add eask https://github.com/jgrey4296/asdf-eask.git
asdf plugin add direnv

asdf set eask latest
asdf set direnv latest
