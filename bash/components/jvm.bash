#!/usr/bin/env bash
# https://developer.android.com/tools/variables
# Required sdkmanager packages:
# Android SDK Build Tools
# Android SDK Platform Tools
# Android SDK Command-Line Tools
# Android SDK Platform
# Google USB Driver
#
# https://sdkman.io
#
# android sdk home is deprecated, use android_home

jgdebug "Setting JVM"
BUILD_TOOLS="33.0.2"

# ANDROID_HOME="/usr/lib/android-sdk"
ANDROID_HOME="$XDG_CACHE_HOME/android"
ANDROID_USER_HOME="$XDG_CACHE_HOME/android"
ADB_VENDOR_KEYS="$XDG_CONFIG_HOME/secrets/android"

# ANDROID_TOOLS="$ANDROID_HOME/cmdline-tools/latest/bin"
# ANDROID_TOOLS="$ANDROID_HOME/build-tools/$BUILD_TOOLS/bin:$ANDROID_TOOLS"
# ANDROID_TOOLS="$ANDROID_HOME/platform-tools:$ANDROID_TOOLS"


jgdebug "Setting up SDKMAN"
SDKMAN_DIR="$XDG_CACHE_HOME/sdkman"

jgdebug "Setting Gradle"
GRADLE_USER_HOME="$XDG_CACHE_HOME/gradle"

jgdebug "Setting Jason"
JASON_HOME="$HOME/.local/jason-3.2.2"

jgdebug "Setting JACAMO"
JACAMO_HOME="$HOME/.local/jacamo-1.2.2"

function init_sdkman () {
    # For activating sdkman in a subshell
    if [[ -e "${SDKMAN_DIR}/bin/sdkman-init.sh" ]]; then
        jgdebug "Initialising SDKMAN"
        # shellcheck disable=SC1091
        source "${SDKMAN_DIR}/bin/sdkman-init.sh"
    fi
}

init_sdkman
