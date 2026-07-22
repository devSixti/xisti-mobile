import org.jetbrains.kotlin.gradle.dsl.JvmTarget
import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    id("com.google.firebase.crashlytics")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.app.xisti"
    compileSdk = 36
    ndkVersion = "29.0.13113456"

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlin {
        compilerOptions {
            jvmTarget.set(JvmTarget.JVM_17)
        }
    }

    packaging {
        jniLibs {
            // Uncompressed + page-aligned native libs (required for 16 KB devices on Android 15+).
            useLegacyPackaging = false
        }
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.app.xisti"
        multiDexEnabled = true
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 24
        targetSdk = 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildFeatures {
        buildConfig = true
    }

    signingConfigs {
        create("release") {
            val keystoreProperties = Properties()
            val keystorePropertiesFile = rootProject.file("key.properties")
            val envKeystorePath = System.getenv("ANDROID_KEYSTORE_PATH")

            when {
                !envKeystorePath.isNullOrBlank() -> {
                    storeFile = file(envKeystorePath)
                    storePassword = System.getenv("ANDROID_KEYSTORE_PASSWORD") ?: ""
                    keyAlias = System.getenv("ANDROID_KEY_ALIAS") ?: ""
                    keyPassword = System.getenv("ANDROID_KEY_PASSWORD") ?: ""
                }
                keystorePropertiesFile.exists() -> {
                    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
                    storeFile = file(keystoreProperties["storeFile"] as String)
                    storePassword = keystoreProperties["storePassword"] as String
                    keyAlias = keystoreProperties["keyAlias"] as String
                    keyPassword = keystoreProperties["keyPassword"] as String
                }
            }
        }
    }

    buildTypes {
        release {
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro",
            )
            firebaseCrashlytics {
                mappingFileUploadEnabled = true
            }
            val hasReleaseSigning = !System.getenv("ANDROID_KEYSTORE_PATH").isNullOrBlank()
                || rootProject.file("key.properties").exists()
            signingConfig = if (hasReleaseSigning) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("androidx.multidex:multidex:2.0.1")
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
}
