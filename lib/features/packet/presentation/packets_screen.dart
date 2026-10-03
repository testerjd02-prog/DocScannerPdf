import 'package:flutter/material.dart';

import '../../../core/l10n_x.dart';
import '../../../core/widgets/empty_state.dart';

/// Placeholder until the packet builder lands in Phase 3.
class PacketsScreen extends StatelessWidget {
  const PacketsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.packetsTitle)),
      body: EmptyState(
        icon: Icons.checklist_rtl,
        title: l10n.packetsEmptyTitle,
        body: l10n.packetsEmptyBody,
      ),
    );
  }
}
