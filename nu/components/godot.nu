## godot.nu -*- mode: Nushell -*-


export def gdscript [...args] {
       godot --headless --check-only --script $args
}
