## python.nu -*- mode: Nushell -*-
# Summary: wraps micromamba and auto converts some output to json
# see https://github.com/nushell/nu_scripts/blob/93e71fe6a899d2eba3165874a08609804c0af9ad/modules/virtual_environments/nu_conda_2/conda.nu
#
#
#
alias _pip   = pip
alias _mamba = mamba

def --env load-conda-info-env [] {
    if ("CONDA_INFO" in $env) {
        return $env.CONDA_INFO
    }

    let envs = mamba env list
    let info = mamba info
    export-env {
        $env.CONDA_INFO = {
            current     : $info."env location"
            root        : $info."base environment"
            envs_dirs   : $info."envs directories"
            shlvl       : (if "CONDA_SHLVL" in $info { $info.CONDA_SHLVL } else { 1 })
            }
        }

    }

export def --env "mamba activate" [env_name: string =""] {
       load-conda-info-env
       let new_env_dir = $env.CONDA_INFO.envs_dirs | path join $env_name
       if not ($new_env_dir | path exists) {
            error make { msg: $"Env Not Found: ($env_name)", dir: $env.CONDA_INFO.envs_dirs  }
    }
       let new_env = {
           PATH                      : ($env.PATH | prepend [($new_env_dir | path join "bin")])
           CONDA_DEFAULT_ENV         : $env_name
           CONDA_PREFIX              : $new_env_dir
           MAMBA_ROOT_PREFIX         : $env.CONDA_INFO.root
           CONDA_SHLVL               : ($env.CONDA_SHLVL + 1)
           PRE_COMMIT_USE_MICROMAMBA : 1

       }
       print $"Env: ($env_name)"
       load-env $new_env
}



export def "mamba env list" [] {
       _mamba env list --json | from json
}
export def "mamba info" [] {
       _mamba info --json | from json
}
export def "mamba config list" [] {
       _mamba config list --json | from json
}

export def "pip list" [] {
       _pip list --format json | from json
}


export-env {
           print "Setting up Python"
           load-conda-info-env
           if not ("CONDA_INFO" in $env) {
                error make {"msg" : "didn't get the conda info"}
           }
           let _path = [
                ($env.CONDA_INFO.envs_dirs | path join "default" "bin")
           ]
           let _dyld = ($env.DYLD_FALLBACK_LIBRARY_PATH
                        | split row (char esep)
                        | prepend [($env.BASELOCAL | path join "modules")]
                        | uniq
                        )
           load-env {
                PATH                       : ($env.PATH | prepend [ ($env.CONDA_INFO.envs_dirs | path join "default" "bin")])
                CONDA_DEFAULT_ENV          : "default"
                CONDA_PREFIX               : ($env.CONDA_INFO.envs_dirs | path join "default")
                MAMBA_ROOT_PREFIX          : $env.CONDA_INFO.root
                CONDA_SHLVL                : $env.CONDA_INFO.shlvl
                PRE_COMMIT_USE_MICROMAMBA  : 1
                PYTHONSTARTUP              : ($env.TEMPLATES | path join "python" "repl_startup.py")
                DYLD_FALLBACK_LIBRARY_PATH : $_dyld
           }
}
