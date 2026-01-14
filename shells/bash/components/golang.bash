# golang.bash -*- mode: sh -*-

jg-debug "Golang Setup"

GOPATH="$XDG_CACHE_HOME/go"
GOBIN="$GOPATH/bin"

PATH="$GOBIN:$PATH"
