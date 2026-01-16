#  utils.bash -*- mode: sh -*-
#set -o errexit
set -o nounset
set -o pipefail

function fail () {
    echo "Failed: $*"
    exit 1
}

# shellcheck disable=SC1091
source "$root_dir/lib/prompt.bash"
# shellcheck disable=SC1091
source "$root_dir/lib/tmux.bash"
# shellcheck disable=SC1091
source "$root_dir/lib/user_switch.bash"
# shellcheck disable=SC1091
source "$root_dir/lib/components.bash"

function init-sdkman () {
    set +o nounset
    # For activating sdkman in a subshell
    # should be called at the end of bash_profile or bashrc
    if [[ -e "${SDKMAN_DIR}/bin/sdkman-init.sh" ]]; then
        jg-debug "Initialising SDKMAN"
        # shellcheck disable=SC1091
        source "${SDKMAN_DIR}/bin/sdkman-init.sh"
    fi
}
