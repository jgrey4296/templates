# -*- mode: snippet -*-
# name  : cargo.profile
# uuid  : cargo.profile
# key   : cargo.profile
# group : rust cargo
# --
[profile.$1]
# https://doc.rust-lang.org/cargo/reference/profiles.html
opt-level         = 0            # Optimization level.
debug             = true         # Include debug info.
split-debuginfo   = '...'        # Debug info splitting behavior.
debug-assertions  = true         # Enables debug assertions.
overflow-checks   = true         # Enables runtime integer overflow checks.
lto               = false        # Sets link-time optimization.
panic             = 'unwind'     # The panic strategy.
incremental       = true         # Incremental compilation.
codegen-units     = 16           # Number of code generation units.
rpath             = false        # Sets the rpath linking option.

[profile.<name>.build-override]  # Overrides build-script settings.

[profile.<name>.package.<name>]  # Override profile for a package.