# Nushell Environment Config File
# version = "0.93.0"
use std
source ~/.config/.templates/nu/utils.nu
source ~/.config/.templates/nu/path.nu

# Use nushell functions to define your right and left prompt
# $env.PROMPT_COMMAND       = {|| create_left_prompt }
# FIXME: This default is not implemented in rust code as of 2023-09-08.
# $env.PROMPT_COMMAND_RIGHT = {|| create_right_prompt }

# The prompt indicators are environmental variables that represent
# the state of the prompt
$env.PROMPT_INDICATOR           = {|| "> " }
$env.PROMPT_INDICATOR_VI_INSERT = {|| ": " }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| "> " }
$env.PROMPT_MULTILINE_INDICATOR = {|| "::: " }

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
$env.ENV_CONVERSIONS = {
  "PATH": {
        from_string : { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string   : { |v| $v | path expand --no-symlink | str join (char esep) }
  }
  "Path": {
        from_string : { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string   : { |v| $v | path expand --no-symlink | str join (char esep) }
  }
}

# Directories to search for scripts when calling source or use
# The default for this is $nu.default-config-dir/scripts
let nu_in_templates = $nu.config-path | path dirname
$env.NU_LIB_DIRS = [
    $nu_in_templates
    ($nu_in_templates | path join 'scripts') # add <nushell-config-dir>/scripts
    ($nu_in_templates | path join "components")
]

# Directories to search for plugin binaries when calling register
# The default for this is $nu.default-config-dir/plugins
$env.NU_PLUGIN_DIRS = [
    ($nu.default-config-dir | path join 'plugins') # add <nushell-config-dir>/plugins
]

$env.BASECACHE     = ($env.HOME | path join "_cache_")
$env.BASECONFIG    = ($env.HOME | path join ".config")
$env.BASELOCAL     = ($env.HOME | path join ".local")
$env.GITHUB        = ($env.HOME | path join "github")
$env.TEMPLATES     = ($env.GITHUB | path join "_templates")
$env.BASELOGS      = ($env.BASECACHE | path join "logs")
$env.SECRETS       = ($env.BASECONFIG | path join "secrets")
