#  jvm.bash -*- mode: sh -*-
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

jg-debug "Setting JVM"
BUILD_TOOLS="33.0.2"

# ANDROID_HOME="/usr/lib/android-sdk"
ANDROID_HOME="$XDG_CACHE_HOME/android"
ANDROID_USER_HOME="$XDG_CACHE_HOME/android"
ADB_VENDOR_KEYS="$XDG_CONFIG_HOME/secrets/android"

PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"
# ANDROID_TOOLS="$ANDROID_HOME/cmdline-tools/latest/bin"
# ANDROID_TOOLS="$ANDROID_HOME/build-tools/$BUILD_TOOLS/bin:$ANDROID_TOOLS"
# ANDROID_TOOLS="$ANDROID_HOME/platform-tools:$ANDROID_TOOLS"


jg-debug "Setting up SDKMAN"
SDKMAN_DIR="$XDG_CACHE_HOME/sdkman"

jg-debug "Setting Gradle"
GRADLE_USER_HOME="$XDG_CACHE_HOME/gradle"
