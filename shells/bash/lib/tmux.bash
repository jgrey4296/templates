#!/usr/bin/env bash
# Tmux

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
