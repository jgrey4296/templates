## python.nu -*- mode: Nushell -*-
# Summary:
#
#
#
#

export-env {

           let newpath = $env.PATH | prepend [
           ($env.HOME | path join "_cache_/mamba/envs" "default" "bin")
           ($env.HOME | path join ".local/bin/")
           ]

           $env.PATH   = $newpath
}
