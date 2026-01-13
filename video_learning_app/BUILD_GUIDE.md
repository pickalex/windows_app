# How to Build the APK

Because I am an AI assistant running in a cloud environment without the heavy Android SDK tools installed, I cannot directly generate the `.apk` file for you to download.

However, the complete source code is ready! You can build it on your own computer by following these simple steps.

## Prerequisites

1.  **Install Flutter:**
    If you haven't already, download and install Flutter from [flutter.dev](https://flutter.dev/docs/get-started/install).

2.  **Android Setup:**
    Ensure you have Android Studio installed and the Android toolchain configured (which usually comes with Flutter setup).

## Build Steps

1.  **Open your terminal (Command Prompt or Terminal)** and navigate to the project folder:
    ```bash
    cd video_learning_app
    ```

2.  **Generate Platform Files:**
    Since this is a new project, run this command to create the Android and iOS system files:
    ```bash
    flutter create .
    ```

3.  **Configure Permissions (Important!):**
    Open the file `android/app/src/main/AndroidManifest.xml`.
    Ensure the following lines are present inside the `<manifest>` tag (for Internet access) and `<application>` tag (for HTTP video support):

    ```xml
    <manifest ...>
        <!-- Add this line -->
        <uses-permission android:name="android.permission.INTERNET"/>

        <application
            ...
            <!-- Add this attribute -->
            android:usesCleartextTraffic="true"
            ...>
            ...
        </application>
    </manifest>
    ```

4.  **Build the APK:**
    Run the build command:
    ```bash
    flutter build apk --release
    ```

5.  **Locate the APK:**
    Once finished, your APK will be located at:
    `build/app/outputs/flutter-apk/app-release.apk`

6.  **Install:**
    Copy that file to your phone and install it!
