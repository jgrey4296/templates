#!/usr/bin/env bash
# 10.etc.bash -*- mode: sh -*-
#set -o errexit
set -o nounset
set -o pipefail

# sudo cp "$POLYGLOT_ROOT/etc/" "/etc/"
# etc/hosts
sudo cp "$POLYGLOT_ROOT/etc/hosts" "/etc/hosts"

# etc/security
# etc/ssh
sudo cp "$POLYGLOT_ROOT/etc/ssh/ssh_config.d/ssh_config" "/etc/ssh/sshd_config.d/"
sudo cp "$POLYGLOT_ROOT/etc/ssh/sshd_config.d/sshd_config" "/etc/ssh/sshd_config.d/"
