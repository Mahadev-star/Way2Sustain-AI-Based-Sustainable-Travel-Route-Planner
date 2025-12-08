android {
    defaultConfig {
        // Add this line
        multiDexEnabled true
    }
}

dependencies {
    // Add Firebase dependencies
    implementation platform('com.google.firebase:firebase-bom:32.7.0')
    implementation 'com.google.firebase:firebase-analytics'
    
    // Add this for multidex support
    implementation 'androidx.multidex:multidex:2.0.1'
}
apply plugin: 'com.google.gms.google-services'