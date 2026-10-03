import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n_x.dart';
import '../../../core/theme/app_theme.dart';
import '../../settings/data/settings_providers.dart';
import '../../settings/data/settings_repository.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    final router = GoRouter.of(context);
    await ref
        .read(settingsRepositoryProvider)
        .set(SettingsRepository.keyOnboardingDone, '1');
    router.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final slides = [
      (Icons.lock_outline, l10n.onboarding1Title, l10n.onboarding1Body),
      (Icons.checklist_rtl, l10n.onboarding2Title, l10n.onboarding2Body),
      (Icons.verified_outlined, l10n.onboarding3Title, l10n.onboarding3Body),
    ];
    final last = _index == slides.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton(
                onPressed: _finish,
                child: Text(l10n.onboardingSkip),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (i) => setState(() => _index = i),
                children: [
                  for (final (icon, title, body) in slides)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: MediaQuery.sizeOf(context).height * 0.5,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ExcludeSemantics(
                                child: Icon(
                                  icon,
                                  size: 112,
                                  color: context.scheme.primary,
                                ),
                              ),
                              const SizedBox(height: 32),
                              Semantics(
                                header: true,
                                child: Text(
                                  title,
                                  style: context.text.headlineMedium,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                body,
                                style: context.text.bodyLarge?.copyWith(
                                  color: context.scheme.onSurfaceVariant,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Semantics(
              label: l10n.onboardingPage(_index + 1, slides.length),
              child: ExcludeSemantics(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (var i = 0; i < slides.length; i++)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.all(4),
                        width: i == _index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: i == _index
                              ? context.scheme.primary
                              : context.scheme.outlineVariant,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: last
                      ? _finish
                      : () => _controller.nextPage(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOut,
                        ),
                  child: Text(
                    last ? l10n.onboardingGetStarted : l10n.onboardingNext,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
