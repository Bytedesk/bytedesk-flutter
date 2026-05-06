# Visitor Flutter

Visitor Flutter is the Flutter implementation of the Bytedesk visitor demo. It matches the same Home, Messages, and Profile flow used by Visitor UniApp.

## Features

- Flutter three-tab visitor demo.
- Home tab opens plain chat, goods chat, and order chat scenes.
- Messages tab fetches visitor threads from the online API.
- Profile tab switches between preset demo users.
- Chat content is shown with webview_flutter.

## Default Online Endpoints

- Chat page: https://cdn.weiyuai.cn
- API base: https://api.weiyuai.cn

## Main Files

- lib/main.dart: tab layout, API loading, chat navigation, WebView page
- pubspec.yaml: Flutter dependencies
- android/app/src/main/AndroidManifest.xml: Android network permission
- ios/Runner/Info.plist: iOS web access settings

## Requirements

- Flutter SDK 3.10.7 or newer
- Dart SDK compatible with pubspec.yaml
- Xcode for iOS builds, Android SDK for Android builds

## How To Run

1. Open a terminal in frontend/apps/visitorFlutter.
2. Install dependencies.
3. Run on the target device or simulator.

```bash
cd frontend/apps/visitorFlutter
flutter pub get
flutter run
```

For validation you can use:

```bash
cd frontend/apps/visitorFlutter
flutter analyze lib/main.dart
```

## How To Use

1. Open Home and tap a scene card to enter the chat page.
2. Open Messages to fetch visitor threads from the online API.
3. Tap any thread to continue the conversation.
4. Open Profile to switch the current demo visitor.

## Notes

- The app uses online endpoints by default.
- Android and iOS permissions required for embedded web content are already configured.
