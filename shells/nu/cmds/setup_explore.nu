## explore.nu -*- mode: Nushell -*-
# Summary:
#
#
#
use std
print $"(ansi green)* Explore...(ansi reset)"

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
