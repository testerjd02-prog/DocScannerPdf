/// A run of list items, optionally followed by a native-ad slot.
class AdSegment {
  const AdSegment({required this.start, required this.end, this.adSlotAfter});

  /// First item index (inclusive).
  final int start;

  /// Last item index (exclusive).
  final int end;

  /// Ordinal of the native ad shown after this run (0, 1, 2…), or null.
  final int? adSlotAfter;

  int get length => end - start;

  @override
  bool operator ==(Object other) =>
      other is AdSegment &&
      other.start == start &&
      other.end == end &&
      other.adSlotAfter == adSlotAfter;

  @override
  int get hashCode => Object.hash(start, end, adSlotAfter);

  @override
  String toString() => 'AdSegment($start..$end, ad=$adSlotAfter)';
}

/// Plans where native ads go in a list of [itemCount] items.
///
/// The first ad comes after [firstAfter] items and then one every [every]
/// items, at most [maxAds]. An ad is only placed when more items follow it,
/// so a list never ends with an ad. Slot ordinals are stable for a given
/// position, which lets loaded ads be reused when the user scrolls back.
List<AdSegment> planAdSegments(
  int itemCount, {
  int firstAfter = 4,
  int every = 8,
  int maxAds = 6,
}) {
  assert(firstAfter > 0 && every > 0);
  final segments = <AdSegment>[];
  var start = 0;
  var next = firstAfter;
  var slot = 0;
  while (next < itemCount && slot < maxAds) {
    segments.add(AdSegment(start: start, end: next, adSlotAfter: slot));
    start = next;
    next += every;
    slot++;
  }
  segments.add(AdSegment(start: start, end: itemCount));
  return segments;
}
