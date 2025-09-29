# 📱 Social App — README

An application that delivers a complete social networking experience, designed as a showcase of modern mobile development practices and Clean Architecture principles. Users can browse a real-time, paginated feed, create posts with text, images, or videos, leave comments and reactions, upload media with preview flows, chat with friends in real time via Firebase, receive instant notifications, and even interact with an AI-powered chatbox using Cohere API. The app also supports deep linking, allowing posts to be opened directly from shared links, and features smooth UI animations to create a polished user experience. Built with Flutter, MobX, Dio, Socket.IO, Firebase, Google Safe Browsing API, and Cohere API, this project emphasizes scalability, maintainability, and production-ready performance — making it both a learning platform for developers and a foundation for future feature expansion or startup ideas.

---

## 📑 Table of Contents

- 📝 Project overview
- ✨ Highlights / features
- 🏗️ Stack & architecture
- 📂 Repository layout
- ⚡ Quick start (run & debug)
- 🔧 Configuration (API, sockets, environment)
- 🔗 Deep link usage & ADB tests
- 🛠️ Common troubleshooting
- 👩‍💻 Dev & contribution notes
- 📦 APK & Release info
- 📌 Feature roadmap / custom notes
- 👥 Maintainers

---

## 📝 Project overview

This Flutter application provides a **social feed experience** where users can create posts (text, images, video), comment, react, and open content links from external sources (**deep links**).  
It uses **MobX** for state management and **Dio** for network requests.

---

## ✨ Features

- 📰 **Feed with paginated posts**
- 💬 **Post detail view** with comments and reactions
- 📸 **Media upload** (images/videos)
- 🔄 **Realtime updates** via sockets (typing indicators, live feed refresh)
- 🔗 **Deep linking** (custom scheme & HTTPS App Links)
- **Chat** (chat with firebase firestore & firebase database realtime)
- **ChatBox** (chat box with cohereAPI Google LLM)
- **ChatGenImage** (agent gen image with model ImageGen3)
- **Notification** (get notification realtime with streambuilder)
- **Friend** friend module, follower, following
- UI smooth and animation for End User

---

## 🏗️ Stack & architecture

- **Framework:** Flutter (Dart)
- **Routing:** go_router
- **State:** MobX (stores, Observer widgets)
- **HTTP:** Dio
- **Realtime:** Socket.IO (via socket service)
- **Firebase:** Firebase FireStore, Database Realtime
- **GoogleAPI:** Google API check safe URL
- **CohereAPI:** Chat Box
- **ImageGen3:** Gen Image with ImageGen3

**Conceptual data flow:**  
`API → Model → Store (MobX) → UI (Observer/Reaction)`

---

## 📂 Repository layout

```bash

lib/
├── core/                      # Shared code
│   ├── constants/             # Constants
│   │   ├── data/              # Mock data
│   │   ├── fontsize/          # Font size configurations
│   │   ├── gen/               # Image paths
│   │   ├── storage/           # Shared preferences keys
│   │   └── routes/            # Route names
│   ├── api_response/          # API response definitions (list/object)
│   └── network/               # Dio interceptor configuration
│
├── data/                      # Data interaction: API, local DB, models
│   ├── models/
│   └── services/
│
├── domain/                    # Business logic (framework independent)
│   ├── entities/
│   ├── repositories/
│   └── usecases/
│
├── presentation/              # UI + MobX store (viewmodel)
│   ├── pages/
│   │   ├── screens/           # UI (StatelessWidget/Observer)
│   │   ├── controller/        # MobX handling
│   │   ├── service/           # API interaction
│   │   ├── widgets/           # Child widgets
│   │   └── routes/            # Route names
│   ├── shared/
│   └── themes/
│
└── main.dart

```

---

## ⚡ Quick start (run & debug)

1️⃣ **Install dependencies:**

```powershell
flutter pub get
```

2️⃣ **Run on device/emulator:**

```powershell
flutter run
```

---

⚠ **Physical device testing:**

- Ensure backend and device are on the same Wi-Fi network
- Backend must listen on `0.0.0.0`
- Add `network_security_config.xml` if using HTTP (API >= 28 blocks cleartext)

---

## 🔗 Deep link usage & ADB tests

**Custom scheme deep link:**

```powershell
adb shell am start -W -a android.intent.action.VIEW -d "socialapp://post/post-detail/<POST_ID>" <package>
```

**Example:**

```powershell
adb shell am start -W -a android.intent.action.VIEW -d "socialapp://post/post-detail/68c8e5241b3dae083a9345a6" com.example.handoffVdb2025
```

**Logcat filter:**

```powershell
adb logcat | Select-String -Pattern "intent|deeplink|socialapp"
```

## 👩‍💻 Dev & contribution notes

- **Branching:** feature branches → `main`
- **Linting:** `flutter analyze` before committing

---

## 📦 APK & Release info

- ✅ **Latest APK:** [./build/app/outputs/flutter-apk/app-release.apk](./build/app/outputs/flutter-apk/app-release.apk)
- 📅 **Build date:** _29/09/2025_
- 🏷️ **Version:** _Version 1_

---

## 👥 Maintainers

- **Project:** Internship Social App
- **Primary branch:** `trong_hung3`

```


