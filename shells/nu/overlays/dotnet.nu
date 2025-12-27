## dotnet.nu -*- mode: Nushell -*-
# use std


export def dotnet-blah [] {
    print "blah"
}

export-env {
        print $"(ansi light_blue)* dotnet...(ansi reset)"

            let DOTNET_ROOT                    = $env.BASELOCAL  | path join "dotnet"
            let DOTNET_TOOLS                   = $DOTNET_ROOT    | path join ".dotnet/tools"
            let DOTNET_CLI_HOME                = $env.BASECACHE  | path join "dotnet"
            let NUGET_PACKAGES                 = $env.BASECACHE  | path join "/dotnet/packages"

            let DOTNET_BUNDLE_EXTRACT_BASE_DIR = $env.BASECACHE  | path join "dotnet/bundle"
            let DOTNET_CLI_TELEMETRY_OPTOUT    = 1

            let _path = [
                        $DOTNET_TOOLS
                        ($DOTNET_ROOT | path join "tools")
                        $DOTNET_ROOT
            ]
            load-env {
                PATH            : ($env.PATH | prepend $_path)
                DOTNET_ROOT     : $DOTNET_ROOT
                NUGET_PACKAGES  : $NUGET_PACKAGES
                DOTNET_CLI_HOME : $DOTNET_CLI_HOME
            }

}
