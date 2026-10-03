import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/providers.dart';
import '../../scan/domain/ocr_result.dart';
import 'settings_repository.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsRepository(ref.watch(appDatabaseProvider)),
);

/// Settings read once at start-up so the first frame already has the right
/// theme and route. Overridden in `main()`.
final initialSettingsProvider = Provider<Map<String, String>>(
  (ref) => const {},
);

class ThemeModeController extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final saved = ref.read(
      initialSettingsProvider,
    )[SettingsRepository.keyThemeMode];
    return ThemeMode.values.firstWhere(
      (m) => m.name == saved,
      orElse: () => ThemeMode.system,
    );
  }

  Future<void> set(ThemeMode mode) async {
    state = mode;
    await ref
        .read(settingsRepositoryProvider)
        .set(SettingsRepository.keyThemeMode, mode.name);
  }
}

final themeModeProvider = NotifierProvider<ThemeModeController, ThemeMode>(
  ThemeModeController.new,
);

class OcrScriptController extends Notifier<OcrScript> {
  @override
  OcrScript build() {
    final saved = ref.read(
      initialSettingsProvider,
    )[SettingsRepository.keyOcrScript];
    return OcrScript.values.firstWhere(
      (s) => s.name == saved,
      orElse: () => OcrScript.latin,
    );
  }

  Future<void> set(OcrScript script) async {
    state = script;
    await ref
        .read(settingsRepositoryProvider)
        .set(SettingsRepository.keyOcrScript, script.name);
  }
}

final ocrScriptProvider = NotifierProvider<OcrScriptController, OcrScript>(
  OcrScriptController.new,
);
