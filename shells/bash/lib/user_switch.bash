# user_switch.bash -*- mode: sh -*-
# user switching

if [[ -z "${SU_WHITELIST:-}" ]]; then
    SU_WHITELIST="TMUX,TERM_PROGRAM,PROMPT_NUM,TMUX_PANE"
    SU_WHITELIST="GNOME_SHELL_SESSION_MODE,XDG_CURRENT_DESKTOP,GNOME_TERMINAL_SCREEN,$SU_WHITELIST"
    SU_WHITELIST="GNOME_TERMINAL_SERVICE,GNOME_SETUP_DISPLAY,$SU_WHITELIST"
fi

case "$USER" in
    john)
        subu () {
            echo "Switching to JG for blood"
            # switch to other profile
            # a su cmd that preserves tmux info
            su -P -l --whitelist-environment="$SU_WHITELIST" jg
        }
    ;;
    *) ;;
esac
