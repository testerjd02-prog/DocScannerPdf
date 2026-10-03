import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/scan/presentation/scan_actions.dart';
import '../l10n_x.dart';
import '../theme/app_theme.dart';

/// Bottom navigation (Home, Library, Packets, Settings) with a large scan
/// button docked in the centre.
class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _go(int index) => navigationShell.goBranch(
    index,
    initialLocation: index == navigationShell.currentIndex,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final current = navigationShell.currentIndex;

    Widget item(
      int index,
      IconData icon,
      IconData selectedIcon,
      String label,
    ) => Expanded(
      child: _NavItem(
        icon: current == index ? selectedIcon : icon,
        label: label,
        selected: current == index,
        onTap: () => _go(index),
      ),
    );

    return Scaffold(
      body: navigationShell,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Semantics(
        label: l10n.scanButtonLabel,
        button: true,
        child: SizedBox(
          width: 72,
          height: 72,
          child: FloatingActionButton(
            heroTag: 'scan',
            tooltip: l10n.scanButtonLabel,
            shape: const CircleBorder(),
            onPressed: () => ScanActions.showSourceSheet(context, ref),
            child: const Icon(Icons.document_scanner, size: 34),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        padding: EdgeInsets.zero,
        child: Row(
          children: [
            item(0, Icons.home_outlined, Icons.home, l10n.navHome),
            item(1, Icons.folder_outlined, Icons.folder, l10n.navLibrary),
            const SizedBox(width: 80),
            item(2, Icons.checklist_rtl, Icons.checklist_rtl, l10n.navPackets),
            item(3, Icons.settings_outlined, Icons.settings, l10n.navSettings),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected
        ? context.scheme.primary
        : context.scheme.onSurfaceVariant;
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      excludeSemantics: true,
      onTap: onTap,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 56),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.text.labelSmall?.copyWith(color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
