#!/usr/bin/env bash
# 2.bash.bash -*- mode: sh -*-
#set -o errexit
set -o nounset
set -o pipefail

ln -s "$XDG_CONFIG_HOME/.templates/shells/bash/interactive.bash" "$HOME/.bashrc"
ln -s "$XDG_CONFIG_HOME/.templates/shells/bash/login.bash" "$HOME/.bash_profile"
ln -s "$XDG_CONFIG_HOME/.templates/shells/tmux/tmux.conf" "$HOME/.tmux.conf"

ln -s "$XDG_CONFIG_HOME/.templates/managers/asdfrc" "$HOME/.asdfrc"
ln -s "$XDG_CONFIG_HOME/.templates/projects/cookiecutterrc" "$HOME/.cookiecutterrc"

ln -s "$XDG_CONFIG_HOME/.templates/vim/vimrc" "$HOME/.vimrc"


# Git
mkdir -p "$XDG_CONFIG_HOME/git"
mkdir -p "$XDG_CONFIG_HOME/gh"
ln -s "$XDG_CONFIG_HOME/.templates/git/gitconfig" "$XDG_CONFIG_HOME/git/config"
ln -s "$XDG_CONFIG_HOME/.templates/git/gitignore_global" "$XDG_CONFIG_HOME/git/gitignore_global"
ln -s "$XDG_CONFIG_HOME/.templates/git/github/github_config.yml" "$XDG_CONFIG_HOME/gh/config.yml"

# python
mkdir -p "$XDG_CONFIG_HOME/uv"
ln -s "$XDG_CONFIG_HOME/.templates/python/uv.toml" "$XDG_CONFIG_HOME/uv/uv.toml"
