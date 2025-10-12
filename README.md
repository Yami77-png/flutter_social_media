# 🌐 Flutter Social Media

A **Flutter-based social media application** built as a **hobby project**. I've shared the full story and lessons learned on my website. [Read it here.](https://www.avizitrx.com/blogs/mobile-development/a-developers-journey-building-a-feature-rich-social-media-app-in-flutter)

## Features Overview

This project is a feature-rich social media app built for Android and iOS using Flutter. It was designed to have the core functionalities of a modern social platform, including user authentication, profile management, post creation, media sharing and real-time interactions.

- **Authentication:** Sign up, sign in, password recovery and secure user sessions using Firebase Auth.
- **User Profiles:** Two profile pictures per user. One avatar from a set of fixed images and one user-uploaded photo, with privacy controls. Users have the ability to edit personal information.
- **Posts & Feed:** Create posts with text, images or videos. They can share podcasts or music, and post story with duration and privacy settings. Users can upvote or downvote posts like Reddit. It has a feature-rich comment system using text, GIFs or stickers. Sharing other users’ post is also possible.
- **Friend System:** Send friend requests and connect with other users.
- **Media Handling:** Upload and edit images and videos, with a video editor and audio player for rich media content.
- **Real-Time Communication:** One-on-one audio calls and chat, with read receipts, powered by WebRTC.
- **Notifications:** Real-time notifications for likes, comments, messages and friend requests.
- **Routing & Deep Linking:** Clean navigation and deep linking to posts.
- **Responsive UI:** Adaptive layouts across phones and tablets.
- **State Management:** Predictable and maintainable state handling using Bloc/Cubits combined with Freezed for code generation.
- **Caching & Local Storage:** Efficient caching for posts, images, user data and settings.
- **Security & Data Protection:** Preliminary measures with Firebase security, with plans for secure storage and SSL pinning.

## ⚙️ Build & Run Commands

### 🧩 Debug Build

To build the **debug APK**:

```bash
flutter build apk --debug -t ./lib/main.dart
```

To target a specific flavor:

```bash
flutter build apk --debug -t lib/main_dev.dart
```

or

```bash
flutter build apk --debug -t lib/main_prod.dart
```

## 🧪 Running in VS Code (Launch Configurations)

You can run the app in different environments directly from **Visual Studio Code**.

### 🔧 `.vscode/launch.json`

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Flutter (Development)",
      "type": "dart",
      "request": "launch",
      "program": "lib/main_dev.dart"
    },
    {
      "name": "Flutter (Production)",
      "type": "dart",
      "request": "launch",
      "program": "lib/main_prod.dart"
    },
    {
      "name": "Flutter Profile (Dev)",
      "type": "dart",
      "request": "launch",
      "flutterMode": "profile",
      "program": "lib/main_dev.dart"
    },
    {
      "name": "Flutter Profile (Prod)",
      "type": "dart",
      "request": "launch",
      "flutterMode": "profile",
      "program": "lib/main_prod.dart"
    }
  ]
}
```

## 🔥 Firebase Setup

This app **requires Firebase setup**. You must configure Firebase for your project using the **Firebase CLI**.

Run the following command in your project root:

```bash
flutterfire configure
```

Follow the CLI prompts to link your Firebase project and generate the necessary configuration files (`firebase_options.dart`).

## 🧰 Code Generation (Freezed / JSON Serializable)

Run the following command to generate and watch model files:

```bash
flutter packages pub run build_runner watch --delete-conflicting-outputs
```

This regenerates data models automatically when you modify them.

## 🌍 Localization Setup

### 🔑 Translator API Key Setup

If using only one translation service:

-   Save the key in a file named `translator_key` in the project root,  
    **or**
-   As a JSON map in a file named `translator_keys`.
    

If using multiple translation services:
-   Use the **JSON map** approach.  
    See the [auto_translator documentation](https://pub.dev/packages/auto_translator) for more details.

To manage translations and generate localization files:

1.  **Auto-generate translations** with [`auto_translator`](https://pub.dev/packages/auto_translator):
    
    ```bash
    dart run auto_translator
    ```
    
2.  **Generate Flutter localization files:**
    
    ```bash
    flutter gen-l10n
    ```

## 📍 Google Places API Integration

Used for **address suggestions** and **location search** in posts or profiles.

1.  Get a **Google Places API Key** from [Google Cloud Console](https://console.cloud.google.com/).
    
2.  Add your key to `lib/src/core/utility/secrets.dart`:
    

```dart
const String googleCloudPlacesApiKey = 'YOUR_GOOGLE_PLACES_API_KEY';
```
