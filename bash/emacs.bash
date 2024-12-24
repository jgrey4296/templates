#!/usr/bin/env bash

jgdebug "Setting emacs data"
BLOOD_SRC="$HOME/github/lisp/blood"
EDITOR="vim"

jg_use_EMACS="$(which emacs)"
EMACSDIR="$HOME/.emacs.d"
DOOMDIR="$HOME/.config/jg/"

# LOCS
case "$OSTYPE" in
    darwin*)
        ENAT_DIR="$HOME/github/_libs/lisp/doomemacs"
        ENAT_BIN="/usr/local/Cellar/emacs-plus@28/28.2/bin/emacs"
        ;;

    linux*)
        ENAT_DIR="/media/john/data/github/_libs/lisp/doomemacs"
        ENAT_BIN="/usr/bin/emacs"
        ;;
esac

if [[ -n "$INSIDE_EMACS" ]]; then
    echo "Inside Emacs"
    set disable-completion on
    TERM=dumb
fi

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

function set-emacs () {
    case "$1" in
        "doom")
            echo "doom current"
            jg_use_EMACS="$ENAT_BIN"
            EMACSDIR="/media/john/data/github/_libs/lisp/doom_2"
            DOOMDIR="$HOME/.config/jg/"
            ;;
        *native* | doom*)
            echo "Setting Obsolete Doom"
            jg_use_EMACS="$ENAT_BIN"
            EMACSDIR="$ENAT_DIR"
            DOOMDIR="$HOME/.config/jg/"
            ;;
        "blood")
            echo "BLOOD"
            jg_use_EMACS="$ENAT_BIN"
            EMACSDIR="$BLOOD_SRC"
            # TODO
            BLOOD_CONFIG="$EMACSDIR/example"
            ;;
        "snap")
            echo "gtk"
            jg_use_EMACS="/snap/bin/emacs"
            EMACSDIR="$ENAT_DIR"
            DOOMDIR="$HOME/.config/jg/"
            ;;
        *)
            echo "Unrecognized emacs type: $1"
            # EMACS="$NAT_BIN"
            EMACSDIR="$ENAT_DIR"
        ;;
        esac

    if [[ -d "$HOME/.emacs.d" ]] && [[ ! ( -L "$HOME/.emacs.d" ) ]]; then
        echo "Emacs Dir isn't a symlink"
    elif [[ ! ( -L "$HOME/.emacs.d" ) ]]; then
        # Theres no emacs.d link
        ln -s "$EMACSDIR" "$HOME/.emacs.d"
    elif [[ (-L "$HOME/.emacs.d")
            && ($(readlink -f "$HOME/.emacs.d") != $(readlink -f "$EMACSDIR"))
        ]]; then
        # There is an existing emacs.d
        rm "$HOME/.emacs.d"
        ln -s "$EMACSDIR" "$HOME/.emacs.d"
    fi
    PATH="$EMACSDIR/bin/:$PATH"
}

function read-emacs () {
    local curr_emacs="$(basename $(readlink -f $HOME/.emacs.d))"
    echo "Emacs: $curr_emacs"
}

function report-emacs () {
    echo "Emacs       : $jg_use_EMACS"
    echo "blood       : $BLOOD_SRC : $BLOOD_CONFIG"
    echo ".emacs.d    : $EMACSDIR"
    echo " .doom.d    : $DOOMDIR"
}

function emacs (){
    `$jg_use_EMACS -nw $@`
}

function emacsw() {
    `$jg_use_EMACS $@`
}

export jg_use_EMACS
export -f emacs
export -f emacsw
