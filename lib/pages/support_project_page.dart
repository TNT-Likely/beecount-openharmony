import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/ui/ui.dart';
import '../l10n/app_localizations.dart';

class SupportProjectPage extends StatelessWidget {
  const SupportProjectPage({super.key});

  static const String githubSupportUrl =
      'https://github.com/TNT-Likely/BeeCount#-support-this-project';

  Future<void> _launchUrl(BuildContext context) async {
    final uri = Uri.parse(githubSupportUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to open URL'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: Column(
        children: [
          PrimaryHeader(
            title: l10n.supportProjectTitle,
            showBack: true,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // 说明卡片
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Icon(
                          Icons.favorite,
                          color: theme.colorScheme.primary,
                          size: 48,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.supportProjectWhyDescription,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            height: 1.6,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),

                        // 资金用途
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.supportProjectUsageTitle,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              _buildUsageItem(context, l10n.supportProjectUsage1),
                              const SizedBox(height: 6),
                              _buildUsageItem(context, l10n.supportProjectUsage2),
                              const SizedBox(height: 6),
                              _buildUsageItem(context, l10n.supportProjectUsage3),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // 自愿说明
                        Text(
                          l10n.supportProjectNote,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 查看捐赠方式按钮
                FilledButton.icon(
                  onPressed: () => _launchUrl(context),
                  icon: const Icon(Icons.open_in_new),
                  label: Text(l10n.supportProjectViewDonationMethods),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsageItem(BuildContext context, String text) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.check_circle,
          size: 16,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
