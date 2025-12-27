#  menus.nu -*- mode: nushell -*-
#

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
