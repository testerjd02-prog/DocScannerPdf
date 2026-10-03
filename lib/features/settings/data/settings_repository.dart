import '../../../core/database/app_database.dart';

/// Key/value preferences stored in the local database.
class SettingsRepository {
  SettingsRepository(this._db);
  final AppDatabase _db;

  static const keyOnboardingDone = 'onboarding_done';
  static const keyThemeMode = 'theme_mode';
  static const keyOcrScript = 'ocr_script';
  static const keyCameraRationaleSeen = 'camera_rationale_seen';

  Future<Map<String, String>> loadAll() async {
    final rows = await _db.select(_db.appSettings).get();
    return {for (final r in rows) r.key: r.value};
  }

  Future<String?> get(String key) async {
    final row = await (_db.select(
      _db.appSettings,
    )..where((s) => s.key.equals(key))).getSingleOrNull();
    return row?.value;
  }

  Future<void> set(String key, String value) => _db
      .into(_db.appSettings)
      .insertOnConflictUpdate(
        AppSettingsCompanion.insert(key: key, value: value),
      );
}
