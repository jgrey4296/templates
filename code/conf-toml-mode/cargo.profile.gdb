# -*- mode: snippet -*-
# name  : profile.gdb
# uuid  : profile.gdb
# key   : profile.gdb
# group : rust cargo debugging
# --
[profile.gdb]
inherits         = "dev"
opt-level        = 0
debug            = true
split-debuginfo  = 'packed'
strip            = 'none'
debug-assertions = true
overflow-checks  = true
lto              = "no"
panic            = 'unwind'
incremental      = true
codegen-units    = 256
rpath            = false
rustflags        = ['--emit=obj,link']