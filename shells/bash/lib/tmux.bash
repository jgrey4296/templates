# tmux.bash -*- mode: sh -*-
# Tmux

function loginmux () {
    echo "-- TODO: tmux login fn"
}

function attach () {
    # a simple tmux attach shortcut
    case "${TERM_PROGRAM:-}" in
        tmux) return ;;
        emacs) return ;;
        *) tmux "attach" ;;
    esac
}
