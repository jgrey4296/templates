## latex.nu -*- mode: Nushell -*-


export-env {
           let tex_year = 2023
           let latex_path = ($env.BASELOCAL | path join "texlive" $tex_year "bin/x86_64-linux")
           load-env {
                    PATH : ($env.PATH | prepend [$latex_path])

            }
}
