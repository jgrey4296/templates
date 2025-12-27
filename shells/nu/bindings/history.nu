#  history.nu -*- mode: nushell -*-
#

$_bindings ++= [{name: history_menu
               modifier: control
               keycode: char_r
               mode: [emacs, vi_insert, vi_normal]
               event: { send: menu name: history_menu }
}]
