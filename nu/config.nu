# Nushell Config File
#
# version = "0.93.0"

# For more information on defining custom themes, see
# https://www.nushell.sh/book/coloring_and_theming.html
# And here is the theme collection
# https://github.com/nushell/nu_scripts/tree/main/themes
#
print "Configuring Nu..."
source ~/.config/.templates/nu/utils.nu
source ~/.config/.templates/nu/themes.nu
source ~/.config/.templates/nu/cmds.nu
source ~/.config/.templates/nu/bindings.nu
source ~/.config/.templates/nu/hooks.nu
source ~/.config/.templates/nu/menus.nu
source ~/.config/.templates/nu/plugins.nu

alias open = ^open

mut general = {
    show_banner                      : false # true or false to enable or disable the welcome banner at startup
    color_config                     : $dark_theme   # if you want a light theme, replace `$dark_theme` to `$light_theme`
    use_grid_icons                   : true
    footer_mode                      : "25" # always, never, number_of_rows, auto
    float_precision                  : 2 # the precision for displaying floats in tables
    # buffer_editor                  : "emacs" # command that will be used to edit the current line buffer with ctrl+o, if unset fallback to $env.EDITOR and $env.VISUAL
    use_ansi_coloring                : true
    edit_mode                        : vi # emacs, vi
    shell_integration                : true # enables terminal markers and a workaround to arrow keys stop working issue
    render_right_prompt_on_last_line : false # true or false to enable or disable right prompt to be rendered on last line of the prompt.
    use_kitty_protocol               : false # enables keyboard enhancement protocol implemented by kitty console, only if your terminal support this.
    highlight_resolved_externals     : false # true enables highlighting of external commands in the repl resolved by which.
    recursion_limit                  : 50 # the maximum number of times nushell allows recursion before stopping it
}

$general.completions = {
    case_sensitive : false # set to true to enable case-sensitive completions
    quick          : true  # set this to false to prevent auto-selecting completions when only one remains
    partial        : true  # set this to false to prevent partial filling of the prompt
    algorithm      : "prefix"  # prefix or fuzzy
    use_ls_colors  : true # set this to true to enable file/path/directory completions using LS_COLORS
    external       : {
      enable: true # set to false to prevent nushell looking into $env.PATH to find more suggestions, `false` recommended for WSL users as this look up may be very slow
      max_results: 100 # setting it lower can improve completion performance at the cost of omitting some options
      completer: null # check 'carapace_completer' above as an example
    }
  }
$general.filesize = {
    metric : true # true => KB, MB, GB (ISO standard), false => KiB, MiB, GiB (Windows standard)
    format : "auto" # b, kb, kib, mb, mib, gb, gib, tb, tib, pb, pib, eb, eib, zb, zib, auto
  }
$general.cursor_shape = {
        emacs     : line # block, underscore, line, blink_block, blink_underscore, blink_line, inherit to skip setting cursor shape (line is the default)
        vi_insert : block # block, underscore, line, blink_block, blink_underscore, blink_line, inherit to skip setting cursor shape (block is the default)
        vi_normal : underscore # block, underscore, line, blink_block, blink_underscore, blink_line, inherit to skip setting cursor shape (underscore is the default)
  }

# Combine all into config------------------------------------------
$env.config = (cmerge $general $bindings $cmds $hooks $menus $plugins)
