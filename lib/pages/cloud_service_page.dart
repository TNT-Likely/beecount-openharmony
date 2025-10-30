import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import '../cloud/cloud_service_config.dart';
import '../cloud/supabase_initializer.dart';
import '../providers/sync_providers.dart';
import '../widgets/ui/ui.dart';
import '../widgets/biz/section_card.dart';
import '../styles/colors.dart';
import '../l10n/app_localizations.dart';

// GitHub配置教程链接
const _kSupabaseGuideUrl = 'https://github.com/TNT-Likely/BeeCount#%E8%87%AA%E5%BB%BAsupabase%E6%9C%8D%E5%8A%A1';
const _kWebdavGuideUrl = 'https://github.com/TNT-Likely/BeeCount#webdav%E9%85%8D%E7%BD%AE';

class CloudServicePage extends ConsumerStatefulWidget {
  const CloudServicePage({super.key});
  @override
  ConsumerState<CloudServicePage> createState() => _CloudServicePageState();
}

class _CloudServicePageState extends ConsumerState<CloudServicePage> {
  bool _testingConnection = false;
  final Map<String, bool> _connectionTestResults = {};
  bool _hasAutoTested = false;

  @override
  void initState() {
    super.initState();
    // 延迟执行自动测试，等待页面加载完成
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _autoTestActiveConnection();
    });
  }

  Future<void> _autoTestActiveConnection() async {
    if (_hasAutoTested) return;
    _hasAutoTested = true;

    final activeAsync = ref.read(activeCloudConfigProvider);
    if (!activeAsync.hasValue) return;

    final active = activeAsync.value!;
    if (active.type == CloudBackendType.local || !active.valid) return;

    // 自动测试当前激活的云服务连接（静默测试，不显示对话框）
    await _testConnection(active, showDialog: false);
  }

  @override
  Widget build(BuildContext context) {
    final activeAsync = ref.watch(activeCloudConfigProvider);
    final supabaseAsync = ref.watch(supabaseConfigProvider);
    final webdavAsync = ref.watch(webdavConfigProvider);

    return Scaffold(
      backgroundColor: BeeColors.greyBg,
      body: Column(
        children: [
          activeAsync.when(
            loading: () => PrimaryHeader(
              title: AppLocalizations.of(context).mineCloudService,
              showBack: true,
            ),
            error: (e, _) => PrimaryHeader(
              title: AppLocalizations.of(context).mineCloudService,
              showBack: true,
            ),
            data: (active) => PrimaryHeader(
              title: AppLocalizations.of(context).mineCloudService,
              showBack: true,
              actions: active.type != CloudBackendType.local && active.valid
                  ? [
                      IconButton(
                        icon: _testingConnection
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.wifi_find),
                        onPressed: _testingConnection ? null : () => _testConnection(active),
                        tooltip: AppLocalizations.of(context).cloudTestConnection,
                      ),
                    ]
                  : null,
              content: active.type != CloudBackendType.local
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: _buildConnectionStatus(active),
                    )
                  : null,
            ),
          ),
          Expanded(
            child: activeAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('${AppLocalizations.of(context).commonError}: $e')),
              data: (active) {
                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Text(
                      AppLocalizations.of(context).cloudSelectServiceType,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: BeeColors.secondaryText,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // 1. 本地存储 Card
                    _buildServiceCard(
                      context: context,
                      icon: Icons.phone_android,
                      iconColor: Colors.grey,
                      title: AppLocalizations.of(context).cloudLocalStorageTitle,
                      subtitle: AppLocalizations.of(context).cloudLocalStorageSubtitle,
                      isSelected: active.type == CloudBackendType.local,
                      onTap: () => _switchService(CloudBackendType.local),
                      showGuide: false,
                    ),

                    const SizedBox(height: 12),

                    // 2. 自定义 Supabase Card
                    supabaseAsync.when(
                      loading: () => const SizedBox(height: 100, child: Center(child: CircularProgressIndicator())),
                      error: (e, _) => const SizedBox.shrink(),
                      data: (supabaseCfg) => _buildServiceCard(
                        context: context,
                        icon: Icons.cloud,
                        iconColor: Colors.blue,
                        title: AppLocalizations.of(context).cloudCustomSupabaseTitle,
                        subtitle: supabaseCfg?.valid == true
                            ? supabaseCfg!.obfuscatedUrl()
                            : AppLocalizations.of(context).cloudCustomSupabaseSubtitle,
                        isSelected: active.type == CloudBackendType.supabase,
                        isConfigured: supabaseCfg?.valid == true,
                        onTap: () => supabaseCfg?.valid == true
                            ? _switchService(CloudBackendType.supabase)
                            : _configureService(CloudBackendType.supabase),
                        onConfigure: supabaseCfg?.valid == true
                            ? () => _configureService(CloudBackendType.supabase)
                            : null,
                        showGuide: true,
                        guideUrl: _kSupabaseGuideUrl,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // 3. 自定义 WebDAV Card
                    webdavAsync.when(
                      loading: () => const SizedBox(height: 100, child: Center(child: CircularProgressIndicator())),
                      error: (e, _) => const SizedBox.shrink(),
                      data: (webdavCfg) => _buildServiceCard(
                        context: context,
                        icon: Icons.folder_shared,
                        iconColor: Colors.orange,
                        title: AppLocalizations.of(context).cloudCustomWebdavTitle,
                        subtitle: webdavCfg?.valid == true
                            ? webdavCfg!.obfuscatedUrl()
                            : AppLocalizations.of(context).cloudCustomWebdavSubtitle,
                        isSelected: active.type == CloudBackendType.webdav,
                        isConfigured: webdavCfg?.valid == true,
                        onTap: () => webdavCfg?.valid == true
                            ? _switchService(CloudBackendType.webdav)
                            : _configureService(CloudBackendType.webdav),
                        onConfigure: webdavCfg?.valid == true
                            ? () => _configureService(CloudBackendType.webdav)
                            : null,
                        showGuide: true,
                        guideUrl: _kWebdavGuideUrl,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionStatus(CloudServiceConfig config) {
    final testResult = _connectionTestResults[config.id];
    final Color statusColor;
    final IconData statusIcon;
    final String statusText;

    if (testResult == null) {
      // 未测试
      statusColor = Colors.orange;
      statusIcon = Icons.help_outline;
      statusText = AppLocalizations.of(context).cloudStatusNotTested;
    } else if (testResult) {
      // 测试成功
      statusColor = BeeColors.success;
      statusIcon = Icons.check_circle_outline;
      statusText = AppLocalizations.of(context).cloudStatusNormal;
    } else {
      // 测试失败
      statusColor = BeeColors.danger;
      statusIcon = Icons.error_outline;
      statusText = AppLocalizations.of(context).cloudStatusFailed;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '${AppLocalizations.of(context).commonCurrent}: ${_getTypeName(config.type)}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: statusColor.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    statusText,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          config.obfuscatedUrl(),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: BeeColors.secondaryText,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildServiceCard({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool isSelected,
    bool isConfigured = true,
    required VoidCallback onTap,
    VoidCallback? onConfigure,
    required bool showGuide,
    String? guideUrl,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: isSelected ? Border.all(color: BeeColors.success, width: 2) : null,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SectionCard(
        margin: EdgeInsets.zero,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    // 图标
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: iconColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: iconColor, size: 24),
                    ),
                    const SizedBox(width: 16),

                    // 文字信息
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: BeeColors.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 选中标记
                    if (isSelected)
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: BeeColors.success,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check, color: Colors.white, size: 18),
                      ),
                  ],
                ),

                // 底部按钮行
                if (isConfigured && (onConfigure != null || showGuide))
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (showGuide && guideUrl != null)
                          TextButton.icon(
                            onPressed: () => _openGuide(guideUrl),
                            icon: const Icon(Icons.help_outline, size: 16),
                            label: Text(AppLocalizations.of(context).commonTutorial, style: const TextStyle(fontSize: 12)),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                        if (onConfigure != null) ...[
                          if (showGuide) const SizedBox(width: 8),
                          OutlinedButton.icon(
                            onPressed: onConfigure,
                            icon: const Icon(Icons.settings, size: 16),
                            label: Text(AppLocalizations.of(context).commonConfigure, style: const TextStyle(fontSize: 12)),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openGuide(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        showToast(context, AppLocalizations.of(context).cloudCannotOpenLink);
      }
    }
  }

  Future<void> _switchService(CloudBackendType type) async {
    final store = ref.read(cloudServiceStoreProvider);
    final active = await ref.read(activeCloudConfigProvider.future);

    if (active.type == type) return; // 已经是当前类型

    // 确认切换
    if (!mounted) return;
    final confirmed = await AppDialog.confirm(
      context,
      title: AppLocalizations.of(context).cloudSwitchConfirmTitle,
      message: AppLocalizations.of(context).cloudSwitchConfirmMessage,
    );
    if (!confirmed || !mounted) return;

    try {
      // 登出
      await ref.read(authServiceProvider).signOut();

      // 激活新配置
      final success = await store.activate(type);
      if (!success && type != CloudBackendType.local) {
        if (mounted) {
          await AppDialog.error(context, title: AppLocalizations.of(context).cloudSwitchFailedTitle, message: AppLocalizations.of(context).cloudSwitchFailedConfigMissing);
        }
        return;
      }

      // 重新初始化 Supabase（如果切换到了 Supabase 服务）
      final newConfig = await store.loadActive();
      if (newConfig.type == CloudBackendType.supabase && newConfig.valid) {
        await SupabaseInitializer.initialize(newConfig);
      } else {
        // 切换到非 Supabase 服务，清理 Supabase 实例
        await SupabaseInitializer.dispose();
      }

      // 刷新
      ref.invalidate(activeCloudConfigProvider);
      ref.invalidate(supabaseConfigProvider);
      ref.invalidate(webdavConfigProvider);
      ref.invalidate(supabaseClientProvider);

      if (mounted) {
        showToast(context, AppLocalizations.of(context).cloudSwitchedTo(_getTypeName(type)));
      }
    } catch (e) {
      if (mounted) {
        await AppDialog.error(context, title: AppLocalizations.of(context).cloudSwitchFailedTitle, message: '$e');
      }
    }
  }

  Future<void> _configureService(CloudBackendType type) async {
    // 根据类型显示配置对话框
    if (type == CloudBackendType.supabase) {
      await _showSupabaseConfigDialog();
    } else if (type == CloudBackendType.webdav) {
      await _showWebdavConfigDialog();
    }
  }

  Future<void> _showSupabaseConfigDialog() async {
    final existing = await ref.read(supabaseConfigProvider.future);

    if (!mounted) return;

    final result = await showDialog<Map<String, dynamic>?>(
      context: context,
      builder: (dialogContext) => _SupabaseConfigDialog(
        initialUrl: existing?.supabaseUrl ?? '',
        initialKey: existing?.supabaseAnonKey ?? '',
      ),
    );

    if (result != null) {
      final url = result['url'] as String;
      final key = result['key'] as String;

      if (url.isEmpty || key.isEmpty) {
        if (mounted) {
          await AppDialog.error(context, title: AppLocalizations.of(context).cloudConfigInvalidTitle, message: AppLocalizations.of(context).cloudConfigInvalidMessage);
        }
        return;
      }

      final cfg = CloudServiceConfig(
        type: CloudBackendType.supabase,
        name: AppLocalizations.of(context).cloudCustomSupabaseTitle,
        supabaseUrl: url,
        supabaseAnonKey: key,
      );

      if (!cfg.valid) {
        if (mounted) {
          await AppDialog.error(context, title: AppLocalizations.of(context).cloudConfigInvalidTitle, message: AppLocalizations.of(context).cloudConfigInvalidMessage);
        }
        return;
      }

      try {
        await ref.read(cloudServiceStoreProvider).saveOnly(cfg);
        ref.invalidate(supabaseConfigProvider);
        if (mounted) showToast(context, AppLocalizations.of(context).cloudConfigSaved);
      } catch (e) {
        if (mounted) {
          await AppDialog.error(context, title: AppLocalizations.of(context).cloudSaveFailed, message: e.toString());
        }
      }
    }
  }

  Future<void> _showWebdavConfigDialog() async {
    final existing = await ref.read(webdavConfigProvider.future);

    if (!mounted) return;

    final result = await showDialog<Map<String, dynamic>?>(
      context: context,
      builder: (dialogContext) => _WebdavConfigDialog(
        initialUrl: existing?.webdavUrl ?? '',
        initialUsername: existing?.webdavUsername ?? '',
        initialPassword: existing?.webdavPassword ?? '',
        initialPath: existing?.webdavRemotePath ?? '/',
      ),
    );

    if (result != null) {
      final url = result['url'] as String;
      final username = result['username'] as String;
      final password = result['password'] as String;
      final path = result['path'] as String;

      if (url.isEmpty || username.isEmpty || password.isEmpty) {
        if (mounted) {
          await AppDialog.error(context, title: AppLocalizations.of(context).cloudConfigInvalidTitle, message: AppLocalizations.of(context).cloudConfigInvalidMessage);
        }
        return;
      }

      final cfg = CloudServiceConfig(
        type: CloudBackendType.webdav,
        name: AppLocalizations.of(context).cloudCustomWebdavTitle,
        webdavUrl: url,
        webdavUsername: username,
        webdavPassword: password,
        webdavRemotePath: path.isEmpty ? '/' : path,
      );

      if (!cfg.valid) {
        if (mounted) {
          await AppDialog.error(context, title: AppLocalizations.of(context).cloudConfigInvalidTitle, message: AppLocalizations.of(context).cloudConfigInvalidMessage);
        }
        return;
      }

      try {
        await ref.read(cloudServiceStoreProvider).saveOnly(cfg);
        ref.invalidate(webdavConfigProvider);
        if (mounted) showToast(context, AppLocalizations.of(context).cloudConfigSaved);
      } catch (e) {
        if (mounted) {
          await AppDialog.error(context, title: AppLocalizations.of(context).cloudSaveFailed, message: e.toString());
        }
      }
    }
  }

  String _getTypeName(CloudBackendType type) {
    switch (type) {
      case CloudBackendType.local:
        return AppLocalizations.of(context).cloudLocalStorageTitle;
      case CloudBackendType.supabase:
        return 'Supabase';
      case CloudBackendType.webdav:
        return 'WebDAV';
    }
  }

  // 测试连接
  Future<void> _testConnection(CloudServiceConfig config, {bool showDialog = true}) async {
    if (!config.valid || config.type == CloudBackendType.local) return;

    setState(() => _testingConnection = true);
    try {
      bool connectionSuccess = false;
      String? errorDetail;

      try {
        switch (config.type) {
          case CloudBackendType.local:
            break;

          case CloudBackendType.supabase:
            // Supabase 连接测试 - 尝试访问 REST API
            final testUrl = Uri.parse('${config.supabaseUrl}/rest/v1/');
            final response = await http.get(
              testUrl,
              headers: {
                'apikey': config.supabaseAnonKey!,
                'Authorization': 'Bearer ${config.supabaseAnonKey}',
              },
            ).timeout(const Duration(seconds: 10));

            if (response.statusCode == 200 || response.statusCode == 404) {
              connectionSuccess = true;
            } else if (response.statusCode == 401 || response.statusCode == 403) {
              throw Exception(AppLocalizations.of(context).cloudErrorAuthFailed);
            } else {
              throw Exception(AppLocalizations.of(context).cloudErrorServerStatus('${response.statusCode}'));
            }
            break;

          case CloudBackendType.webdav:
            // WebDAV 连接测试 - 发送 OPTIONS 请求
            final testUrl = Uri.parse(config.webdavUrl!);
            final credentials = base64Encode(
              utf8.encode('${config.webdavUsername}:${config.webdavPassword}'),
            );

            final request = http.Request('OPTIONS', testUrl);
            request.headers['Authorization'] = 'Basic $credentials';

            final streamedResponse = await request.send().timeout(const Duration(seconds: 10));
            final response = await http.Response.fromStream(streamedResponse);

            if (response.statusCode == 200 || response.statusCode == 204) {
              final davHeader = response.headers['dav'];
              if (davHeader != null || response.headers.containsKey('allow')) {
                connectionSuccess = true;
              } else {
                throw Exception(AppLocalizations.of(context).cloudErrorWebdavNotSupported);
              }
            } else if (response.statusCode == 401) {
              throw Exception(AppLocalizations.of(context).cloudErrorAuthFailedCredentials);
            } else if (response.statusCode == 403) {
              throw Exception(AppLocalizations.of(context).cloudErrorAccessDenied);
            } else if (response.statusCode == 404) {
              throw Exception(AppLocalizations.of(context).cloudErrorPathNotFound(testUrl.path));
            } else {
              throw Exception(AppLocalizations.of(context).cloudErrorServerStatus('${response.statusCode}'));
            }
            break;
        }
      } on http.ClientException catch (e) {
        connectionSuccess = false;
        errorDetail = AppLocalizations.of(context).cloudErrorNetwork(e.message);
      } on Exception catch (e) {
        connectionSuccess = false;
        errorDetail = e.toString().replaceFirst('Exception: ', '');
      } catch (e) {
        connectionSuccess = false;
        errorDetail = e.toString();
      }

      setState(() {
        _connectionTestResults[config.id] = connectionSuccess;
      });

      // 只在手动测试时显示对话框
      if (mounted && showDialog) {
        if (connectionSuccess) {
          await AppDialog.info(context,
              title: AppLocalizations.of(context).cloudTestSuccessTitle,
              message: AppLocalizations.of(context).cloudTestSuccessMessage);
        } else {
          await AppDialog.error(context,
              title: AppLocalizations.of(context).cloudTestFailedTitle,
              message: errorDetail ?? AppLocalizations.of(context).cloudTestFailedMessage);
        }
      }
    } catch (e) {
      setState(() {
        _connectionTestResults[config.id] = false;
      });
      // 只在手动测试时显示错误对话框
      if (mounted && showDialog) {
        await AppDialog.error(context,
            title: AppLocalizations.of(context).cloudTestErrorTitle,
            message: e.toString());
      }
    } finally {
      if (mounted) setState(() => _testingConnection = false);
    }
  }
}

// Supabase配置对话框(独立Widget,避免controller生命周期问题)
class _SupabaseConfigDialog extends StatefulWidget {
  final String initialUrl;
  final String initialKey;

  const _SupabaseConfigDialog({
    required this.initialUrl,
    required this.initialKey,
  });

  @override
  State<_SupabaseConfigDialog> createState() => _SupabaseConfigDialogState();
}

class _SupabaseConfigDialogState extends State<_SupabaseConfigDialog> {
  late final TextEditingController urlController;
  late final TextEditingController keyController;

  @override
  void initState() {
    super.initState();
    urlController = TextEditingController(text: widget.initialUrl);
    keyController = TextEditingController(text: widget.initialKey);
  }

  @override
  void dispose() {
    urlController.dispose();
    keyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context).cloudConfigureSupabaseTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: urlController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).cloudSupabaseUrlLabel,
                hintText: AppLocalizations.of(context).cloudSupabaseUrlHint,
              ),
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: keyController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).cloudAnonKeyLabel,
                hintText: AppLocalizations.of(context).cloudSupabaseAnonKeyHintLong,
              ),
              keyboardType: TextInputType.text,
              minLines: 1,
              maxLines: 5,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: Text(AppLocalizations.of(context).commonCancel),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop({
              'url': urlController.text.trim(),
              'key': keyController.text.trim(),
            });
          },
          child: Text(AppLocalizations.of(context).commonSave),
        ),
      ],
    );
  }
}

// WebDAV配置对话框(独立Widget,避免controller生命周期问题)
class _WebdavConfigDialog extends StatefulWidget {
  final String initialUrl;
  final String initialUsername;
  final String initialPassword;
  final String initialPath;

  const _WebdavConfigDialog({
    required this.initialUrl,
    required this.initialUsername,
    required this.initialPassword,
    required this.initialPath,
  });

  @override
  State<_WebdavConfigDialog> createState() => _WebdavConfigDialogState();
}

class _WebdavConfigDialogState extends State<_WebdavConfigDialog> {
  late final TextEditingController urlController;
  late final TextEditingController usernameController;
  late final TextEditingController passwordController;
  late final TextEditingController pathController;
  bool obscurePassword = true;

  @override
  void initState() {
    super.initState();
    urlController = TextEditingController(text: widget.initialUrl);
    usernameController = TextEditingController(text: widget.initialUsername);
    passwordController = TextEditingController(text: widget.initialPassword);
    pathController = TextEditingController(text: widget.initialPath);
  }

  @override
  void dispose() {
    urlController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    pathController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context).cloudConfigureWebdavTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: urlController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).cloudWebdavUrlLabel,
                hintText: AppLocalizations.of(context).cloudWebdavUrlHint,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).cloudWebdavUsernameLabel,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).cloudWebdavPasswordLabel,
                suffixIcon: IconButton(
                  icon: Icon(
                    obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      obscurePassword = !obscurePassword;
                    });
                  },
                ),
              ),
              obscureText: obscurePassword,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: pathController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).cloudWebdavRemotePathLabel,
                hintText: AppLocalizations.of(context).cloudWebdavPathHint,
                helperText: AppLocalizations.of(context).cloudWebdavRemotePathHelperText,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: Text(AppLocalizations.of(context).commonCancel),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop({
              'url': urlController.text.trim(),
              'username': usernameController.text.trim(),
              'password': passwordController.text.trim(),
              'path': pathController.text.trim(),
            });
          },
          child: Text(AppLocalizations.of(context).commonSave),
        ),
      ],
    );
  }
}
