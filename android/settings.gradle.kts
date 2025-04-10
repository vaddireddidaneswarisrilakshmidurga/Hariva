pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.PREFER_PROJECT)
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.name = "hariva"
include(":app")

// Flutter specific configuration
val flutterProjectRoot = rootProject.projectDir.parentFile.absolutePath
apply(from = "$flutterProjectRoot/.android/include_flutter.groovy")
