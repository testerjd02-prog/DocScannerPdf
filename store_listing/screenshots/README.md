# Play Store screenshots

Generated from the real app screens (see `tool/store_screenshots/`).

| Folder | Size | Use in Play Console |
|--------|------|---------------------|
| `phone/` | 1080 × 1920 | Phone screenshots (upload all 8, in order) |
| `tablet_7in/` | 1200 × 1920 | 7-inch tablet screenshots |
| `tablet_10in/` | 1600 × 2560 | 10-inch tablet screenshots |

Order matters: the first three show in search results.

Regenerate:

```sh
python3 tool/store_screenshots/make_documents.py /tmp/shots/src
SHOTS_SRC=/tmp/shots/src SHOTS_OUT=/tmp/shots/raw \
  flutter test tool/store_screenshots/store_screenshots_test.dart
python3 tool/store_screenshots/compose.py /tmp/shots/raw store_listing/screenshots
```

The sample documents and the person named in them are fictional. The app has no
tablet-specific layout yet, so tablet shots show the phone layout stretched.
