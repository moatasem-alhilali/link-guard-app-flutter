<div align="center">

<img src="https://img.shields.io/badge/Flutter-3.41+-02569B?style=for-the-badge&logo=flutter&logoColor=white" />
<img src="https://img.shields.io/badge/Dart-3.11+-0175C2?style=for-the-badge&logo=dart&logoColor=white" />
<img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS-green?style=for-the-badge" />
<img src="https://img.shields.io/badge/License-MIT-blue?style=for-the-badge" />
<img src="https://img.shields.io/badge/Open%20Source-❤️-red?style=for-the-badge" />

<br/><br/>

# 🛡️ LinkGuard

### Your Link Safety Shield — درعك ضد الروابط الخطيرة

**A production-ready Flutter app that scans URLs for threats using Google Safe Browsing & VirusTotal — built with best practices, Riverpod, Dio, and full Arabic/English support.**

[Privacy Policy](./PRIVACY_POLICY.md) · [Report Bug](https://github.com/moatasem-alhilali/link-guard-app-flutter/issues) · [Request Feature](https://github.com/moatasem-alhilali/link-guard-app-flutter/issues)

</div>

---

## ✨ Features

- 🔍 **URL Scanning** — detect malicious, suspicious, or safe links instantly
- 🌐 **Dual Engine** — powered by **Google Safe Browsing** + **VirusTotal** APIs
- 🌙 **Dark & Light Theme** — persisted across sessions
- 🇸🇦 **Arabic & English** — full RTL/LTR support with one-tap switching
- 📋 **Scan History** — keeps the last 20 scanned URLs in session
- 🔒 **Security Filters** — blocks localhost, private IPs, and malformed URLs locally before any API call
- ⚡ **Fast & Optimized** — Riverpod state management, Dio HTTP client, R8 minification on release

---

## 📸 Screenshots

> _Coming soon — add your screenshots in `screenshots/` and update links below._

| Dark Mode | Light Mode | Result Card |
|-----------|------------|-------------|
| ![dark](screenshots/dark.png) | ![light](screenshots/light.png) | ![result](screenshots/result.png) |

---

## 🏗️ Architecture

```
lib/
├── main.dart                          # App entry, EasyLocalization + Riverpod
├── core/
│   ├── models/
│   │   └── verdict_result.dart        # VerdictResult & ScanState models
│   ├── providers/
│   │   ├── scan_provider.dart         # Scan logic + history (Riverpod Notifier)
│   │   └── theme_provider.dart        # Dark/Light theme persistence
│   ├── services/
│   │   └── scan_service.dart          # Dio HTTP client for Google & VirusTotal
│   ├── theme/
│   │   └── app_theme.dart             # Material3 dark & light themes
│   └── utils/
│       └── url_validator.dart         # URL normalization & security validation
└── screens/
    └── home_screen.dart               # Single-screen UI with all components
```

---

## 🧰 Tech Stack

| Layer | Package | Version |
|---|---|---|
| State Management | [`flutter_riverpod`](https://pub.dev/packages/flutter_riverpod) | ^2.5.1 |
| HTTP Client | [`dio`](https://pub.dev/packages/dio) | ^5.4.3+1 |
| Localization | [`easy_localization`](https://pub.dev/packages/easy_localization) | ^3.0.7 |
| Animations | [`flutter_animate`](https://pub.dev/packages/flutter_animate) | ^4.5.0 |
| Typography | [`google_fonts`](https://pub.dev/packages/google_fonts) | ^6.2.1 |
| Persistence | [`shared_preferences`](https://pub.dev/packages/shared_preferences) | ^2.2.3 |
| URL Launch | [`url_launcher`](https://pub.dev/packages/url_launcher) | ^6.3.1 |

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) ≥ 3.41
- [Dart SDK](https://dart.dev/get-dart) ≥ 3.11
- A Google Safe Browsing API key → [Get one here](https://console.cloud.google.com/)
- A VirusTotal API key → [Get one here](https://www.virustotal.com/gui/join-us)

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/moatasem-alhilali/link-guard-app-flutter.git
cd link-guard-app-flutter

# 2. Install dependencies
flutter pub get

# 3. Add your API keys
#    Open: lib/core/services/scan_service.dart
#    Replace:
#      const _googleApiKey = 'YOUR_GOOGLE_SAFE_BROWSING_KEY';
#      const _vtApiKey     = 'YOUR_VIRUSTOTAL_API_KEY';

# 4. Run the app
flutter run
```

---

## 🔑 API Keys Configuration

Open `lib/core/services/scan_service.dart` and replace the placeholder keys:

```dart
// Google Safe Browsing
const _googleApiKey = 'YOUR_GOOGLE_SAFE_BROWSING_KEY';

// VirusTotal
const _vtApiKey = 'YOUR_VIRUSTOTAL_API_KEY';
```

> **Tip for production:** Load keys from a `.env` file or use [flutter_dotenv](https://pub.dev/packages/flutter_dotenv) to avoid hardcoding secrets.

---

## 🏪 Building for Release (Android)

> Make sure you have a keystore file. See the [signing guide](https://docs.flutter.dev/deployment/android#signing-the-app).

```bash
# 1. Create android/key.properties  (NOT committed to git)
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=YOUR_KEY_ALIAS
storeFile=../../keystore/upload-keystore.jks

# 2. Build the App Bundle
flutter build appbundle --release

# Output: build/app/outputs/bundle/release/app-release.aab
```

Upload the `.aab` file to [Google Play Console](https://play.google.com/console).

---

## 🌍 Localization

Translation files are in `assets/translations/`:

| File | Language |
|------|----------|
| `en.json` | English |
| `ar.json` | Arabic |

To add a new language, create `assets/translations/XX.json` and add the locale to `main.dart`.

---

## 🔒 Security

- **Local validation** blocks localhost, loopback (`127.0.0.1`, `::1`), and private IP ranges (`10.x`, `192.168.x`, `172.16-31.x`) before any API call.
- **No personal data** is collected or stored. See [Privacy Policy](./PRIVACY_POLICY.md).
- `android/key.properties` and `keystore/` are excluded from version control via `.gitignore`.

---

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Commit your changes: `git commit -m 'feat: add amazing feature'`
4. Push to the branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

---

## 📄 License

Distributed under the **MIT License**. See [`LICENSE`](./LICENSE) for more information.

---

## 👤 Author

**Moatasem Al-Hilali** · Nano Hive

- GitHub: [@moatasem-alhilali](https://github.com/moatasem-alhilali)
- Email: [privacy@nanohive.app](mailto:privacy@nanohive.app)

---

<div align="center">

Made with ❤️ by **Nano Hive**

⭐ Star this repo if you find it useful!

</div>
