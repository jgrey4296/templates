#  dotnet.bash -*- mode: sh -*-
# Settings for dotnet / c#
# https://learn.microsoft.com/en-us/dotnet/core/tools/dotnet-environment-variables
#
# for DOTNET_ROOT, use `asdf where dotnet`
DOTNET_CLI_HOME="$XDG_CACHE_HOME/dotnet"
NUGET_PACKAGES="$XDG_CACHE_HOME/dotnet/packages"

DOTNET_BUNDLE_EXTRACT_BASE_DIR="$XDG_CACHE_HOME/dotnet/bundle"
DOTNET_CLI_TELEMETRY_OPTOUT=1

