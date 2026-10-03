import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n_x.dart';
import '../../../core/theme/app_theme.dart';
import '../../library/data/library_providers.dart';
import '../domain/edit_recipe.dart';
import 'crop_view.dart';

class PageEditorArgs {
  const PageEditorArgs({
    required this.originalPath,
    required this.recipe,
    this.title,
    this.startInCrop = false,
    this.onApplyFilterToAll,
  });

  final String originalPath;
  final EditRecipe recipe;
  final String? title;
  final bool startInCrop;

  /// When set, a button applies the chosen filter to every page.
  final ValueChanged<ScanFilter>? onApplyFilterToAll;
}

enum _Mode { crop, filters }

/// Crop (with perspective), filter and rotate one page. Pops with the new
/// [EditRecipe], or null when the user backs out.
class PageEditorScreen extends ConsumerStatefulWidget {
  const PageEditorScreen({super.key, required this.args});
  final PageEditorArgs args;

  @override
  ConsumerState<PageEditorScreen> createState() => _PageEditorScreenState();
}

class _PageEditorScreenState extends ConsumerState<PageEditorScreen> {
  late EditRecipe _recipe = widget.args.recipe;
  late _Mode _mode = widget.args.startInCrop ? _Mode.crop : _Mode.filters;
  double? _aspect;
  Uint8List? _preview;
  bool _previewFailed = false;
  Timer? _debounce;
  int _previewSerial = 0;

  @override
  void initState() {
    super.initState();
    unawaited(_loadAspect());
    if (_mode == _Mode.filters) _schedulePreview();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  /// Reads width/height from the file header without decoding pixels.
  Future<void> _loadAspect() async {
    final bytes = await File(widget.args.originalPath).readAsBytes();
    final buffer = await ui.ImmutableBuffer.fromUint8List(bytes);
    try {
      final descriptor = await ui.ImageDescriptor.encoded(buffer);
      if (!mounted) return;
      setState(() => _aspect = descriptor.width / descriptor.height);
      descriptor.dispose();
    } finally {
      buffer.dispose();
    }
  }

  void _schedulePreview() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 200), _renderPreview);
  }

  Future<void> _renderPreview() async {
    final serial = ++_previewSerial;
    try {
      final bytes = await ref
          .read(imageProcessorProvider)
          .preview(originalPath: widget.args.originalPath, recipe: _recipe);
      if (!mounted || serial != _previewSerial) return;
      setState(() {
        _preview = bytes;
        _previewFailed = false;
      });
    } on Object {
      if (mounted && serial == _previewSerial) {
        setState(() => _previewFailed = true);
      }
    }
  }

  void _setMode(_Mode mode) {
    setState(() => _mode = mode);
    if (mode == _Mode.filters) _schedulePreview();
  }

  void _setRecipe(EditRecipe recipe, {bool preview = true}) {
    setState(() => _recipe = recipe);
    if (preview && _mode == _Mode.filters) _schedulePreview();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.args.title ?? l10n.editorTitle),
        actions: [
          TextButton(
            onPressed: () => context.pop(_recipe),
            child: Text(l10n.commonDone),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: SegmentedButton<_Mode>(
                segments: [
                  ButtonSegment(
                    value: _Mode.crop,
                    icon: const Icon(Icons.crop),
                    label: Text(l10n.editorCrop),
                  ),
                  ButtonSegment(
                    value: _Mode.filters,
                    icon: const Icon(Icons.tune),
                    label: Text(l10n.editorFilters),
                  ),
                ],
                selected: {_mode},
                onSelectionChanged: (s) => _setMode(s.first),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                child: _mode == _Mode.crop ? _cropBody() : _previewBody(),
              ),
            ),
            _controls(context),
          ],
        ),
      ),
    );
  }

  Widget _cropBody() {
    final aspect = _aspect;
    if (aspect == null) return const Center(child: CircularProgressIndicator());
    return CropView(
      imagePath: widget.args.originalPath,
      aspectRatio: aspect,
      quad: _recipe.crop,
      onChanged: (q) => _setRecipe(_recipe.copyWith(crop: q), preview: false),
    );
  }

  Widget _previewBody() {
    final bytes = _preview;
    if (bytes == null) {
      return Center(
        child: _previewFailed
            ? Text(context.l10n.editorPreviewFailed)
            : const CircularProgressIndicator(),
      );
    }
    return Center(
      child: DecoratedBox(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: context.scheme.shadow.withValues(alpha: 0.25),
              blurRadius: 8,
            ),
          ],
        ),
        child: Image.memory(bytes, fit: BoxFit.contain, gaplessPlayback: true),
      ),
    );
  }

  Widget _controls(BuildContext context) {
    final l10n = context.l10n;
    if (_mode == _Mode.crop) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
        child: Row(
          children: [
            Expanded(
              child: Text(
                l10n.cropHint,
                style: context.text.bodyMedium?.copyWith(
                  color: context.scheme.onSurfaceVariant,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: _recipe.crop.isFull
                  ? null
                  : () => _setRecipe(_recipe.copyWith(crop: CropQuad.full)),
              icon: const Icon(Icons.restart_alt),
              label: Text(l10n.cropReset),
            ),
          ],
        ),
      );
    }
    final names = {
      ScanFilter.original: l10n.filterOriginal,
      ScanFilter.enhanced: l10n.filterEnhanced,
      ScanFilter.grayscale: l10n.filterGrayscale,
      ScanFilter.blackWhite: l10n.filterBlackWhite,
    };
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 4,
            alignment: WrapAlignment.center,
            children: [
              for (final f in ScanFilter.values)
                ChoiceChip(
                  label: Text(names[f]!),
                  selected: _recipe.filter == f,
                  onSelected: (_) => _setRecipe(_recipe.copyWith(filter: f)),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            alignment: WrapAlignment.center,
            children: [
              TextButton.icon(
                onPressed: () => _setRecipe(_recipe.rotatedClockwise()),
                icon: const Icon(Icons.rotate_right),
                label: Text(l10n.rotateRight),
              ),
              if (widget.args.onApplyFilterToAll != null)
                TextButton.icon(
                  onPressed: () =>
                      widget.args.onApplyFilterToAll!(_recipe.filter),
                  icon: const Icon(Icons.library_add_check_outlined),
                  label: Text(l10n.applyFilterToAll),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
