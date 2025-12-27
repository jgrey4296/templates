## setup_table.nu -*- mode: Nushell -*-
# Summary:
#
#
#
use std
print $"(ansi green)* Table...(ansi reset)"

$cmds.table = {
  # "always" show indexes, "never" show indexes, "auto" = show indexes when a table has "index" column
  index_mode : always
  # show 'empty list' and 'empty record' placeholders for command output
  show_empty : true
  # show header text on separator/border line
  header_on_separator: false
  # a left right padding of each column in a table
  padding  : { left: 1, right: 1 }
  trim     : {
    # wrapping or truncating
    methodology: wrapping
    # A strategy used by the 'wrapping' methodology
    wrapping_try_keep_words: true
    # A suffix used by the 'truncating' methodology
    truncating_suffix: "..."
  }
  # abbreviated_row_count: 10 # limit data rows from top and bottom after reaching a set point
}
