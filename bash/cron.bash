#!/usr/bin/env bash

# # from: https://itecnotes.com/server/cron-how-to-use-the-aliases-in-the-crontab/
shopt -s expand_aliases

source "$XDG_CONFIG_HOME/.templates/bash/lib/utils.bash"
source "$XDG_CONFIG_HOME/.templates/bash/lib/path.bash"
source "$XDG_CONFIG_HOME/.templates/bash/components/rust.bash"
source "$XDG_CONFIG_HOME/.templates/bash/components/latex.bash"
source "$XDG_CONFIG_HOME/.templates/bash/components/jvm.bash"

CPU_MAX="50"
function cpu_check(){
    if [[ $# > 1 ]]
    then
        CPU_MAX="$1"
    fi

    if [[ -z "$CPU_MAX" ]]
    then
        CPU_MAX="50"

    fi

    # echo "CPU Max: $CPU_MAX"
    CPU=( $(top -l1 -n0 | awk '/CPU/ {print $0}') )
    UserPerc=( "${CPU[2]}" )
    TESTSTR="${UserPerc[0]/\%/} > ${CPU_MAX}"
    HIGH=$(echo "$TESTSTR" | bc)

    # echo "$TESTSTR : $HIGH"
    if [[ $HIGH -eq 1 ]]
    then
        say -v Moira -r 50 "CPU Usage is higher than ${CPU_MAX} %"
    # else
        # echo "CPU Usage is fine"
    fi
}
