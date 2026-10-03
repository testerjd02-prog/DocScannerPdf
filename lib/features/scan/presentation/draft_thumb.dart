import 'dart:collection';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../library/data/library_providers.dart';
import '../domain/draft_page.dart';

/// Thumbnail of an unsaved page with its crop/filter/rotation applied.
/// Renders in a background isolate and keeps a small in-memory cache.
class DraftThumb extends ConsumerStatefulWidget {
  const DraftThumb({super.key, required this.page});
  final DraftPage page;

  @override
  ConsumerState<DraftThumb> createState() => _DraftThumbState();
}

class _DraftThumbState extends ConsumerState<DraftThumb> {
  static final LinkedHashMap<String, Uint8List> _cache = LinkedHashMap();
  static const _cacheLimit = 48;

  Future<Uint8List>? _future;
  String? _key;

  String get _wantedKey => '${widget.page.id}|${widget.page.recipe.hashCode}';

  Future<Uint8List> _load() async {
    final key = _wantedKey;
    final hit = _cache.remove(key);
    if (hit != null) {
      _cache[key] = hit;
      return hit;
    }
    final bytes = await ref
        .read(imageProcessorProvider)
        .preview(
          originalPath: widget.page.originalPath,
          recipe: widget.page.recipe,
          maxSide: 360,
        );
    _cache[key] = bytes;
    while (_cache.length > _cacheLimit) {
      _cache.remove(_cache.keys.first);
    }
    return bytes;
  }

  @override
  Widget build(BuildContext context) {
    if (_key != _wantedKey) {
      _key = _wantedKey;
      _future = _load();
    }
    return FutureBuilder<Uint8List>(
      future: _future,
      builder: (context, snap) {
        final bytes = snap.data;
        if (bytes == null) {
          return ColoredBox(color: context.scheme.surfaceContainerHighest);
        }
        return Image.memory(bytes, fit: BoxFit.cover, gaplessPlayback: true);
      },
    );
  }
}
