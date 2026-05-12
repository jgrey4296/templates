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
	linux*) source "$root_dir/interactive.linux.bash" ;;
    *) fail "Bad OS" ;;
esac

