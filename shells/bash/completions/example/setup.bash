#  setup.bash -*- mode: sh -*-
# Source this file to register the completions

# https://dev.to/iridakos/adding-bash-completion-to-your-scripts-50da

# compgen - generate possible completion matches
# complete - specify completion specs
# compopt - modify completion options

function _completion_loader () {
    complete -F _comp_testcmd testcmd

    # complete -W "now tomorrow never" testcmd
}

function _comp_testcmd () {
    # $1 is command name,
    # $2 is word being completed
    # $3 is word preceding

    # add completions into COMPREPLY
    COMPREPLY=("blah" "bloo" "aweg")
    return 0
}

echo "Setting up Completion"
_completion_loader
