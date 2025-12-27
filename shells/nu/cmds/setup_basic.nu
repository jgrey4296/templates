## setup_basic.nu -*- mode: Nushell -*-
# Summary:
#
#
#
print $"(ansi green)* Basic...(ansi reset)"

$cmds.ls = {
    use_ls_colors   : true # use the LS_COLORS environment variable to colorize output
    clickable_links : false # enable or disable clickable links. Your terminal has to support links.
}
$cmds.rm = {
    always_trash    : true # always act as if -t was given. Can be overridden with -p
  }

$cmds.history = {
    max_size      : 100_000 # Session has to be reloaded for this to take effect
    sync_on_enter : true # Enable to share history between multiple sessions, else you have to close the session to write history to file
    file_format   : "plaintext" # "sqlite" or "plaintext"
    isolation     : false # only available with sqlite file_format. true enables history isolation, false disables it. true will allow the history to be isolated to the current session using up/down arrows. false will allow the history to be shared across all sessions.
}
