import 'package:family_budget/core/constants/app_constants.dart';
import 'package:family_budget/core/models/app_currency.dart';
import 'package:family_budget/core/providers/currency_provider.dart';
import 'package:family_budget/core/providers/locale_provider.dart';
import 'package:family_budget/core/theme/theme_provider.dart';
import 'package:family_budget/features/auth/providers/auth_provider.dart';
import 'package:family_budget/features/settings/widgets/theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:family_budget/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context)!;
    final authState = ref.watch(authProvider);
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    final currency = ref.watch(currencyProvider);

    String languageName(Locale? loc) {
      if (loc == null) return l.english;
      switch (loc.languageCode) {
        case 'ro':
          return l.romanian;
        case 'ru':
          return l.russian;
        default:
          return l.english;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l.settings),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: theme.colorScheme.primaryContainer,
                    child: Text(
                      (authState.user?.name.isNotEmpty == true)
                          ? authState.user!.name[0].toUpperCase()
                          : '?',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          authState.user?.name ?? 'User',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          authState.user?.email ?? '',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Appearance section
          Text(
            l.appearance,
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ThemeSwitcher(
                currentMode: themeMode,
                onChanged: (mode) {
                  ref.read(themeModeProvider.notifier).setThemeMode(mode);
                },
              ),
            ),
          ),
          const SizedBox(height: 20),

          // General section
          Text(
            l.general,
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.language),
                  title: Text(l.language),
                  subtitle: Text(languageName(locale)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showLanguagePicker(context, ref, locale),
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: const Icon(Icons.attach_money),
                  title: Text(l.currency),
                  subtitle: Text('${currency.code} (${currency.symbol})'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showCurrencyPicker(context, ref, currency),
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: const Icon(Icons.notifications_outlined),
                  title: Text(l.notifications),
                  subtitle: Text(l.manageAlerts),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l.comingSoon)),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // About section
          Text(
            l.about,
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: Text(l.appVersion),
                  subtitle: const Text(AppConstants.appVersion),
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: const Icon(Icons.description_outlined),
                  title: Text(l.termsOfService),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                const Divider(height: 1, indent: 56),
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined),
                  title: Text(l.privacyPolicy),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Logout button
          SizedBox(
            height: 48,
            child: OutlinedButton.icon(
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text(l.logout),
                    content: Text(l.logoutConfirm),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: Text(l.cancel),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: Text(l.logout),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  ref.read(authProvider.notifier).logout();
                }
              },
              icon: const Icon(Icons.logout),
              label: Text(l.logout),
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.colorScheme.error,
                side: BorderSide(color: theme.colorScheme.error),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _showLanguagePicker(
      BuildContext context, WidgetRef ref, Locale? current) {
    final l = AppLocalizations.of(context)!;
    final options = [
      (null, l.english, 'en'),
      (const Locale('ro'), l.romanian, 'ro'),
      (const Locale('ru'), l.russian, 'ru'),
    ];

    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(l.selectLanguage),
        children: options.map((opt) {
          final selected = current?.languageCode == opt.$3 ||
              (current == null && opt.$3 == 'en');
          return ListTile(
            leading: Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: selected ? Theme.of(context).colorScheme.primary : null,
            ),
            title: Text(opt.$2),
            onTap: () {
              ref.read(localeProvider.notifier).setLocale(opt.$1);
              Navigator.pop(ctx);
            },
          );
        }).toList(),
      ),
    );
  }

  void _showCurrencyPicker(
      BuildContext context, WidgetRef ref, AppCurrency current) {
    final l = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(l.selectCurrency),
        children: AppCurrency.all.map((c) {
          final selected = c.code == current.code;
          return ListTile(
            leading: Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: selected ? Theme.of(context).colorScheme.primary : null,
            ),
            title: Text('${c.code} (${c.symbol})'),
            subtitle: Text(c.name),
            onTap: () {
              ref.read(currencyProvider.notifier).setCurrency(c);
              Navigator.pop(ctx);
            },
          );
        }).toList(),
      ),
    );
  }
}
