#!/usr/bin/env bash

function source_components () {
    shopt -s globstar
    case "$OSTYPE" in
        linux*)
            local count=0
            for i in "$root_dir/components/"*.bash;
            do
                case $(basename "$i") in
                    _*.bash)
                        jgdebug "-- SKIPPING: $i"
                        ;;
                    *)
                        jgdebug "-- Sourcing: $i"
                        # shellcheck disable=SC1090,SC1091
                        source "$i"
                        ((count++))
                        ;;
                esac
            done
            echo "Loaded $count components"
            # shellcheck disable=SC1091
            source "$root_dir/lib/aliases.bash"
            ;;
        *)
            fail "-- BAD OSTYPE: $OSTYPE --"
            ;;
    esac

}
