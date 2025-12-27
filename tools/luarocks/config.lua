-- -*-Lua-*-
-- Symlink to ~/.config/lurarocks/config.lua
-- or /etc/luarocks/config.lua
-- https://github.com/luarocks/luarocks/wiki/Config-file-format
rocks_trees = {
  home..[[/_cache_/luarocks]]
  [[/usr/local]]
}

-- for storing Lua modules written in Lua (absolute path inside the rock entry of the rocks tree). Example:
LUADIR  = "/home/john/_cache_/luarocks"
-- for storing Lua modules written in C (absolute path inside the rock entry of the rocks tree). Example:
LIBDIR  = "/home/john/_cache_/luarocks/lib"
-- for storing command-line scripts (absolute path inside the rock entry of the rocks tree). Example:
BINDIR  = "/home/john/_cache_/luarocks/bin"
-- for storing configuration files for a module (absolute path inside the rock entry of the rocks tree). Example:
CONFDIR = "/home/john/_cache_/luarocks/conf"

INCDIR  = "/home/john/_cache_/luarocks/inc"
