## cmds.nu -*- mode: Nushell -*-
print "Configuring cmds..."

mut cmds = {}
$cmds.ls = {
    use_ls_colors   : true # use the LS_COLORS environment variable to colorize output
    clickable_links : false # enable or disable clickable links. Your terminal has to support links.
}
$cmds.rm = {
    always_trash    : true # always act as if -t was given. Can be overridden with -p
  }

$cmds.table = {
    mode: rounded # basic, compact, compact_double, light, thin, with_love, rounded, reinforced, heavy, none, other
    index_mode: always # "always" show indexes, "never" show indexes, "auto" = show indexes when a table has "index" column
    show_empty: true # show 'empty list' and 'empty record' placeholders for command output
        padding: { left: 1, right: 1 } # a left right padding of each column in a table
    trim: {
      methodology: wrapping # wrapping or truncating
      wrapping_try_keep_words: true # A strategy used by the 'wrapping' methodology
      truncating_suffix: "..." # A suffix used by the 'truncating' methodology
    }
    header_on_separator: false # show header text on separator/border line
    # abbreviated_row_count: 10 # limit data rows from top and bottom after reaching a set point
    }


$cmds.history = {
    max_size      : 100_000 # Session has to be reloaded for this to take effect
    sync_on_enter : true # Enable to share history between multiple sessions, else you have to close the session to write history to file
    file_format   : "plaintext" # "sqlite" or "plaintext"
    isolation     : false # only available with sqlite file_format. true enables history isolation, false disables it. true will allow the history to be isolated to the current session using up/down arrows. false will allow the history to be shared across all sessions.
}
$cmds.explore = {
    help_banner           : true
    exit_esc              : true
    command_bar_text      : '#C4C9C6'
    # command_bar         : {fg: '#C4C9C6' bg: '#223311' }
    status_bar_background : { fg: '#1D1F21' bg: '#C4C9C6' }
    # status_bar_text     : {fg: '#C4C9C6' bg: '#223311' }
    highlight             : { bg: 'yellow' fg: 'black' }
  }
$cmds.explore.status = {
      # warn: {bg: 'yellow', fg: 'blue'}
      # error: {bg: 'yellow', fg: 'blue'}
      # info: {bg: 'yellow', fg: 'blue'}
    }
$cmds.explore.try = {
      # border_color: 'red'
      # highlighted_color: 'blue'
      # reactive: false
    }
$cmds.explore.table = {
      split_line             : '#404040'
      cursor                 : true
      line_index             : true
      line_shift             : true
      line_head_top          : true
      line_head_bottom       : true
      show_head              : true
      show_index             : true
      # selected_cell        : {fg: 'white', bg: '#777777'}
      # selected_row         : {fg: 'yellow', bg: '#C1C2A3'}
      # selected_column      : blue
      # padding_column_right : 2
      # padding_column_left  : 2
      # padding_index_left   : 2
      # padding_index_right  : 1
    }

$cmds.explore.config = {
      cursor_color   : { bg: 'yellow' fg: 'black' }
      # border_color : white
      # list_color   : green
      }
