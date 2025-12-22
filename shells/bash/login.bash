#!/usr/bin/env bash
# shellcheck disable=SC2033
IS_LOGIN="yes"

if [[ $TMUX ]]; then
	echo "Login: $OSTYPE : $TERM : TMUX"
else
	echo "Login: $OSTYPE : $TERM"
fi
echo "Date  : $(date).  CWD: $(pwd)"

export NO_AT_BRIDGE=1

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

current_script_path="${BASH_SOURCE[0]}"
root_dir="$XDG_CONFIG_HOME/.templates/shells/bash"
echo "Bash Config Root Dir: $root_dir"

# shellcheck disable=SC1091
source "$root_dir/lib/utils.bash"
# shellcheck disable=1091
source "$root_dir/lib/sshconfig.bash"
# shellcheck disable=SC1091
source "$root_dir/lib/path.bash"
# shellcheck disable=1091
source "$root_dir/lib/exports.bash"

BASH_ENV="$root_dir/non_interactive.bash"
jgdebug "Path  : $PATH"

source_components
jg_maybe_inc_prompt
jg_set_prompt
init-sdkman
init-ssh
loginmux
