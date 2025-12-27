## plugins.nu -*- mode: Nushell -*-
print "- Plugins..."

mut plugins = {}
$plugins.plugins = {
  # Per-plugin configuration. See https://www.nushell.sh/contributor-book/plugins.html#configuration.
}
$plugins.plugin_gc =  {
      # Configuration for plugin garbage collection
      default : {
          enabled    : true # true to enable stopping of inactive plugins
          stop_after : 10sec # how long to wait after a plugin is inactive to stop it
      }
      plugins : {
          # alternate configuration for specific plugins, by name, for example:
          #
          # gstat: {
          #     enabled: false
          # }
      }
}
