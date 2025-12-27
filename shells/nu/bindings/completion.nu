#  completion.nu -*- mode: nushell -*-
#

$_bindings ++= [{name: completion_menu
                modifier: none
                keycode: tab
                mode: [emacs vi_normal vi_insert]
                event: {
                until: [
                       { send: menu name: completion_menu }
                       { send: menunext }
                ]
      }
    }]

$_bindings ++= [{name: completion_previous
                modifier: shift
                keycode: backtab
                mode: [emacs, vi_normal, vi_insert] # Note: You can add the same keybinding to all modes by using a list
                event: { send: menuprevious }
    }]
