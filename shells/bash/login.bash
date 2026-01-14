#!/usr/bin/env bash
# shellcheck disable=SC2034
IS_LOGIN="yes"

if [[ "${TMUX:-}" ]]; then
	echo "Login: $OSTYPE : $TERM : TMUX"
else
	echo "Login: $OSTYPE : $TERM"
fi
echo "Date  : $(date).  CWD: $(pwd)"

shopt -u cmdhist
shopt -s checkwinsize

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

export HISTSIZE=20
export HISTFILESIZE=20
export HISTFILE="$XDG_CACHE_HOME/logs/bash_history"
export NO_AT_BRIDGE=1

current_script_path="${BASH_SOURCE[0]}"
root_dir="$XDG_CONFIG_HOME/.templates/shells/bash"
echo "Bash Config Root Dir: $root_dir"

# shellcheck disable=SC1091
source "$root_dir/lib/utils.bash"
# shellcheck disable=SC1091
source "$root_dir/lib/path.bash"
# shellcheck disable=1091
source "$root_dir/lib/exports.bash"

BASH_ENV="$root_dir/non_interactive.bash"
jg-debug "Path  : $PATH"

source_components
jg_maybe_inc_prompt
jg_set_prompt
init-sdkman
init-ssh
loginmux
