## bindings.nu -*- mode: Nushell -*-
# https://www.nushell.sh/book/line_editor.html#keybindings
# inspect with 'keybindings list'
print "Configuring bindings..."
mut _bindings = []

$_bindings ++= [ {name: completion_menu
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
$_bindings ++= [{name: history_menu
               modifier: control
               keycode: char_r
               mode: [emacs, vi_insert, vi_normal]
               event: { send: menu name: history_menu }
    }]

$_bindings ++= [{name: next_page
               modifier: control
               keycode: char_x
               mode: emacs
               event: { send: menupagenext }
    }]
$_bindings ++= [{name: undo_or_previous_page_menu
               modifier: control
               keycode: char_z
               mode: emacs
               event: {
                      until: [
                             { send: menupageprevious }
                             { edit: undo }
                             ]
                      }
    }]
$_bindings ++= [{name: yank
               modifier: control
               keycode: char_y
               mode: emacs
               event: { until: [{edit: pastecutbufferafter}]}
    }]
$_bindings ++= [{name: unix-line-discard
               modifier: control
               keycode: char_u
               mode: [emacs, vi_normal, vi_insert]
               event: {
                      until: [
                             {edit: cutfromlinestart}
                             ]
                     }
    }]
$_bindings ++= [{name: kill-line
                modifier: control
                keycode: char_k
                mode: [emacs, vi_normal, vi_insert]
                event: {
                  until: [
                    {edit: cuttolineend}
                  ]
                }
    }]

# Menus
$_bindings = $_bindings ++ [
    {
      # Keybindings used to trigger the user defined menus
      name     : commands_menu
      modifier : control
      keycode  : char_t
      mode     : [emacs, vi_normal, vi_insert]
      event    : { send: menu name: commands_menu }
    }
    {
      name     : vars_menu
      modifier : alt
      keycode  : char_o
      mode     : [emacs, vi_normal, vi_insert]
      event    : { send: menu name: vars_menu }
    }
    {
      name     : commands_with_description
      modifier : control
      keycode  : char_s
      mode     : [emacs, vi_normal, vi_insert]
      event    : { send: menu name: commands_with_description }
    }
  ]

let bindings = $_bindings # convert to immutable
let bindings = { keybindings: $bindings }
