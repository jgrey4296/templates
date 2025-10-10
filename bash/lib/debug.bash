#!/usr/bin/env bash

function jgdebug () {
    # a debug message that only prints when JGDEBUG is true
    if [[ -n "${JGDEBUG-}" ]]; then
        echo "%% " "$@"
    fi
}
