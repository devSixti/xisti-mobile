allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
    configurations.configureEach {
        resolutionStrategy {
            // 1.1.7 is 16 KB page-size safe; 1.2.0 libdatastore_shared_counter.so fails Play prelaunch.
            force("androidx.datastore:datastore:1.1.7")
            force("androidx.datastore:datastore-android:1.1.7")
            force("androidx.datastore:datastore-core:1.1.7")
            force("androidx.datastore:datastore-core-android:1.1.7")
            force("androidx.datastore:datastore-preferences:1.1.7")
            force("androidx.datastore:datastore-preferences-android:1.1.7")
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
