# BeeCount - OpenHarmony/HarmonyOS Edition

This repository is the **OpenHarmony/HarmonyOS adaptation** of [BeeCount](https://github.com/TNT-Likely/BeeCount).

## 📱 About BeeCount

BeeCount is a lightweight, open-source, privacy-focused personal finance management app with self-hosted Supabase/WebDAV cloud sync support.

**Core Features**:
- 🔒 Complete data ownership
- ☁️ Self-hosted cloud services (Supabase/WebDAV)
- 📊 Full accounting and chart analysis features
- 🌍 Support for 9 languages
- 🎨 Customizable themes
- 🆓 Free for personal use

## 🔗 Related Links

- **Main Repository**: [https://github.com/TNT-Likely/BeeCount](https://github.com/TNT-Likely/BeeCount)
- **Full Documentation**: Visit the main repository for detailed features, usage guides, and configuration tutorials
- **Download for Other Platforms**:
  - Android: [GitHub Releases](https://github.com/TNT-Likely/BeeCount/releases/latest)
  - iOS: [TestFlight Beta](https://testflight.apple.com/join/Eaw2rWxa)

## 🚀 Building for HarmonyOS

### Requirements

- Flutter SDK for OpenHarmony
- DevEco Studio
- HarmonyOS SDK 5.0+

### Build Steps

```bash
# Clone the repository
git clone https://github.com/TNT-Likely/beecount-openharmony.git
cd beecount-openharmony

# Install dependencies
flutter pub get

# Generate code
dart run build_runner build --delete-conflicting-outputs

# Open the ohos directory in DevEco Studio to build
```

### Signing Configuration

Building HarmonyOS applications requires signing certificate configuration:

1. Generate key and certificate request file in DevEco Studio
2. Apply for release certificate and Profile file in AppGallery Connect
3. Configure signing information in `ohos/build-profile.json5`

For detailed signing configuration, please refer to the [HarmonyOS Official Documentation](https://developer.huawei.com/consumer/en/doc/harmonyos-guides-V5/ide-signing-V5).

## 📄 License

This project uses the Business Source License. Free for personal use, commercial use requires paid authorization. See the [LICENSE](https://github.com/TNT-Likely/BeeCount/blob/main/LICENSE) file in the main repository for details.

## 💬 Feedback

- Submit Issues: [GitHub Issues](https://github.com/TNT-Likely/BeeCount/issues)
- Join Discussion: [Telegram Group](https://t.me/beecount)

---

**BeeCount 🐝 - Making accounting simple and secure**
