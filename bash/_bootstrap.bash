#/usr/bin/bash
#
## Bootstrapping script for new systems
# https://stackoverflow.com/questions/18544359/how-do-i-read-user-input-into-a-variable-in-bash
# https://stackoverflow.com/questions/59895/how-do-i-get-the-directory-where-a-bash-script-is-located-from-within-the-script
# https://askubuntu.com/questions/252734/apt-get-mass-install-packages-from-a-file

# read -p "Continue? (Y/N): " confirm && [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]] || exit 1
# read -p "Test: " testval

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
CONFIG_REPO=$(realpath $(dirname "$SCRIPT_DIR"))

echo "----- BOOTSTRAPPING SYSTEM -----"
echo "Location: $CONFIG_REPO"

GITHUB=""

# Temp
exit 0

echo "Acting for OS Type"

APT_LIST="$CONFIG_REPO/templates/bootstrap/apt.install"
BREW_LIST="$CONFIG_REPO/templates/bootstrap/brew.install"
CACHE_DIRS=(
    "secrets"
    "conda"
    "cargo"
    "haskell"
    "gpg"
    "gradle"
    "bots"
    "logs"
    "mail"
    "ssh"
    )


case "$OSTYPE" in
    darwin*)

        for i in $(grep -vE "^\s*#" $BREW_LIST | tr "\n" " ");
        do
           brew install "$i"
        done
        ;;
    linux*)
        for i in "${CACHE_DIRS[@]}"; do
            mkdir -p "$HOME/_cache_/$i"
       done

       mkdir -p "$HOME/.config"

       ln -s "$CONFIG_REPO" "$HOME/.config/jg"
       # ln -s "$GITHUB" "$HOME/github"
       # ssh-keygen -t ed25519 -f "$BASE_CONFIG/secrets/ssh/ssh_ed25519"

       # apt-get install $(grep -vE "^\s*#" filename  | tr "\n" " ")

       # after gh is installed, authenticate

       # Setup SDKMAN!
       # export SDKMAN_DIR="$HOME/_cache_/sdkman"
       # curl -s "https://get.sdkman.io" | bash
      ;;
esac

# create conda envs
