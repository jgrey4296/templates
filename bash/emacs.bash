#!/usr/bin/env bash

# TODO use update-alternatives
#
## --- Startup
jgdebug "Setting emacs data"
BLOOD_SRC="$HOME/github/lisp/blood"
EDITOR="vim"

EMACSDIR="$HOME/.emacs.d"
DOOMDIR="$HOME/.config/jg/"

if [[ -n "$INSIDE_EMACS" ]]; then
    echo "Inside Emacs"
    set disable-completion on
    TERM=dumb
fi

## --- Main Entry
function set-emacs () {
    # Call as: set-emacs [doom|blood] [apt|flatpak]
    case "$1" in
        "doom")
            set-doom
            ;;
        "doom2")
            set-doom-alt
            ;;
        "blood")
            set-blood
            ;;
        *)
            echo "Unrecognised emacs framework: $1"
            ;;
        esac

    case "$2" in
        "apt")
            set-apt-emacs
            ;;
        "flatpak")
            set-flatpak-emacs
            ;;
        "snap")
            set-snap-emacs
            ;;
        *)
            echo "Unrecognized emacs type: $2"
            ;;
        esac
}

## --- Specific variants
function set-doom () {
    echo "doom current"
    EMACSDIR="/media/john/data/github/_libs/lisp/doom_2"
    DOOMDIR="$HOME/.config/jg/"

    if [[ -e "$HOME/.local/bin/doom" ]]; then
        rm "$HOME/.local/bin/doom"
    fi
    ln -s "$EMACSDIR/bin/doom" "$HOME/.local/bin/doom"

    retarget-emacs-d "$EMACSDIR"
}

function set-doom-alt () {
    echo "doom alt"
    EMACSDIR="/media/john/data/github/_libs/lisp/doomemacs"
    DOOMDIR="$HOME/.config/jg/"

    if [[ -e "$HOME/.local/bin/doom" ]]; then
        rm "$HOME/.local/bin/doom"
    fi
    ln -s "$EMACSDIR/bin/doom" "$HOME/.local/bin/doom"

    retarget-emacs-d "$EMACSDIR"
}

function set-blood () {
    echo "BLOOD"
    EMACSDIR="$BLOOD_SRC"
    BLOOD_CONFIG="$EMACSDIR/example"
    if [[ -e "$HOME/.local/bin/doom" ]]; then
        rm "$HOME/.local/bin/doom"
    fi

    retarget-emacs-d "$EMACSDIR"
}

function set-apt-emacs () {
    echo "apt"
    EMACSBIN="/usr/bin/emacs"

    retarget-emacs-bin "$EMACSBIN"
}

function set-snap-emacs () {
    echo "snap"
    EMACSBIN="/snap/bin/emacs"

    retarget-emacs-bin "$EMACSBIN"
}

function set-flatpak-emacs () {
    echo "flatpak"
    EMACSBIN="/var/lib/flatpak/exports/bin/org.gnu.emacs"

    retarget-emacs-bin "$EMACSBIN"
}

## --- Utils
function retarget-emacs-d () {
    if [[ -d "$HOME/.emacs.d" ]] && [[ ! ( -L "$HOME/.emacs.d" ) ]]; then
        echo "Emacs Dir isn't a symlink"
        exit 1
    elif [[ (-L "$HOME/.emacs.d") ]]; then
        # There is an existing emacs.d
        rm "$HOME/.emacs.d"
    fi

    ln -s "$1" "$HOME/.emacs.d"

}

function retarget-emacs-bin () {
    # Link emacsdir and emacs into local
    if [[ -e "$HOME/.local/bin/emacs" ]] && [[ ! ( -L "$HOME/.local/bin/emacs" ) ]]; then
        echo "local emacs bin isn't a symlink"
        exit 1
    elif [[ -L "$HOME/.local/bin/emacs" ]]; then
        rm "$HOME/.local/bin/emacs"
    fi

    ln -s "$1" "$HOME/.local/bin/emacs"
}

## --- Info
function read-emacs () {
    local curr_emacs="$(basename $(readlink -f $HOME/.emacs.d))"
    echo "Emacs: $curr_emacs"
}

function report-emacs () {
    echo "Emacs       : $(readlink $HOME/.local/bin/emacs)"
    echo "blood       : $BLOOD_SRC : $BLOOD_CONFIG"
    echo ".emacs.d    : $(readlink -f $HOME/.emacs.d)"
    echo ".doom.d     : $DOOMDIR"
}

function check-emacs-d () {
    if [[ ! -e "$HOME/.emacs.d" ]]; then
        echo "ERROR: No emacs.d"
        # ln -s "$EMACSDIR" "$HOME/.emacs.d"
    fi

    if [[ (-L "$HOME/.emacs.d")
            && ($(readlink -f "$HOME/.emacs.d") != $(readlink -f "$EMACSDIR"))
        ]]; then
        echo "ERROR: emacs.d does not match EMACSDIR"
        rm "$HOME/.emacs.d"
        ln -s "$EMACSDIR" "$HOME/.emacs.d"
    fi
}
