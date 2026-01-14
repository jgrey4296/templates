#  _base_path.bash -*- mode: sh -*-

# jg-debug Setting Initial Path

export BASE_CACHE="$HOME/_cache_"
export BASE_CONFIG="$HOME/.config"
export JG_CONFIG="$HOME/github/_templates"
export GH_CONFIG_DIR="$BASE_CONFIG/gh"
export SECRETSDIR="$BASE_CONFIG/secrets"

# https://specifications.freedesktop.org/basedir-spec/latest/
export XDG_CONFIG_HOME="$BASE_CONFIG"
export XDG_CACHE_HOME="$BASE_CACHE"
export XDG_STATE_HOME="$HOME/.local/state"
# xdg_data_home xdg_state_home xdg_data_dirs xdg_config_dirs
# xdg_runtime_dir

# wipe the path, and mark it so I know its mine
# shellcheck disable=SC2123
PATH="/jg_path"

case "$OSTYPE" in
    linux*)
        PATH="/snap/bin:$PATH"
        PATH="/usr/local/games:$PATH"
        ;;
    *)
        fail "---- BAD OS: $OSTYPE ----"
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
        # jg-debug Setting sqlite
        PATH="/usr/local/opt/sqlite/bin:$PATH"
        ;;
    linux*)
        PATH="$JG_CONFIG/shells/scripts:$PATH"
        ;;
esac


# MAN Paths
# https://www.howtogeek.com/682871/how-to-create-a-man-page-on-linux/
MANPATH="/usr/local/man:/usr/local/share/man:/usr/share/man"
MANPATH="$HOME/.local/share/man:$MANPATH"
MANPATH="$HOME/github/_templates/man/main:$MANPATH"
# shellcheck disable=SC2034
INFOPATH=""
