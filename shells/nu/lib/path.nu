## path.nu -*- mode: Nushell -*-
# Summary:
#
#
#
use std
print "- Path..."

const nu_in_templates = $nu.config-path | path dirname

# Split path as a string:
# let _path = $env.PATH | split row (char esep)

# But I build from scratch:
export-env {
        mut _path: list<string> = [
                "jg-custom-path"
                "/snap/bin"
                "/sbin"
                "/bin"
                "/usr/sbin"
                "/usr/bin"
                "/usr/libexec"
                "/usr/local/sbin"
                "/usr/local/bin"
                $"($nu_in_templates)/scripts"
        ]

        if "CARGO_HOME" in $env {
                $_path = $_path | append ($env.CARGO_HOME | path join "bin")
        }
        $_path = $_path | append ($env.HOME | path join ".local/bin/")

        load-env {
            PATH : ($_path | reverse | path expand | uniq)
        }
}
