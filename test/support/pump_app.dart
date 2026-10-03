import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:packet_pal/core/theme/app_theme.dart';
import 'package:packet_pal/l10n/generated/app_localizations.dart';

import 'test_env.dart';

/// Pumps [child] inside the app's theme, localisations and providers.
Future<void> pumpApp(
  WidgetTester tester,
  Widget child, {
  required TestEnv env,
  ThemeMode themeMode = ThemeMode.light,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: env.overrides,
      child: MaterialApp(
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: themeMode,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: child,
      ),
    ),
  );
  await tester.pump();
}

/// Tears the tree down so drift's stream timers finish before the test ends.
Future<void> disposeApp(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox());
  await tester.pump(const Duration(milliseconds: 50));
}
