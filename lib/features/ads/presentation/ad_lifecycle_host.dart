import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../scan/presentation/scan_session_controller.dart';
import '../data/ads_providers.dart';

/// Tells the ads layer when the app goes to the background and comes back,
/// so it can decide about an app-open ad.
class AdLifecycleHost extends ConsumerStatefulWidget {
  const AdLifecycleHost({super.key, required this.child});
  final Widget child;

  @override
  ConsumerState<AdLifecycleHost> createState() => _AdLifecycleHostState();
}

class _AdLifecycleHostState extends ConsumerState<AdLifecycleHost>
    with WidgetsBindingObserver {
  DateTime? _backgroundedAt;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final ads = ref.read(adsFacadeProvider);
    switch (state) {
      // `inactive` also fires for permission dialogs and the app switcher
      // peek, which are not real backgrounding.
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        _backgroundedAt ??= DateTime.now();
        ads.onAppBackgrounded();
      case AppLifecycleState.resumed:
        final since = _backgroundedAt;
        _backgroundedAt = null;
        if (since == null) return;
        ads.onAppForegrounded(
          backgroundedFor: DateTime.now().difference(since),
          // Never interrupt an unsaved scan.
          safeToInterrupt: ref.read(scanSessionProvider).isEmpty,
        );
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
