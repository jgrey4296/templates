#!/usr/bin/env bash
ISLOGIN="yes"

if [[ $TMUX ]]; then
	echo "Login: $OSTYPE : $TERM : TMUX"
else
	echo "Login: $OSTYPE : $TERM"
fi
echo "Date  : $(date).  CWD: $(pwd)"

export NO_AT_BRIDGE=1

source "$HOME/github/_templates/bash/_basic_utils.bash"
source "$HOME/github/_templates/bash/_base_path.bash"

case "$OSTYPE" in
	darwin*)
		 jgdebug "Activating components"
		 for fname in $(find "$HOME/github/_templates/bash/components" -type f -name "*.bash" -not -regex "_.+?\.bash")
		 do
		     jgdebug "-- Sourcing: $fname"
		     source "$fname"
		 done
		 source "$HOME/github/_templates/bash/python_config.bash"
		 init_py_env
		 source "$HOME/github/_templates/bash/_aliases.mac.bash"
		 ;;
	linux*)
		 for fname in $(find "$HOME/github/_templates/bash/components" -type f -name "*.bash" -not -regex "_.+?\.bash")
		 do
		     jgdebug "-- Sourcing: $fname"
		     source "$fname"
		 done
        source "$JG_CONFIG/bash/python_config.bash"
		init_py_env
		init_sdkman
		source "$HOME/github/_templates/bash/_aliases.linux.bash"
        ;;
esac

BASH_ENV="$HOME/github/_templates/bash/non_interactive.bash"
source "$HOME/github/_templates/bash/emacs.bash"
source "$HOME/github/_templates/bash/_exports.bash"

jgdebug "Path  : $PATH"

read-emacs
jg_maybe_inc_prompt
jg_set_prompt

loginmux
