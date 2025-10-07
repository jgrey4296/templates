#!/usr/bin/env bash

jgdebug "Setting Exports"

# Personal
export JGLOGDIR

# General
export HISTFILE="$BASE_CACHE/logs/bash_history"
export LESSHISTFILE="$BASE_CACHE/logs/lesshst"
export NODE_REPL_HISTORY="$BASE_CACHE/logs/node_repl_history"
export G_MESSAGES_PREFIXED="" # To get rid of atk-bridge complaints
export PATH
export EDITOR
export PROMPT_NUM
export TERM
export MANPATH
export BASH_ENV
export GPG_TTY
export GNUPGHOME
export GTAGSLABEL
export BASH_SILENCE_DEPRECATION_WARNING=1

# JVM
export ANDROID_HOME
export ANDROID_USER_HOME
export ADB_VENDOR_KEYS
export JDK_HOME
export JAVA_HOME
export JACAMO_HOME
export GRADLE_USER_HOME
export SDKMAN_DIR
export CLIPS_HOME

# Emacs
export EMACSDIR
export DOOMDIR

# Latex
export TEXBASE

# CMake
export CMAKE_BUILD_PARALLEL_LEVEL
export CMAKE_BUILD_PARALLEL_LEVEL
export make_jobs

# Python
export DYLD_FALLBACK_LIBRARY_PATH
export PYTHONSTARTUP
export IPYTHONDIR
export USE_EMOJI

# Haskell
export CABAL_CONFIG
export CABAL_DIR
export CARGO_HOME

# Ocaml
export OPAMROOT
export OPAM_SWITCH_PREFIX
export CAML_LD_LIBRARY_PATH
export OCAML_TOPLEVEL_PATH
export CEPTRE_HOME

# Rust
export RUSTUP_HOME
export CARGO_HOME

# Mail
export MUHOME
export MAILDIR
export MBOX

# Dotnet
export DOTNET_ROOT
export NUGET_PACKAGES
export DOTNET_CLI_HOME
export DOTNET_BUNDLE_EXTRACT_BASE_DIR
export DOTNET_CLI_TELEMETRY_OPTOUT

# Elixir
export ASDF_DATA_DIR


# Functions
export -f jgdebug
export -f jg_maybe_inc_prompt
export -f jg_prompt_update
export -f jg_set_prompt
export -f randname
