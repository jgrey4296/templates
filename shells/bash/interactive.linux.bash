#  .bashrc -*- mode: sh -*-
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

echo "Linux Bash Interactive"
# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# shellcheck disable=SC1091
source "$root_dir/lib/aliases.bash"

if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Setup prompt
jg_maybe_inc_prompt
jg_set_prompt

# make less more friendly for non-text input files, see lesspipe(1)
# [ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"


# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
# alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# needs to be at end of file:
init-sdkman
