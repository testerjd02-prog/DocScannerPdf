import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/help/presentation/help_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/library/presentation/document_detail_screen.dart';
import '../../features/library/presentation/library_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/packet/presentation/packets_screen.dart';
import '../../features/scan/presentation/page_editor_screen.dart';
import '../../features/scan/presentation/scan_review_screen.dart';
import '../../features/settings/data/settings_providers.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/settings/data/settings_repository.dart';
import 'app_shell.dart';

final _rootKey = GlobalKey<NavigatorState>(debugLabel: 'root');

/// Routes. Tabs live in a stateful shell so each keeps its own stack and
/// scroll position; everything else opens full-screen above the tab bar.
final routerProvider = Provider<GoRouter>((ref) {
  final onboarded =
      ref.read(initialSettingsProvider)[SettingsRepository.keyOnboardingDone] ==
      '1';
  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: onboarded ? '/' : '/onboarding',
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => AppShell(navigationShell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/library',
                builder: (context, state) => const LibraryScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/packets',
                builder: (context, state) => const PacketsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: '/document/:id',
        builder: (context, state) =>
            DocumentDetailScreen(documentId: state.pathParameters['id']!),
      ),
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: '/scan/review',
        builder: (context, state) => const ScanReviewScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: '/editor',
        builder: (context, state) =>
            PageEditorScreen(args: state.extra! as PageEditorArgs),
      ),
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: '/help',
        builder: (context, state) => const HelpScreen(),
      ),
    ],
  );
});
