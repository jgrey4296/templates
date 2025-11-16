# -*- mode: snippet -*-
# name  : prop.app
# uuid  : prop.app
# key   : prop.app
# group : rules operators apply propose
# --
sp{$1*propose
    (state <s> ^type state)
-->
    # (write |-- Proposing $1| (crlf))
    (<s> ^operator <o1> +)
    (<o1> ^name $1)
}

sp{$1*apply
    (state <s> ^type state)
    (<s> ^operator $1)
-->
    (write |-- Applying $1| (crlf))
    $0
}