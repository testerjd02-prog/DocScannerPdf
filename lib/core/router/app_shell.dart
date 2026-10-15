import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/ads/data/ads_providers.dart';
import '../../features/ads/presentation/banner_ad_slot.dart';
import '../../features/scan/presentation/scan_actions.dart';
import '../l10n_x.dart';
import '../theme/app_theme.dart';

/// Bottom navigation (Home, Library, Packets, Settings) with a large scan
/// button docked in the centre.
class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  bool _bannerVisible = false;

  StatefulNavigationShell get navigationShell => widget.navigationShell;

  @override
  void initState() {
    super.initState();
    // Consent (UMP) and SDK start-up happen once the first tab is on screen,
    // never over onboarding and never before the user can see the app.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) unawaited(ref.read(adsFacadeProvider).start());
    });
  }

  void _go(int index) => navigationShell.goBranch(
    index,
    initialLocation: index == navigationShell.currentIndex,
  );

  @override
  Widget build(BuildContext context) {
    ref.watch(adsWiringProvider);
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

    // The banner sits at the top: the docked scan button covers the bottom
    // edge, and ads must never be overlapped by other controls. Ads never
    // appear on scan, crop, review or editor screens (they are not tabs).
    return Scaffold(
      body: Column(
        children: [
          BannerAdSlot(
            onVisibilityChanged: (v) {
              if (mounted) setState(() => _bannerVisible = v);
            },
          ),
          Expanded(
            child: _bannerVisible
                ? MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: navigationShell,
                  )
                : navigationShell,
          ),
        ],
      ),
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
