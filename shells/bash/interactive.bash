#!/usr/bin/env bash
# Interactive Shell: "bash" | "bash -s" | "bash -i" ,
# with stdin and stderr connected to terminals
if [[ $- != *i* ]]; then
	return
fi
# shellcheck disable=SC2034
IS_INTERACTIVE="yes"
echo "Interactive"

root_dir="$XDG_CONFIG_HOME/.templates/shells/bash"
echo "Root Dir: $root_dir"

# shellcheck disable=SC1091
source "$root_dir/lib/utils.bash"

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


# #THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
# export SDKMAN_DIR="~/.cache/sdkman"
# [[ -s "~/.cache/sdkman/bin/sdkman-init.sh" ]] && source "~/.cache/sdkman/bin/sdkman-init.sh"
init-sdkman
