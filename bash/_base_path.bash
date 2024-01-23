# #  _base_path.bash -*- mode: sh -*-

jgdebug Setting Initial Path

export BASE_CACHE="$HOME/.cache"
export BASE_CONFIG="$HOME/.config"
export XDG_CONFIG_HOME="$BASE_CONFIG"
export JG_CONFIG="$HOME/github/_templates"
export GH_CONFIG_DIR="$BASE_CONFIG/gh"
export SECRETSDIR="$BASE_CONFIG/secrets"

PATH="/jg_path"

case "$OSTYPE" in
    darwin*) 
        BREW_PREFIX="/usr/local"
        ;;
    linux*) 
        PATH="/snap/bin:$PATH"
        PATH="/usr/local/games:$PATH"
        ;;
esac

PATH="/bin:/sbin:$PATH"                                  # Core
PATH="/usr/bin:/usr/sbin:/usr/libexec:$PATH"             # Secondary
PATH="/usr/local/bin:/usr/local/sbin:$PATH"              # Tertiary

PATH="$HOME/.local/bin:$PATH"                            # local binaries

case "$OSTYPE" in
    darwin*)
        PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
        PATH="/usr/local/opt/make/libexec/gnubin:$PATH"
        PATH="/usr/local/opt/findutils/libexec/gnubin:$PATH"
        jgdebug Setting sqlite
        PATH="/usr/local/opt/sqlite/bin:$PATH"
        ;;
    linux*)
        ;;
esac


# MAN Paths
# https://www.howtogeek.com/682871/how-to-create-a-man-page-on-linux/
MANPATH="/usr/local/man:/usr/local/share/man:/usr/share/man"
MANPATH="$HOME/github/_templates/man/main:$MANPATH"
INFOPATH=""
