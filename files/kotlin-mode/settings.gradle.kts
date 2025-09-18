// `(f-filename (buffer-file-name))` -*- mode: kotlin-ts -*-
pluginManagement {
    repositories {
        gradlePluginPortal()
        google()
        mavenCentral()
    }
}

rootProject.name = "$1"

include(":app")
