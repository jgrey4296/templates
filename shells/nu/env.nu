# Nushell Environment Config File
# version = "0.93.0"
# First file loaded on startup.
use std
print $"(ansi green_italic)----------
Configuring Env...
----------(ansi reset)"

# Directories to search for scripts when calling source or use
# The default for this is $nu.default-config-dir/scripts
const nu_in_templates = $nu.config-path | path dirname

source $"($nu_in_templates)/lib/path.nu"

$env.NU_LIB_DIRS = [
    $nu_in_templates
    ($nu_in_templates | path join "lib")
    ($nu_in_templates | path join "bindings")
    ($nu_in_templates | path join "components")
    ($nu_in_templates | path join "overlays")
    # ($nu_in_templates | path join 'scripts') # add <nushell-config-dir>/scripts
]

# Directories to search for plugin binaries when calling register
# The default for this is $nu.default-config-dir/plugins
$env.NU_PLUGIN_DIRS = [
    ($nu.default-config-dir | path join 'plugins') # add <nushell-config-dir>/plugins
]

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

$env.JG = {}
$env.JG.locations = {
  cache      : ($env.HOME       | path join "_cache_")
  config     : ($env.HOME       | path join ".config")
  secrets    : ($env.HOME       | path join ".config/secrets")
  local      : ($env.HOME       | path join ".local")
  github     : ($env.HOME       | path join "github")
  templates  : ($env.HOME       | path join "github/_templates")
  logs       : ($env.HOME       | path join "logs")
}

$env.BASECACHE     = $env.jg.locations.cache
$env.BASECONFIG    = $env.jg.locations.config
$env.BASELOCAL     = $env.jg.locations.local
$env.GITHUB        = $env.jg.locations.github
$env.TEMPLATES     = $env.jg.locations.templates
$env.BASELOGS      = $env.jg.locations.logs
$env.SECRETS       = $env.jg.locations.secrets


print ""
