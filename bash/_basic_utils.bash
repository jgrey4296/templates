#!/usr/bin/env bash

function jgdebug () {
    # a debug message that only prints when JGDEBUG is true
    if [[ -n "${JGDEBUG-}" ]]; then
        echo "%% " "$@"
    fi
}

jgdebug Debug is "${JGDEBUG-}"

# Prompt manipulation ----------------------------------------------

function jg_set_prompt {
    # Set the term prompt with useful info
    PROMPT_COMMAND='_direnv_hook;jg_prompt_update'
    # Also modified in .condarc
    PS1='[${JG_PROMPT_INFO}] | u:\u | j:\j |= $JGPATH: '
}

function jg_prompt_update {
    #setting up the prompt:
    # from https://unix.stackexchange.com/questions/216953
    local BASE_ENV
    JG_PROMPT_INFO=""
    DEPTH_PROMPT="${PROMPT_NUM-1}"
    if [ "${PROMPT_NUM-}" -lt 2 ]; then
        DEPTH_PROMPT="⟘"
    fi
    JGPATH=$(pwd | sed -r 's/.+?\/(.+?\/.+?)/...\/\1/')

    if [[ -n "${ASDF_DATA_DIR}" ]]; then
        JG_PROMPT_INFO=":asdf$JG_PROMPT_INFO"
    fi

    if [[ -n "${SDKMAN_PLATFORM}" ]]; then
        JG_PROMPT_INFO=":sdkman${JG_PROMPT_INFO}"
    fi

    if [[ -n "${VIRTUAL_ENV}" ]]; then
        BASE_ENV=$(dirname "$VIRTUAL_ENV");
        BASE_ENV=$(basename "$BASE_ENV";)
        JG_PROMPT_INFO=":venv(${BASE_ENV})${JG_PROMPT_INFO}"
    elif [[ -n "${CONDA_DEFAULT_ENV-}" ]]; then
        JG_PROMPT_INFO=":mamba(${CONDA_DEFAULT_ENV-})${JG_PROMPT_INFO}"
    fi

    if [[ -n "$TMUX" ]]; then
        JG_PROMPT_INFO="TMUX:${JG_PROMPT_INFO}"
    fi

    }

function jg_maybe_inc_prompt {
    # Increment the shell level each time you go into a subshell
    if [[ -n "$PROMPT_NUM" ]] && [[ $PROMPT_NUM -eq $PROMPT_NUM ]] 2> /dev/null; then
        jgdebug "Prompt Level: $PROMPT_NUM"
        PROMPT_NUM=$((PROMPT_NUM + 1))
    else
        PROMPT_NUM=1
    fi
    jgdebug Depth Prompt: "${DEPTH_PROMPT-}"
}

function randname (){
    # get a random name, for tmux session names
    shuf < /usr/share/dict/words | head -n 1 | sed "s/'//g"
}

function _direnv_hook() {
  # https://direnv.net/
  local previous_exit_status=$?;
  trap -- '' SIGINT;
  eval "$("/usr/bin/direnv" export bash)";
  trap - SIGINT;
  return $previous_exit_status;
};

# Tmux --------------------------------------------------

function loginmux () {
    # tmux aware session creation
    if [[ -n $TMUX  ]]; then
        return
    fi
    case "$TERM_PROGRAM" in
   	    tmux) return ;;
   	    emacs) return ;;

    esac

    if { tmux has-session; }; then
   	    echo "Tmux Session Running"
        tmux new-session -s "$(randname)"
    else
   	 echo "No Tmux Session"
     tmux new-session -s "$(randname)"
    fi
}

function attach () {
    # a simple tmux attach shortcut
    case "$TERM_PROGRAM" in
        tmux) return ;;
        emacs) return ;;
        *) tmux "attach" ;;
    esac
}

# user switching --------------------------------------------------

if [[ -z "$SU_WHITELIST" ]]; then
    SU_WHITELIST="TMUX,TERM_PROGRAM,PROMPT_NUM,TMUX_PANE"
    SU_WHITELIST="GNOME_SHELL_SESSION_MODE,XDG_CURRENT_DESKTOP,GNOME_TERMINAL_SCREEN,$SU_WHITELIST"
    SU_WHITELIST="GNOME_TERMINAL_SERVICE,GNOME_SETUP_DISPLAY,$SU_WHITELIST"
fi

case "$USER" in
    john)
        subu () {
            # switch to other profile
            # a su cmd that preserves tmux info
            su -P -l --whitelist-environment="$SU_WHITELIST" jg
        }
    ;;
    *) ;;
esac

# JVM  --------------------------------------------------

function init_sdkman () {
    # For activating sdkman in a subshell
    if [[ -e "${SDKMAN_DIR}/bin/sdkman-init.sh" ]]; then
        jgdebug "Initialising SDKMAN"
        # shellcheck disable=SC1091
        source "${SDKMAN_DIR}/bin/sdkman-init.sh"
    fi
}

