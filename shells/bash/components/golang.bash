#!/usr/bin/env bash
# golang.bash -*- mode: sh -*-

jgdebug "Golang Setup"

GOPATH="$XDG_CACHE_HOME/go"
GOBIN="$GOPATH/bin"

PATH="$GOBIN:$PATH"
