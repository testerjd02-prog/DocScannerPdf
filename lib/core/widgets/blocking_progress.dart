import 'dart:async';

import 'package:flutter/material.dart';

/// Modal spinner for short, must-finish operations. Call [close] when done;
/// it is safe to call more than once.
class BlockingProgress {
  BlockingProgress._(this._navigator);

  final NavigatorState _navigator;
  bool _closed = false;

  static BlockingProgress show(BuildContext context, String label) {
    final navigator = Navigator.of(context, rootNavigator: true);
    unawaited(
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        useRootNavigator: true,
        builder: (_) => PopScope(
          canPop: false,
          child: AlertDialog(
            content: Semantics(
              liveRegion: true,
              label: label,
              child: Row(
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(width: 24),
                  Expanded(child: Text(label)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    return BlockingProgress._(navigator);
  }

  void close() {
    if (_closed) return;
    _closed = true;
    if (_navigator.mounted) _navigator.pop();
  }
}
