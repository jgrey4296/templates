#!/usr/bin/env bash
# Interactive Shell: "bash" | "bash -s" | "bash -i" ,
# with stdin and stderr connected to terminals
if [[ $- != *i* ]]; then
	return
fi
# shellcheck disable=SC2034
IS_INTERACTIVE="yes"

echo "Interactive"
# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# shellcheck disable=SC1091
source "$HOME/github/_templates/bash/_basic_utils.bash"
# shellcheck disable=SC1091
source "$HOME/github/_templates/bash/emacs.bash"

case "$OSTYPE" in
	darwin*)
       # shellcheck disable=SC1091
        source "$HOME/github/_templates/bash/_aliases.bash"
		echo "Stopping Safari Bookmarks"; launchctl stop com.apple.SafariBookmarksSyncAgent
		;;
	linux*)
       # shellcheck disable=SC1091
       source "$HOME/github/_templates/bash/_aliases.linux.bash"

       if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
           debian_chroot=$(cat /etc/debian_chroot)
       fi
       init_sdkman
       ;;
esac

# Setup prompt
jg_maybe_inc_prompt
jg_set_prompt
