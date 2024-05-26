## dotnet.nu -*- mode: Nushell -*-



export-env {
           let build_tools_version = "33.0.2"
           let android_home        = ($env.HOME | path join "android")
           let android_tools       = [
                ($android_home  | path join "build-tools" $build_tools_version "bin")
                ($android_home  | path join "platform-tools")
                ($android_home  | path join "cmdline-tools/latest/bin")
            ]

           load-env {
                STUDIO_HOME       : "/snap/android-studio/current"
                ANDROID_HOME      : $android_home
                ANDROID_USER_HOME : ($env.BASECACHE  | join "android")
                ADB_VENDOR_KEYS   : ($env.BASECONFIG | path join "secrets/android")
                ANDROID_TOOLS     : $android_tools
                # SDKMAN_DIR        : ($env.BASECACHE | path join "sdkman")
                GRADLE_USER_HOME  : ($env.BASECACHE | path join "gradle")
                PATH              : ($env.PATH | prepend $android_tools)
           }

}
