#!/usr/bin/env bash
# 7.ssh.bash -*- mode: sh -*-
#set -o errexit
set -o nounset
set -o pipefail

ssh-add "$XDG_CONFIG_HOME/secrets/github/github_ssh"
ssh-add "$XDG_CONFIG_HOME/secrets/gitlab/gitlab_ssh"

ssh -T git@github.com
if [[ "$?" != 0 ]]; then
    echo "failed to connect to github ssh"
fi

ssh -T git@gitlab.com
if [[ "$?" != 0 ]]; then
    echo "failed to connect to gitlab ssh"
fi
