## utils.nu -*- mode: Nushell -*-
export-env {
    print "Adding util funcs"
}

export def cmerge [...recs] {
    # Merges TOP LEVEL ONLY dicts, will clobber subdicts with same name
    mut total = {}
    for $n in $recs {
        $total = ($total | merge $n)
    }
    $total
}

export def nuopen [arg, --raw (-r)] {
    if $raw { open -r $arg } else { open $arg }
}
