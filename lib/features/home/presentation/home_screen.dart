import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n_x.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/empty_state.dart';
import '../../library/data/library_providers.dart';
import '../../library/presentation/document_tile.dart';
import '../../scan/presentation/scan_actions.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final recent = ref.watch(recentDocumentsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.homeTitle),
        actions: [
          IconButton(
            tooltip: l10n.settingsHelp,
            icon: const Icon(Icons.help_outline),
            onPressed: () => context.push('/help'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
        children: [
          Text(
            l10n.homeTagline,
            style: context.text.bodyLarge?.copyWith(
              color: context.scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _ActionCard(
                  icon: Icons.document_scanner_outlined,
                  title: l10n.homeQuickScan,
                  subtitle: l10n.homeQuickScanSubtitle,
                  onTap: () =>
                      ScanActions.start(context, ref, ScanSource.camera),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ActionCard(
                  icon: Icons.checklist_rtl,
                  title: l10n.homeNewPacket,
                  subtitle: l10n.homeNewPacketSubtitle,
                  onTap: () => context.go('/packets'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Text(l10n.homeRecent, style: context.text.titleMedium),
              ),
              TextButton(
                onPressed: () => context.go('/library'),
                child: Text(l10n.homeSeeAll),
              ),
            ],
          ),
          recent.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => Text(l10n.commonGenericError),
            data: (docs) {
              if (docs.isEmpty) {
                return EmptyState(
                  icon: Icons.document_scanner_outlined,
                  title: l10n.homeEmptyTitle,
                  body: l10n.homeEmptyBody,
                );
              }
              return SizedBox(
                height: 230,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: docs.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, i) => SizedBox(
                    width: 150,
                    child: DocumentTile(
                      document: docs[i],
                      grid: true,
                      selected: false,
                      selecting: false,
                      onTap: () => context.push('/document/${docs[i].id}'),
                      onLongPress: () {},
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
    color: context.scheme.primaryContainer,
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 32, color: context.scheme.onPrimaryContainer),
            const SizedBox(height: 12),
            Text(
              title,
              style: context.text.titleMedium?.copyWith(
                color: context.scheme.onPrimaryContainer,
              ),
            ),
            Text(
              subtitle,
              style: context.text.bodySmall?.copyWith(
                color: context.scheme.onPrimaryContainer,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
