import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n_x.dart';
import '../../../core/theme/app_theme.dart';
import '../../scan/domain/ocr_result.dart';
import '../data/settings_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final themeMode = ref.watch(themeModeProvider);
    final script = ref.watch(ocrScriptProvider);
    final scriptNames = {
      OcrScript.latin: l10n.ocrLatin,
      OcrScript.devanagari: l10n.ocrDevanagari,
      OcrScript.chinese: l10n.ocrChinese,
      OcrScript.japanese: l10n.ocrJapanese,
      OcrScript.korean: l10n.ocrKorean,
    };

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 120),
        children: [
          _Header(l10n.settingsPrivacy),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: ListTile(
              leading: Icon(Icons.lock_outline, color: context.scheme.primary),
              title: Text(l10n.settingsPrivacyTitle),
              subtitle: Text(l10n.settingsPrivacyBody),
              isThreeLine: true,
            ),
          ),
          _Header(l10n.settingsAppearance),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SegmentedButton<ThemeMode>(
              segments: [
                ButtonSegment(
                  value: ThemeMode.system,
                  label: Text(l10n.themeSystem),
                  icon: const Icon(Icons.brightness_auto),
                ),
                ButtonSegment(
                  value: ThemeMode.light,
                  label: Text(l10n.themeLight),
                  icon: const Icon(Icons.light_mode_outlined),
                ),
                ButtonSegment(
                  value: ThemeMode.dark,
                  label: Text(l10n.themeDark),
                  icon: const Icon(Icons.dark_mode_outlined),
                ),
              ],
              selected: {themeMode},
              onSelectionChanged: (s) =>
                  ref.read(themeModeProvider.notifier).set(s.first),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.settingsLanguage),
            subtitle: Text(l10n.languageEnglish),
          ),
          _Header(l10n.settingsScanning),
          ListTile(
            leading: const Icon(Icons.translate),
            title: Text(l10n.settingsOcrLanguage),
            subtitle: Text(scriptNames[script]!),
            onTap: () async {
              final picked = await showDialog<OcrScript>(
                context: context,
                builder: (context) => SimpleDialog(
                  title: Text(l10n.settingsOcrLanguage),
                  children: [
                    RadioGroup<OcrScript>(
                      groupValue: script,
                      onChanged: (v) => Navigator.pop(context, v),
                      child: Column(
                        children: [
                          for (final s in OcrScript.values)
                            RadioListTile<OcrScript>(
                              value: s,
                              title: Text(scriptNames[s]!),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
              if (picked != null) {
                await ref.read(ocrScriptProvider.notifier).set(picked);
              }
            },
          ),
          _Header(l10n.settingsAbout),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: Text(l10n.settingsHelp),
            onTap: () => context.push('/help'),
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: Text(l10n.settingsLicenses),
            onTap: () => showLicensePage(
              context: context,
              applicationName: l10n.appName,
              applicationLegalese: l10n.settingsAboutBody,
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
    child: Semantics(
      header: true,
      child: Text(
        text,
        style: context.text.titleSmall?.copyWith(color: context.scheme.primary),
      ),
    ),
  );
}
