<div align="center">
  <h1>🚀 KeyType</h1>
  <p><strong>AI-Powered Writing Assistant & Productivity Suite</strong></p>
  
  <p>
    <img src="https://img.shields.io/badge/Flutter-3.29.0-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter">
    <img src="https://img.shields.io/badge/Dart-3.5.0-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart">
    <img src="https://img.shields.io/badge/GetX-4.6.6-9C27B0?style=for-the-badge&logo=flutter&logoColor=white" alt="GetX">
    <img src="https://img.shields.io/badge/Clean%20Architecture-✅-4CAF50?style=for-the-badge" alt="Clean Architecture">
  </p>
  
  <p>
    <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Desktop-lightgrey?style=for-the-badge" alt="Platform">
    <img src="https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge" alt="License">
    <img src="https://img.shields.io/badge/PRs-Welcome-brightgreen?style=for-the-badge" alt="PRs Welcome">
  </p>
</div>

---

## 📖 About KeyType

**KeyType** is a cutting-edge Flutter-based mobile application that leverages AI technology to provide intelligent writing assistance and enhance productivity. Built with modern app architecture principles, KeyType offers real-time AI-generated content, secure authentication, and a seamless user experience across multiple platforms.

### 🎯 **Who is it for?**

- 📝 **Content Creators** - Generate engaging content with AI assistance
- ✍️ **Writers** - Enhance writing with smart suggestions and templates
- 💻 **Developers** - Streamline documentation and code comments
- 🏢 **Professionals** - Boost productivity with AI-powered text generation

---

## ✨ Features

<table>
<tr>
<td width="50%">

### 🤖 **AI-Powered Writing**

- Real-time AI text generation
- Streaming response system
- Multiple writing styles and formats
- Smart reply suggestions
- Language translation support

### 👤 **User Management**

- Secure authentication with JWT
- Google OAuth integration
- Profile management
- Token refresh mechanism

</td>
<td width="50%">

### 📋 **Template System**

- Pre-built writing templates
- Category-based organization
- Custom template creation
- Search and filter functionality

### 💳 **Premium Features**

- Subscription management
- Payment integration
- Credit-based system
- Upgrade prompts

</td>
</tr>
</table>

---

## 🛠️ **Tech Stack**

<div align="center">

| **Category** | **Technology** | **Purpose** |
|:---:|:---:|:---:|
| 🎨 **Frontend** | Flutter 3.29.0 | Cross-platform UI framework |
| 🔗 **State Management** | GetX | Reactive state management & navigation |
| 🏗️ **Architecture** | Clean Architecture | Scalable, maintainable code structure |
| 🌐 **Networking** | Dio | HTTP client for API communication |
| 💾 **Local Storage** | SharedPreferences | Persistent local data storage |
| 🔐 **Authentication** | JWT + OAuth | Secure user authentication |
| 🧩 **Dependency Injection** | GetIt | Service locator pattern |
| ⚡ **Error Handling** | Either (Functional) | Type-safe error management |
| 🔄 **Serialization** | json_serializable | Automatic JSON mapping |
| 🎯 **Code Generation** | build_runner | Automated code generation |

</div>

---

## 🚀 **Quick Start**

### 📋 **Prerequisites**

- **Flutter SDK** ≥ 3.29.0
- **Dart SDK** ≥ 3.5.0
- **IDE**: Android Studio / VS Code
- **Platform Setup**:
  - 🤖 Android: Android Studio with SDK
  - 🍎 iOS: Xcode (macOS only)
  - 🌐 Web: Chrome browser

### ⚡ **Installation**

1. **Clone the repository**

   ```bash
   git clone https://github.com/alinemati-uwm/keytype_mobile.git
   cd keytype
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Generate model classes**

   ```bash
   dart run build_runner build
   ```

4. **Configure Firebase** (Required)

   ```bash
   # Add your Firebase configuration files:
   # 🤖 Android: android/app/google-services.json
   # 🍎 iOS: ios/Runner/GoogleService-Info.plist
   ```

5. **Set up API configuration**

   ```dart
   // Update in lib/core/network/apiEndPoints.dart
   // Set your API base URL
   ```

6. **Run the app**

   ```bash
   # Development
   flutter run
   
   # Production build
   flutter build apk --release  # Android
   flutter build ios --release  # iOS
   flutter build web --release  # Web
   ```

---

## 📱 **Platform Support**

<div align="center">

| Platform | Status | Build Command |
|:---:|:---:|:---|
| 🤖 **Android** | ✅ Ready | `flutter build apk --release` |
| 🍎 **iOS** | ✅ Ready | `flutter build ios --release` |
| 🌐 **Web** | ✅ Ready | `flutter build web --release` |
| 🖥️ **Windows** | ✅ Ready | `flutter build windows --release` |
| 🐧 **Linux** | ✅ Ready | `flutter build linux --release` |
| 🍎 **macOS** | ✅ Ready | `flutter build macos --release` |

</div>

---

## 🔧 **Development**

### 📁 **Project Structure**

```
keytype/
├── 📱 android/              # Android platform files
├── 🍎 ios/                  # iOS platform files
├── 📦 lib/
│   ├── 🎨 components/       # Reusable UI components
│   ├── 🏗️ core/            # Core functionality
│   │   ├── 🔧 helper/       # Utility functions
│   │   ├── 🚀 init/         # App initialization
│   │   ├── 📦 models/       # Data models
│   │   ├── 🌐 network/      # Domain-based API layers
│   │   ├── 💾 storage/      # Local storage management
│   │   └── 🎨 theme/        # App theming
│   ├── 🖼️ features/         # Feature modules
│   │   ├── 🔐 login/        # Authentication screens
│   │   ├── ✍️ create/       # AI writing interface
│   │   ├── 💬 askAi/        # Chat bot interface
│   │   ├── 📋 templates/    # Template management
│   │   ├── 👤 profile/      # User profile
│   │   └── 💳 upgrade/      # Subscription management
│   ├── 🛠️ utils/            # Utility functions
│   └── 📄 main.dart         # App entry point
├── 🌐 web/                  # Web platform files
├── 🖥️ windows/              # Windows platform files
├── 🐧 linux/                # Linux platform files
├── 🍎 macos/                # macOS platform files
└── 📋 pubspec.yaml          # Dependencies
```

### 🧪 **Code Quality**

```bash
# Run static analysis
flutter analyze

# Format code
dart format lib/

# Run tests
flutter test
```

---

## 🔐 **Environment Configuration**

### 🔑 **Required Environment Variables**

```bash
# Create .env file in project root
API_BASE_URL=https://your-api-endpoint.com
FIREBASE_PROJECT_ID=your-firebase-project
GOOGLE_OAUTH_CLIENT_ID=your-oauth-client-id
```

### ⚙️ **Build Configurations**

- **Development**: Debug builds with hot reload
- **Staging**: Pre-production testing
- **Production**: Optimized release builds

---

## 📜 **License**

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

---

## 🙏 **Acknowledgments**

<div align="center">

**Built with ❤️ using:**

[<img src="https://flutter.dev/assets/images/shared/brand/flutter/logo/flutter-lockup.png" width="100">](https://flutter.dev)
[<img src="https://raw.githubusercontent.com/jonataslaw/getx/master/get.png" width="100">](https://github.com/jonataslaw/getx)
[<img src="https://firebase.google.com/images/brand-guidelines/logo-vertical.png" width="100">](https://firebase.google.com)

</div>

**Special thanks to:**

- 🚀 **Flutter Team** - For the amazing cross-platform framework
- 🎯 **GetX Team** - For the powerful state management solution
- 🔥 **Firebase Team** - For backend services and authentication
- 🌟 **Open Source Community** - For continuous inspiration and support

---

<div align="center">
  <h3>⭐ **If you find KeyType helpful, please give it a star!** ⭐</h3>
  
  <p>
    <a href="https://github.com/alinemati-uwm/keytype_mobile/stargazers">
      <img src="https://img.shields.io/github/stars/alinemati-uwm/keytype_mobile?style=social" alt="GitHub stars">
    </a>
    <a href="https://github.com/alinemati-uwm/keytype_mobile/network/members">
      <img src="https://img.shields.io/github/forks/alinemati-uwm/keytype_mobile?style=social" alt="GitHub forks">
    </a>
  </p>
  
  <p><strong>Made with 💙 by the KeyType Team</strong></p>
</div>
