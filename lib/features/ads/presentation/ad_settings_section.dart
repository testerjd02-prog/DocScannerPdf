import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/l10n_x.dart';
import '../../../core/widgets/blocking_progress.dart';
import '../data/ads_providers.dart';
import '../domain/ad_format.dart';

/// Settings entries for ads: the rewarded "ad-free break" and the UMP
/// "Privacy & ad choices" form. Renders nothing when ads are not in play.
class AdSettingsSection extends ConsumerWidget {
  const AdSettingsSection({super.key});

  Future<void> _takeBreak(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final ads = ref.read(adsFacadeProvider);
    final progress = BlockingProgress.show(context, l10n.adsLoadingVideo);
    final RewardOutcome outcome;
    try {
      // Loaded on demand: nothing is requested unless the user asks.
      outcome = await ads.showRewarded();
    } finally {
      progress.close();
    }
    switch (outcome) {
      case RewardOutcome.earned:
        await ref.read(adFreeUntilProvider.notifier).grant(kAdFreeBreak);
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.adsBreakGranted(kAdFreeBreak.inMinutes))),
        );
      case RewardOutcome.unavailable:
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.adsVideoUnavailable)),
        );
      case RewardOutcome.dismissed:
        break;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final ads = ref.watch(adsFacadeProvider);
    final breakEnd = ref.watch(adFreeUntilProvider);

    return FutureBuilder<bool>(
      future: ads.privacyOptionsRequired(),
      builder: (context, snapshot) {
        final privacyRequired = snapshot.data ?? false;
        return ValueListenableBuilder<bool>(
          valueListenable: ads.canServe,
          builder: (context, serving, _) {
            final tiles = <Widget>[
              if (breakEnd != null)
                ListTile(
                  leading: const Icon(Icons.check_circle_outline),
                  title: Text(
                    l10n.adsBreakActive(
                      DateFormat.jm(l10n.localeName).format(breakEnd),
                    ),
                  ),
                )
              else if (serving)
                ListTile(
                  leading: const Icon(Icons.play_circle_outline),
                  title: Text(l10n.adsBreakTitle),
                  subtitle: Text(l10n.adsBreakSubtitle(kAdFreeBreak.inMinutes)),
                  onTap: () => _takeBreak(context, ref),
                ),
              if (privacyRequired)
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined),
                  title: Text(l10n.adsPrivacyChoices),
                  subtitle: Text(l10n.adsPrivacyChoicesSubtitle),
                  onTap: ads.showPrivacyOptions,
                ),
            ];
            if (tiles.isEmpty) return const SizedBox.shrink();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                  child: Semantics(
                    header: true,
                    child: Text(
                      l10n.settingsAds,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                ...tiles,
              ],
            );
          },
        );
      },
    );
  }
}
