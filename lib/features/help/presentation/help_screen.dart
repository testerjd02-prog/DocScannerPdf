import 'package:flutter/material.dart';

import '../../../core/l10n_x.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final items = [
      (l10n.helpQ1, l10n.helpA1),
      (l10n.helpQ2, l10n.helpA2),
      (l10n.helpQ3, l10n.helpA3),
      (l10n.helpQ4, l10n.helpA4),
    ];
    return Scaffold(
      appBar: AppBar(title: Text(l10n.helpTitle)),
      body: ListView(
        children: [
          for (final (q, a) in items)
            ExpansionTile(
              title: Text(q),
              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              children: [Text(a)],
            ),
        ],
      ),
    );
  }
}
