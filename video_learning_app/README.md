# Video Learning App

This is a simple Flutter video player application for learning purposes. It uses `video_player` and `chewie` to play online videos.

## Setup

Because this project was created in an environment without the Flutter SDK, the platform-specific files (Android/iOS) are missing.

1.  **Generate Platform Files:**
    Run the following command inside this directory (`video_learning_app`) to generate the Android and iOS folders:
    ```bash
    flutter create .
    ```

2.  **Install Dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Android Permission Configuration:**
    To play online videos, you must ensure your Android app has Internet permission.
    Open `android/app/src/main/AndroidManifest.xml` (created after step 1) and add the following line just above the `<application>` tag:

    ```xml
    <uses-permission android:name="android.permission.INTERNET"/>
    ```
    *(Note: Flutter debug builds often include this by default, but it is good practice to ensure it is present.)*

    **For HTTP (non-HTTPS) URLs:**
    If you want to play video from HTTP sources (not HTTPS), you also need to allow cleartext traffic.
    In `android/app/src/main/AndroidManifest.xml`, inside the `<application>` tag, add:
    ```xml
    android:usesCleartextTraffic="true"
    ```

## Usage

1.  Run the app: `flutter run`
2.  Enter a video URL (e.g., a direct `.mp4` link or `.m3u8` stream).
3.  Click "Play" to watch.
