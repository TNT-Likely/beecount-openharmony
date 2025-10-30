# 蜜蜂记账 - OpenHarmony/HarmonyOS 版本

本仓库是 [蜜蜂记账](https://github.com/TNT-Likely/BeeCount) 的 **OpenHarmony/HarmonyOS（鸿蒙）适配版本**。

## 📱 关于蜜蜂记账

蜜蜂记账是一款轻量、开源、隐私可控的个人财务管理应用，支持自建 Supabase/WebDAV 云服务器同步。

**核心特性**：
- 🔒 数据完全自主掌控
- ☁️ 支持自建云服务（Supabase/WebDAV）
- 📊 完整的记账和图表分析功能
- 🌍 支持 9 种语言
- 🎨 个性化主题装扮
- 🆓 个人使用完全免费

## 🔗 相关链接

- **主项目仓库**: [https://github.com/TNT-Likely/BeeCount](https://github.com/TNT-Likely/BeeCount)
- **完整功能介绍**: 请访问主仓库查看详细的功能特性、使用说明和配置教程
- **下载其他平台版本**:
  - Android: [GitHub Releases](https://github.com/TNT-Likely/BeeCount/releases/latest)
  - iOS: [TestFlight 公测](https://testflight.apple.com/join/Eaw2rWxa)

## 🚀 HarmonyOS 版本构建

### 环境要求

- Flutter SDK for OpenHarmony
- DevEco Studio
- HarmonyOS SDK 5.0+

### 构建步骤

```bash
# 克隆项目
git clone https://github.com/TNT-Likely/beecount-openharmony.git
cd beecount-openharmony

# 安装依赖
flutter pub get

# 代码生成
dart run build_runner build --delete-conflicting-outputs

# 使用 DevEco Studio 打开 ohos 目录进行构建
```

### 签名配置

构建 HarmonyOS 应用需要配置签名证书：

1. 在 DevEco Studio 中生成密钥和证书请求文件
2. 在 AppGallery Connect 申请发布证书和 Profile 文件
3. 在 `ohos/build-profile.json5` 中配置签名信息

详细签名配置请参考 [HarmonyOS 官方文档](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/ide-signing-V5)。

## 📄 开源协议

本项目采用商业源代码许可证，个人使用完全免费，商业使用需付费授权。详见主仓库的 [LICENSE](https://github.com/TNT-Likely/BeeCount/blob/main/LICENSE) 文件。

## 💬 问题反馈

- 提交 Issue: [GitHub Issues](https://github.com/TNT-Likely/BeeCount/issues)
- 加入讨论: [Telegram 群组](https://t.me/beecount)

---

**蜜蜂记账 🐝 - 让记账变得简单而安全**
