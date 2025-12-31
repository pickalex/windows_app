# Sports Live App

This is a Flutter application for sports live streaming using Agora RTC Engine.

## Setup

1.  This project relies on Flutter. Ensure Flutter is installed on your machine.
2.  Navigate to the `sports_live_app` directory.
3.  Run `flutter create .` to generate the platform-specific files (android, ios, web, etc.).
    *   Note: This step is crucial because the repository was created without them.
4.  Run `flutter pub get` to install dependencies.

## Permissions

### Android

Open `android/app/src/main/AndroidManifest.xml` and add the following permissions:

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.MODIFY_AUDIO_SETTINGS" />
<uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<uses-permission android:name="android.permission.BLUETOOTH" />
```

### iOS

Open `ios/Runner/Info.plist` and add the following keys:

```xml
<key>NSCameraUsageDescription</key>
<string>We require camera access to broadcast video.</string>
<key>NSMicrophoneUsageDescription</key>
<string>We require microphone access to broadcast audio.</string>
```

## Running the App

Run the app using:

```bash
flutter run
```

## Configuration

The Agora App ID and Certificate are configured in `lib/utils/settings.dart`.
Currently, the token is empty. If your Agora project has the App Certificate enabled, you will need to generate a temporary token and paste it into the `token` variable in `settings.dart`, or implement a token server.
