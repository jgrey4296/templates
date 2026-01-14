# prompt.bash -*- mode: sh -*-
# Prompt manipulation
JG_PROMPT=("_" "_")

function jg_set_prompt {
    # Set the term prompt with useful info
    PROMPT_COMMAND=(_direnv_hook _update_prompt)
    PS1='[${JG_PROMPT[0]}] | j:\j u:\u | ${JG_PROMPT[1]}: '
}

function _update_prompt {
  IFS="\n" mapfile -t JG_PROMPT <<< "$(jg-prompt-update)"
}

function jg_maybe_inc_prompt {
    # Increment the shell level each time you go into a subshell
    if [[ -n "${PROMPT_NUM:-}" ]] && [[ "${PROMPT_NUM:-}" -eq "${PROMPT_NUM:-}" ]] 2> /dev/null; then
        jg-debug "Prompt Level: $PROMPT_NUM"
        ((PROMPT_NUM++))
    else
        PROMPT_NUM=1
    fi
    jg-debug Depth Prompt: "${PROMPT_NUM-}"
}

function _direnv_hook() {
  # https://direnv.net/
  local previous_exit_status=$?;
  trap -- '' SIGINT;
  eval "$(/usr/bin/env direnv export bash)";
  trap - SIGINT;
  return "$previous_exit_status"
};
