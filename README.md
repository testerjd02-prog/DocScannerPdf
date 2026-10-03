# PacketPal

Privacy-first document scanner that helps you build and submit application
packets (rental, loan, visa, job onboarding). Scans never leave the device, no
watermark, no ads, honest pricing.

## Status

| Phase | Scope | State |
|-------|-------|-------|
| 1 | Setup, theme, routing, database, library, scan, crop, filters, PDF export, OCR search | **Done** (this commit) |
| 2 | Target-size export, redaction, ID stamp, sign and fill | Planned |
| 3 | Packet templates and builder, paywall, RevenueCat, app lock | Planned |
| 4 | Polish, integration test, store assets, privacy policy, data-safety answers | Planned |

## Run

Requires the Flutter stable SDK (developed on 3.47 / Dart 3.13).

```sh
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # drift code (also committed)
flutter run                                                # a real device is needed to scan
flutter test
flutter analyze
```

* Android: min SDK 21 (ML Kit). Google's document scanner downloads its model
  through Google Play services the first time it is used, so that first scan
  needs a connection; everything after works offline.
* iOS: deployment target 15.5 (ML Kit text recognition). Run `pod install`
  inside `ios/` on first build.

## Architecture

Feature-first. Each feature has `data/` (repositories, services, platform
plugins), `domain/` (plain models and rules, no Flutter widgets) and
`presentation/` (screens, controllers).

```
lib/
  core/        theme, router (go_router), database (drift), storage, shared widgets
  features/
    scan/      capture, crop, filters, isolate image pipeline, OCR engine
    library/   documents, folders, tags, search, smart naming, save pipeline
    export/    searchable PDF builder, share sheet
    home/ settings/ onboarding/ help/ packet/(placeholder)
  l10n/        ARB files (English), generated AppLocalizations
```

Key design decisions

* **Non-destructive edits.** A page stores `originalPath` (never written again)
  plus a recipe (crop corners, filter, rotation). `editedPath` is rebuilt from
  the original whenever the recipe changes.
* **Heavy work off the UI thread.** Decode, perspective crop, filters and
  imports run in short-lived isolates behind a 3-job gate so 50+ page
  documents cannot exhaust memory. PDF building also runs in an isolate. ML Kit
  OCR runs natively.
* **Search.** Each saved page is OCR'd after saving; the combined text is stored
  on the document and searched together with title and tags.
* **Searchable PDFs.** Pages are full-bleed images with an invisible text layer
  (PDF text render mode 3) positioned from OCR line boxes.
* **Delete with undo.** Documents are soft-deleted (`trashedAt`); when the Undo
  snackbar goes away the files are permanently removed. Leftovers are purged on
  launch.
* **Privacy defaults.** No network code, no analytics. Android auto-backup is off
  in the manifest; the iOS documents folder is flagged "exclude from backup".
  EXIF metadata is dropped from every imported or edited image.

### Deviations from the data model in the brief

* `Page.order` is named `position` (`order` is an SQL keyword).
* `Page` gained `cropJson` and `ocrBlocksJson` (crop recipe, OCR line boxes for
  the PDF text layer).
* `Document` gained `trashedAt` (soft delete for undo).
* `Settings` is the `AppSettings` Dart class mapped to the `settings` table.
* Dates are stored as ISO text so documents created in the same second still
  sort correctly.

## Known Phase 1 limitations

* The PDF text layer uses the built-in Helvetica font, so only Latin-1
  characters are searchable inside exported PDFs. OCR and in-app search work for
  all five scripts (choose one in Settings); embedding Noto fonts for the
  other scripts is planned for Phase 4.
* Crop handles are touch-only; there is no keyboard/switch alternative yet.
* Not built or run on a device or simulator in the authoring environment (no
  Android SDK / Xcode there): analysis and tests ran, native scanner flows,
  Swift channel code and on-device performance (the 2 s capture-to-saved target)
  still need verification on hardware.
