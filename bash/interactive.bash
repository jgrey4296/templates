#!/usr/bin/env bash
# Interactive Shell: "bash" | "bash -s" | "bash -i" ,
# with stdin and stderr connected to terminals
if [[ $- != *i* ]]; then
	return
fi
ISINTERACTIVE="yes"

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


source "$HOME/github/_templates/bash/_basic_utils.bash"
source "$HOME/github/_templates/bash/emacs.bash"

case "$OSTYPE" in
	darwin*)
		source "$HOME/github/_templates/bash/python_config.bash"
        init_py_env
        source "$HOME/github/_templates/bash/_aliases.bash"
		echo "Stopping Sarafi Bookmarks"; launchctl stop com.apple.SafariBookmarksSyncAgent
		;;
	linux*)
       source "$HOME/github/_templates/bash/python_config.bash"
       init_py_env
       init_sdkman
       source "$HOME/github/_templates/bash/_aliases.linux.bash"

       if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
           debian_chroot=$(cat /etc/debian_chroot)
       fi
       ;;
esac

jg_maybe_inc_prompt
jg_set_prompt
