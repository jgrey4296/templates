
jgdebug "Setting Up Godot"

# alias gscript="godot --headless --script"
# alias gslint="godot --headless --check-only --script"

function gdscript () {
    case "$OSTYPE" in
        darwin*)
            godot --headless -s "$@"
            osascript -e "tell application \"iTerm\"" -e "activate" -e "end tell"
            ;;
        linux*)
            godot-4 --headless -s "$@"
            ;;
    esac
}

export -f gdscript
