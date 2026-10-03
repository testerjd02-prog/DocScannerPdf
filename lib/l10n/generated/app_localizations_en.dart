// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'PacketPal';

  @override
  String get navHome => 'Home';

  @override
  String get navLibrary => 'Library';

  @override
  String get navPackets => 'Packets';

  @override
  String get navSettings => 'Settings';

  @override
  String get scanButtonLabel => 'Scan a document';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonSave => 'Save';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonDone => 'Done';

  @override
  String get commonNext => 'Next';

  @override
  String get commonBack => 'Back';

  @override
  String get commonSkip => 'Skip';

  @override
  String get commonUndo => 'Undo';

  @override
  String get commonRename => 'Rename';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonClose => 'Close';

  @override
  String get commonCreate => 'Create';

  @override
  String get commonMove => 'Move';

  @override
  String get commonCopy => 'Copy';

  @override
  String get commonLoading => 'Loading';

  @override
  String get commonGenericError => 'Something went wrong. Please try again.';

  @override
  String get commonOpen => 'Open';

  @override
  String get onboarding1Title => 'Scans that stay on your phone';

  @override
  String get onboarding1Body =>
      'No account, no cloud upload, no tracking of what you scan. Your documents live in private app storage on this device.';

  @override
  String get onboarding2Title => 'Build application packets';

  @override
  String get onboarding2Body =>
      'Collect the documents for a rental, loan, visa or job application in the right order, with a checklist so nothing is missing.';

  @override
  String get onboarding3Title => 'Honest and simple';

  @override
  String get onboarding3Body =>
      'Unlimited scanning with no watermark and no ads. Optional extras are priced up front, before you ever pay.';

  @override
  String get onboardingGetStarted => 'Get started';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingNext => 'Next';

  @override
  String onboardingPage(int current, int total) {
    return 'Page $current of $total';
  }

  @override
  String get homeTitle => 'PacketPal';

  @override
  String get homeTagline => 'Your documents stay on this phone.';

  @override
  String get homeQuickScan => 'Quick scan';

  @override
  String get homeQuickScanSubtitle => 'Capture a single document';

  @override
  String get homeNewPacket => 'New packet';

  @override
  String get homeNewPacketSubtitle => 'Rental, loan, visa, job';

  @override
  String get homeRecent => 'Recent documents';

  @override
  String get homeSeeAll => 'See all';

  @override
  String get homeEmptyTitle => 'Nothing scanned yet';

  @override
  String get homeEmptyBody =>
      'Tap the scan button to capture your first document. It is saved only on this device.';

  @override
  String get scanRationaleTitle => 'Camera access';

  @override
  String get scanRationaleBody =>
      'PacketPal opens your camera to photograph documents. Pictures are processed and stored on this device only and are never uploaded. Your phone will now ask for permission.';

  @override
  String get scanRationaleContinue => 'Continue';

  @override
  String get scanAddTitle => 'Add pages';

  @override
  String get scanFromCamera => 'Scan with camera';

  @override
  String get scanFromCameraSubtitle => 'Automatic edge detection';

  @override
  String get scanFromPhotos => 'Import from photos';

  @override
  String get scanFromPhotosSubtitle => 'Pick pictures from your gallery';

  @override
  String get scanFromFiles => 'Import from files';

  @override
  String get scanFromFilesSubtitle => 'Images and PDFs';

  @override
  String get scanImporting => 'Preparing pages…';

  @override
  String scanFailed(String message) {
    return 'Could not capture: $message';
  }

  @override
  String get scanNothingAdded => 'No pages were added.';

  @override
  String get editorTitle => 'Edit page';

  @override
  String get editorCrop => 'Crop';

  @override
  String get editorFilters => 'Filters';

  @override
  String get cropHint => 'Drag the corners to fit the page edges.';

  @override
  String get cropReset => 'Reset';

  @override
  String cropHandleLabel(String corner) {
    return '$corner corner of the crop area';
  }

  @override
  String get cropTopLeft => 'Top left';

  @override
  String get cropTopRight => 'Top right';

  @override
  String get cropBottomRight => 'Bottom right';

  @override
  String get cropBottomLeft => 'Bottom left';

  @override
  String get filterOriginal => 'Original';

  @override
  String get filterEnhanced => 'Enhanced';

  @override
  String get filterGrayscale => 'Grayscale';

  @override
  String get filterBlackWhite => 'Black & white';

  @override
  String get rotateRight => 'Rotate right';

  @override
  String get applyFilterToAll => 'Apply to all pages';

  @override
  String get editorPreviewFailed => 'Could not update the preview.';

  @override
  String get editorSavingPage => 'Saving page…';

  @override
  String cropPageOf(int current, int total) {
    return 'Crop page $current of $total';
  }

  @override
  String get reviewTitle => 'New document';

  @override
  String get reviewNameLabel => 'Document name';

  @override
  String get reviewSave => 'Save document';

  @override
  String get reviewSaving => 'Saving…';

  @override
  String get reviewAddPages => 'Add pages';

  @override
  String reviewPagesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pages',
      one: '1 page',
    );
    return '$_temp0';
  }

  @override
  String get reviewDiscardTitle => 'Discard this scan?';

  @override
  String get reviewDiscardBody => 'The pages you captured will be deleted.';

  @override
  String get reviewDiscard => 'Discard';

  @override
  String get reviewKeep => 'Keep editing';

  @override
  String reviewPageLabel(int number) {
    return 'Page $number';
  }

  @override
  String reviewEditPage(int number) {
    return 'Edit page $number';
  }

  @override
  String reviewDeletePage(int number) {
    return 'Delete page $number';
  }

  @override
  String get reviewDragHint => 'Drag the handle to reorder';

  @override
  String reviewReorderHandle(int number) {
    return 'Reorder page $number';
  }

  @override
  String get reviewEmpty => 'No pages yet. Add some to continue.';

  @override
  String get reviewSaveFailed => 'Could not save the document.';

  @override
  String get libraryTitle => 'Library';

  @override
  String get searchHint => 'Search names and text inside scans';

  @override
  String get searchClear => 'Clear search';

  @override
  String get sortNewest => 'Newest first';

  @override
  String get sortOldest => 'Oldest first';

  @override
  String get sortNameAsc => 'Name A–Z';

  @override
  String get sortNameDesc => 'Name Z–A';

  @override
  String get sortMenuLabel => 'Sort';

  @override
  String get viewGrid => 'Grid view';

  @override
  String get viewList => 'List view';

  @override
  String get foldersAll => 'All';

  @override
  String get folderNew => 'New folder';

  @override
  String get folderNameLabel => 'Folder name';

  @override
  String get folderRenameTitle => 'Rename folder';

  @override
  String get folderDeleteTitle => 'Delete folder?';

  @override
  String get folderDeleteBody =>
      'Documents inside are kept and become unfiled.';

  @override
  String get folderMoveTitle => 'Move to folder';

  @override
  String get folderNone => 'No folder';

  @override
  String selectedCount(int count) {
    return '$count selected';
  }

  @override
  String get selectionClear => 'Cancel selection';

  @override
  String documentsDeleted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count documents deleted',
      one: 'Document deleted',
    );
    return '$_temp0';
  }

  @override
  String get libraryEmptyTitle => 'No documents yet';

  @override
  String get libraryEmptyBody =>
      'Scanned and imported documents will appear here.';

  @override
  String get libraryNoResultsTitle => 'No matches';

  @override
  String libraryNoResultsBody(String query) {
    return 'Nothing matched “$query”.';
  }

  @override
  String documentCopyTitle(String title) {
    return '$title (copy)';
  }

  @override
  String documentSemantics(String title, int pages) {
    String _temp0 = intl.Intl.pluralLogic(
      pages,
      locale: localeName,
      other: '$pages pages',
      one: '1 page',
    );
    return '$title, $_temp0';
  }

  @override
  String get detailNotFound => 'This document no longer exists.';

  @override
  String get detailRenameTitle => 'Rename document';

  @override
  String get detailDuplicate => 'Duplicate';

  @override
  String get detailExport => 'Export';

  @override
  String get detailCopyText => 'Copy text';

  @override
  String get detailTextCopied => 'Text copied';

  @override
  String get detailNoText => 'No text was found in this document yet.';

  @override
  String get detailAddPages => 'Add pages';

  @override
  String get detailEditPage => 'Edit page';

  @override
  String get detailDeletePage => 'Delete page';

  @override
  String get detailLastPage =>
      'A document needs at least one page. Delete the whole document instead.';

  @override
  String get detailPageDeleted => 'Page deleted';

  @override
  String get detailTagsLabel => 'Tags';

  @override
  String get detailAddTag => 'Add tag';

  @override
  String get detailTagHint => 'Tag name';

  @override
  String get detailIndexing => 'Reading text…';

  @override
  String detailCreated(String date) {
    return 'Scanned $date';
  }

  @override
  String get exportTitle => 'Export';

  @override
  String get exportPdf => 'PDF';

  @override
  String get exportPdfSubtitle => 'One searchable file, text layer included';

  @override
  String get exportImages => 'Images (JPG)';

  @override
  String get exportImagesSubtitle => 'One picture per page';

  @override
  String get exportBuilding => 'Preparing file…';

  @override
  String get exportFailed => 'Export failed. Please try again.';

  @override
  String exportShareSubject(String title) {
    return '$title';
  }

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get themeSystem => 'Match system';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get settingsScanning => 'Scanning';

  @override
  String get settingsOcrLanguage => 'Text recognition language';

  @override
  String get ocrLatin => 'Latin (English, Spanish, French…)';

  @override
  String get ocrDevanagari => 'Devanagari (Hindi, Marathi…)';

  @override
  String get ocrChinese => 'Chinese';

  @override
  String get ocrJapanese => 'Japanese';

  @override
  String get ocrKorean => 'Korean';

  @override
  String get settingsPrivacy => 'Privacy';

  @override
  String get settingsPrivacyTitle => 'Your scans never leave this device';

  @override
  String get settingsPrivacyBody =>
      'PacketPal has no account and no cloud upload. Text recognition runs on the phone. Nothing about your documents is sent anywhere.';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get settingsHelp => 'Help & FAQ';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsLicenses => 'Open-source licenses';

  @override
  String get settingsAboutBody =>
      'Privacy-first document scanner and packet builder.';

  @override
  String get settingsComingSoon => 'Coming soon';

  @override
  String get packetsTitle => 'Packets';

  @override
  String get packetsEmptyTitle => 'Application packets are on the way';

  @override
  String get packetsEmptyBody =>
      'Soon you will be able to collect documents for rental, loan, visa and job applications with a checklist and export them in one tap.';

  @override
  String get helpTitle => 'Help';

  @override
  String get helpQ1 => 'Where are my scans stored?';

  @override
  String get helpA1 =>
      'Only in private storage inside this app on your phone. They are not uploaded anywhere.';

  @override
  String get helpQ2 => 'How do I scan several pages?';

  @override
  String get helpA2 =>
      'Tap the scan button and keep capturing pages. You can also add pages later from a document.';

  @override
  String get helpQ3 => 'Can I change a scan after saving?';

  @override
  String get helpA3 =>
      'Yes. Open the document, choose a page and adjust the crop, filter or rotation. The original picture is always kept.';

  @override
  String get helpQ4 => 'How does search work?';

  @override
  String get helpA4 =>
      'Text in every scan is read on your phone, so you can search for names and words inside documents.';

  @override
  String get kindBankStatement => 'Bank Statement';

  @override
  String get kindPayStub => 'Pay Stub';

  @override
  String get kindPassport => 'Passport';

  @override
  String get kindDriverLicense => 'Driver\'s License';

  @override
  String get kindIdCard => 'ID Card';

  @override
  String get kindUtilityBill => 'Utility Bill';

  @override
  String get kindLeaseAgreement => 'Lease Agreement';

  @override
  String get kindTaxDocument => 'Tax Document';

  @override
  String get kindInvoice => 'Invoice';

  @override
  String get kindReceipt => 'Receipt';

  @override
  String get kindReferenceLetter => 'Reference Letter';

  @override
  String get kindOfferLetter => 'Offer Letter';

  @override
  String get kindInsurance => 'Insurance';

  @override
  String get kindBirthCertificate => 'Birth Certificate';

  @override
  String get kindFallback => 'Document';
}
