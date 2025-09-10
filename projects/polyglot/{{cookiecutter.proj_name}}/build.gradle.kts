/*
 {{cookiecutter.proj_name}}

 Gradle build file for JaCaMo Applications
 October 18, 2023 - 00:59:47
*/
import java.io.ByteArrayOutputStream


////-- plugins
plugins {
    java
    id("maven-publish")
    id("org.jetbrains.kotlin.jvm") version "1.9.10"
}

////-- end plugins

version                    = "1.0"
group                      = "org.jacamo"

defaultTasks("run")

// can be used like implementation("...") : exampleConfig("...")
// val exampleConfig by configurations.creating {}
// apply ".jcm-deps.gradle" // this file contains dependencies declared in the .jcm files

////-- dependencies
java {
    toolchain {
        languageVersion.set(JavaLanguageVersion.of(17))
    }
}

repositories {
    mavenCentral()
    maven("https://raw.githubusercontent.com/jacamo-lang/mvn-repo/master")
    maven("https://repo.gradle.org/gradle/libs-releases")
    maven("https://jitpack.io")
    //maven url: "http://jacamo.sourceforge.net/maven2"
    //maven url: "https://jade.tilab.com/maven/"

    flatDir(Pair("dirs",  listOf("lib")))

}


dependencies {
    implementation("org.jacamo:jacamo:1.2")
}

////-- end dependencies

////-- source sets
sourceSets {
    main {
        java {
            srcDir("src/kt_{{cookiecutter.proj_name}}/environments")
            srcDir("src/kt_{{cookiecutter.proj_name}}/agents")
            srcDir("src/kt_{{cookiecutter.proj_name}}/organisations")
            srcDir("src/kt_{{cookiecutter.proj_name}}/kotlin")
            srcDir("src/kt_{{cookiecutter.proj_name}}/_configs")
        }
        resources {
            srcDir("src/_data")
        }
    }
}

////-- end source sets

////-- publishing
publishing {
    publications {
        create<MavenPublication>("maven") {
            from( components["java"] )
        }
    }
}

////-- end publishing

// //  --------------------------------------------------
// Tasks
tasks.register<JavaExec>("run") {
    dependsOn("classes")
    group = "JaCaMo"
    description = "runs the JaCaMo application"
    mainClass.set("jacamo.infra.JaCaMoLauncher")
    args("src/kt_{{cookiecutter.proj_name}}/_configs/{{cookiecutter.proj_name}}.jcm")
    // jvmArgs = "-Xss15m"
    classpath = sourceSets["main"].runtimeClasspath
    // classpath.set(sourceSets.get("main").getRuntimeClasspath())
    doFirst {
        mkdir(".temp/log")
    }
}

tasks.register<JavaExec>("buildJCMDeps") {
    dependsOn("classes")
    mainClass.set("jacamo.infra.RunJaCaMoProject")
    args("src/kt_{{cookiecutter.proj_name}}/_configs/{{cookiecutter.proj_name}}.jcm", "--deps")
    classpath = sourceSets["main"].runtimeClasspath
}

tasks.jar {
    duplicatesStrategy = DuplicatesStrategy.EXCLUDE
    archiveBaseName.set(project.name)

    from (project.projectDir.absolutePath + "/src") {
        include("**/*.asl")
        include("**/*.xml")
        include("**/*.sai")
        include("**/*.ptl")
        include("**/*.jcm")
        exclude("tests")
    }
    from (project.buildDir.absolutePath + "/classes") {
        include("**/*")
    }
}

tasks.register<Jar>("uberJar") {
    dependsOn("classes")
    group              = "JaCaMo"
    description        = "creates a single runnable jar file with all dependencies"
    archiveClassifier.set("uber")
    duplicatesStrategy = DuplicatesStrategy.EXCLUDE
    archiveBaseName.set("jacamo-{{cookiecutter.proj_name}}") // the name must start with jacamo so that jacamo...jar is found in the classpath
    manifest {
        attributes( mapOf( "Main-Class" to "jacamo.infra.JaCaMoLauncher" ) )
        }
    
    from(sourceSets.main.get().output)
    from({
             configurations.runtimeClasspath.get().filter {it.name.endsWith("jar") }.map { zipTree(it) }
         })
    from (project.projectDir.absolutePath) {
        include("**/*.asl")
        include("**/*.xml")
        include("**/*.sai")
        include("**/*.ptl")
        include("**/*.jcm")
        include("*.properties")
    }
    from (project.buildDir.absolutePath + "/jcm") {
        include( "**/*" )
    }
    

    doFirst {
        copy {
            from( "src/kt_{{cookiecutter.proj_name}}/_configs/{{cookiecutter.proj_name}}.jcm" )
            rename( "{{cookiecutter.proj_name}}.jcm","default.jcm" )
            into( project.buildDir.absolutePath + "/jcm" )
        }
    }
}

tasks.register("testJaCaMo") {
    description      = "runs JaCaMo unit tests"
    var errorOnTests = false
    outputs.upToDateWhen { false } // disable cache
    var stdout = ByteArrayOutputStream()
    var errout = ByteArrayOutputStream()
    
    doFirst {
        try {
            javaexec {
                mainClass.set("jacamo.infra.JaCaMoLauncher")
                if (gradle.startParameter.logLevel.toString().equals("DEBUG")) {
                    args("src/kt_{{cookiecutter.proj_name}}/tests/tests.jcm", "--log-conf", "jason/templates/console-debug-logging.properties")
                } else if (gradle.startParameter.logLevel.toString().equals("INFO")) {
                    args("src/kt_{{cookiecutter.proj_name}}/tests/tests.jcm", "--log-conf", "jason/templates/console-info-logging.properties")
                } else {
                    args("src/kt_{{cookiecutter.proj_name}}/tests/tests.jcm", "--log-conf", "jason/templates/console-lifecycle-logging.properties")
                }
                classpath = sourceSets.main.get().runtimeClasspath
                
                standardOutput = stdout
                errorOutput    = errout
            }
        } catch (e : Exception) {
            errorOnTests = true
        }
    }

    doLast {
        // val styler = "black red green yellow blue magenta cyan white"
        //     .split(" ")
        //     .withIndex()
        //     .associate { (key, value) -> Pair(key, { it : String -> "\\033[${value}m${it}\\033[0m" }) }

        stdout.toString().lines().map  { line ->
            println(line)
            // println(line.replace("TESTING","${styler["yellow"]("TESTING")}")
            //             .replace("PASSED","${styler["green"]("PASSED")}")
            //             .replace("FAILED","${styler["red"]("FAILED")}")
            //             .replace("TODO","${styler["magenta"]("TODO")}")
            //             .replace("LAUNCHING","${styler["blue"]("LAUNCHING")}")
            // )
        }

        errout.toString().lines().map { line ->
            println(line)
            // println(line.replace("TESTING","${styler["yellow"]("TESTING")}")
            //             .replace("PASSED","${styler["green"]("PASSED")}")
            //             .replace("FAILED","${styler["red"]("FAILED")}")
            //             .replace("TODO","${styler["magenta"]("TODO")}")
            //             .replace("LAUNCHING","${styler["blue"]("LAUNCHING")}")
            // )
        }

        if (errorOnTests) {
            throw GradleException("JaCaMo unit tests: ERROR!")
        }
    }
}

tasks.test {
    finalizedBy("testJaCaMo")
}

tasks.clean {
    delete(".temp")
    delete("bin")
    delete("build")
    delete("log")
}

