#!/usr/bin/env bash
# Prompt manipulation

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
        JG_PROMPT_INFO="asdf$JG_PROMPT_INFO"
    fi

    if [[ -n "${SDKMAN_PLATFORM}" ]]; then
        JG_PROMPT_INFO="sdkman:${JG_PROMPT_INFO}"
    fi

    if [[ -n "${INSIDE_EMACS}" ]]; then
        JG_PROMPT_INFO="emacs:${JG_PROMPT_INFO}"
    fi

    if [[ -n "${VIRTUAL_ENV}" ]]; then
        BASE_ENV=$(dirname "$VIRTUAL_ENV");
        BASE_ENV=$(basename "$BASE_ENV";)
        JG_PROMPT_INFO="venv(${BASE_ENV}):${JG_PROMPT_INFO}"
    elif [[ -n "${CONDA_DEFAULT_ENV-}" ]]; then
        JG_PROMPT_INFO="mamba(${CONDA_DEFAULT_ENV-}):${JG_PROMPT_INFO}"
    fi

    if [[ -n "$TMUX" ]]; then
        JG_PROMPT_INFO="TMUX:${JG_PROMPT_INFO}"
    fi

    if [[ -n "${DEPTH_PROMPT}" ]]; then
        JG_PROMPT_INFO="$DEPTH_PROMPT:${JG_PROMPT_INFO}"
    fi

    }

function jg_maybe_inc_prompt {
    # Increment the shell level each time you go into a subshell
    if [[ -n "$PROMPT_NUM" ]] && [[ $PROMPT_NUM -eq $PROMPT_NUM ]] 2> /dev/null; then
        jgdebug "Prompt Level: $PROMPT_NUM"
        ((PROMPT_NUM++))
    else
        PROMPT_NUM=1
    fi
    jgdebug Depth Prompt: "${DEPTH_PROMPT-}"
}

function _direnv_hook() {
  # https://direnv.net/
  local previous_exit_status=$?;
  trap -- '' SIGINT;
  eval "$(/usr/bin/env direnv export bash)";
  trap - SIGINT;
  return $previous_exit_status;
};
