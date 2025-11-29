## path.nu -*- mode: Nushell -*-
# Summary:
#
#
#

# Split path as a string:
# let _path = $env.PATH | split row (char esep)

# But I build from scratch:
let _path = [
        "/usr/local/bin"
        "/usr/local/sbin"
        "/usr/libexec"
        "/usr/bin"
        "/usr/sbin"
        "/bin"
        "/sbin"
        "/snap/bin"
]
let _path = $_path | path expand | uniq
$env.PATH = $_path
std path add ($env.CARGO_HOME | path join "bin")
std path add ($env.HOME | path join ".local/bin/")
