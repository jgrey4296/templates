#  rust.bash -*- mode: sh -*-

# https://doc.rust-lang.org/cargo/reference/environment-variables.html
#
jg-debug "Setting up rust"
RUSTUP_HOME="${XDG_CACHE_HOME}/rustup"
CARGO_HOME="${XDG_CACHE_HOME}/cargo"

PATH="${CARGO_HOME}/bin:$PATH"

CARGO_BUILD_JOBS=1

# if [[ -e "${CARGO_HOME}/env" ]]; then
#     source "$CARGO_HOME/env"
# fi
