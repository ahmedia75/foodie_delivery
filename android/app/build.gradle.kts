import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services") version "4.4.2" apply false
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.ahmedia.delivery"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
         // Flag to enable support for the new language APIs
        isCoreLibraryDesugaringEnabled = true
        // Sets Java compatibility to Java 11
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.ahmedia.delivery"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        
        // Support for 16 KB memory page sizes (required for Android 15+)
        // No explicit ABI filters needed - let Flutter handle this automatically
    }

    signingConfigs {
        create("release") {
            // Debugging: Print the keystore properties
            println("=== KEYSTORE DEBUG INFO ===")
            println("Store File: ${keystoreProperties["storeFile"]}")
            println("Store File Exists: ${keystoreProperties["storeFile"]?.let { file(it).exists() }}")
            println("Key Alias: ${keystoreProperties["keyAlias"]}")
            println("Store Password Length: ${(keystoreProperties["storePassword"] as String?)?.length}")
            println("Key Password Length: ${(keystoreProperties["keyPassword"] as String?)?.length}")
            println("==========================")
            
            keyAlias = keystoreProperties["keyAlias"] as String?
            keyPassword = keystoreProperties["keyPassword"] as String?
            storeFile = keystoreProperties["storeFile"]?.let { file(it) }
            storePassword = keystoreProperties["storePassword"] as String?
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
    
    packaging {
        // Required for 16 KB memory page size support
        jniLibs {
            useLegacyPackaging = false
        }
        resources {
            excludes += "/META-INF/{AL2.0,LGPL2.1}"
        }
    }
    
    // Additional configuration for 16 KB memory page size support
    bundle {
        language {
            // Disable language splits to maintain broader device support
            enableSplit = false
        }
        density {
            // Disable density splits to maintain broader device support  
            enableSplit = false
        }
        abi {
            // Enable ABI splits but don't restrict specific ABIs
            enableSplit = true
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
    implementation(platform("com.google.firebase:firebase-bom:33.15.0"))
    implementation("com.google.firebase:firebase-analytics")
    implementation("com.google.firebase:firebase-auth")
}

apply(plugin = "com.google.gms.google-services")
