#  basic.nu -*- mode: nushell -*-
#

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
