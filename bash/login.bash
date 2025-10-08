#!/usr/bin/env bash
# shellcheck disable=SC2034
IS_LOGIN="yes"

if [[ $TMUX ]]; then
	echo "Login: $OSTYPE : $TERM : TMUX"
else
	echo "Login: $OSTYPE : $TERM"
fi
echo "Date  : $(date).  CWD: $(pwd)"

export NO_AT_BRIDGE=1

# shellcheck disable=SC1091
source "$HOME/github/_templates/bash/_basic_utils.bash"
# shellcheck disable=SC1091
source "$HOME/github/_templates/bash/_base_path.bash"

shopt -s globstar
case "$OSTYPE" in
	linux*)
		 for i in "$HOME"/github/_templates/bash/components/*.bash;
		 do
			 case $(basename "$i") in
				 _*.bash)
					  jgdebug "-- SKIPPING: $i"
					  ;;
				 *)
					  jgdebug "-- Sourcing: $i"
					  # shellcheck disable=SC1090,SC1091
					  source "$i"
					  ;;
			 esac
		 done
		 # init_sdkman
		 # shellcheck disable=SC1091
		 source "$HOME/github/_templates/bash/_aliases.linux.bash"
         ;;
	*)
		 echo "-- BAD OSTYPE: $OSTYPE --"
		 exit 1
		 ;;
esac

BASH_ENV="$HOME/github/_templates/bash/non_interactive.bash"
# shellcheck disable=1091
source "$HOME/github/_templates/bash/emacs.bash"
# shellcheck disable=1091
source "$HOME/github/_templates/bash/_exports.bash"

jgdebug "Path  : $PATH"

read-emacs
jg_maybe_inc_prompt
jg_set_prompt

loginmux
