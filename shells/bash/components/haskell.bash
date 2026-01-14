#  haskell.bash -*- mode: sh -*-

jg-debug "Setting haskell"
# don't forget to update emacs haskell program name variable when modifying this

alias whaskell="ghci -Wall -fwarn-name-shadowing"
alias hs="haskell"

CABAL_CONFIG="$XDG_CONFIG_HOME/.cabalrc"
CABAL_DIR="$XDG_CACHE_HOME/cabal"
