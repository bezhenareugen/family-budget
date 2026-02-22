import 'package:family_budget/core/providers/locale_provider.dart';
import 'package:family_budget/core/router/app_router.dart';
import 'package:family_budget/core/theme/app_theme.dart';
import 'package:family_budget/core/theme/theme_provider.dart';
import 'package:flutter/material.dart';

import 'package:family_budget/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class App extends ConsumerWidget {
  const App({super.key, this.onAppReady});

  final VoidCallback? onAppReady;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final router = ref.watch(routerProvider);
    final locale = ref.watch(localeProvider);

    // Dismiss the native splash once providers are resolved and the app is ready
    WidgetsBinding.instance.addPostFrameCallback((_) => onAppReady?.call());

    return MaterialApp.router(
      title: 'Family Budget',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    );
  }
}
