# Settings for dotnet / c#
# https://learn.microsoft.com/en-us/dotnet/core/tools/dotnet-environment-variables
#
DOTNET_ROOT="$HOME/.local/dotnet"
DOTNET_CLI_HOME="$BASE_CACHE/dotnet"
NUGET_PACKAGES="$BASE_CACHE/dotnet/packages"

DOTNET_BUNDLE_EXTRACT_BASE_DIR="$BASE_CACHE/dotnet/bundle"
DOTNET_CLI_TELEMETRY_OPTOUT=1

PATH="$BASE_CACHE/dotnet/.dotnet/tools:$DOTNET_ROOT/tools:$DOTNET_ROOT:$PATH"
