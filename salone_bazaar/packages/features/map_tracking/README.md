# Setting Up Google Maps and Geolocator in Flutter

**Prerequisites:**

* **Flutter:** Ensure you have Flutter installed and configured on your system.
* **Google Cloud Platform:** Create a Google Cloud Platform project and enable the Google Maps Platform API. Obtain an API key.
* **Google Maps Platform SDK:** Install the Google Maps Platform SDK for Android, iOS, and web platforms.

## Android Setup: 

1. **AndroidManifest.xml:**
   * Open `android/app/src/main/AndroidManifest.xml` and add the following meta-data element inside the `<application>` tag:

   ```xml
   <meta-data
       android:name="com.google.android.geo.API_KEY"
       android:value="YOUR_API_KEY" />
   ```

   * Replace `YOUR_API_KEY` with your actual Google Maps API key.

2. **Permissions:**
   * In `android/app/src/main/AndroidManifest.xml`, add the following permissions inside the `<manifest>` tag:

   ```xml
   <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
   <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
   <uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
   <uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />
   ```

3. **build.gradle:**
   * Open `android/app/build.gradle` and set the `minSdkVersion` to 23:

   ```groovy
    defaultConfig {
        // ... other configurations
        minSdk = 23
        targetSdkVersion 33
        versionCode 1
        versionName "1.0"
    }
   ```

4. **Update the Kotlin Plugin version:**
   * Open `android/settings.gradle`
   ```groovy
   plugins {
   // ...other configurations
    id "org.jetbrains.kotlin.android" version "2.0.20" apply false
   }
```