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

root_dir="$XDG_CONFIG_HOME/.templates/shells/bash"
echo "Root Dir: $root_dir"

# shellcheck disable=SC1091
source "$root_dir/lib/utils.bash"
# shellcheck disable=SC1091
source "$root_dir/lib/emacs.bash"

case "$OSTYPE" in
	linux*)
       # shellcheck disable=SC1091
       source "$root_dir/lib/aliases.bash"

       if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
           debian_chroot=$(cat /etc/debian_chroot)
       fi
       # Setup prompt
       jg_maybe_inc_prompt
       jg_set_prompt
       ;;
    *)
       fail "Bad OS"
       ;;
esac
