import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'PacketPal'**
  String get appName;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navLibrary.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get navLibrary;

  /// No description provided for @navPackets.
  ///
  /// In en, this message translates to:
  /// **'Packets'**
  String get navPackets;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @scanButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Scan a document'**
  String get scanButtonLabel;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @commonDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get commonDone;

  /// No description provided for @commonNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get commonNext;

  /// No description provided for @commonBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// No description provided for @commonSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get commonSkip;

  /// No description provided for @commonUndo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get commonUndo;

  /// No description provided for @commonRename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get commonRename;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @commonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// No description provided for @commonCreate.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get commonCreate;

  /// No description provided for @commonMove.
  ///
  /// In en, this message translates to:
  /// **'Move'**
  String get commonMove;

  /// No description provided for @commonCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get commonCopy;

  /// No description provided for @commonLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get commonLoading;

  /// No description provided for @commonGenericError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get commonGenericError;

  /// No description provided for @commonOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get commonOpen;

  /// No description provided for @onboarding1Title.
  ///
  /// In en, this message translates to:
  /// **'Scans that stay on your phone'**
  String get onboarding1Title;

  /// No description provided for @onboarding1Body.
  ///
  /// In en, this message translates to:
  /// **'No account, no cloud upload, no tracking of what you scan. Your documents live in private app storage on this device.'**
  String get onboarding1Body;

  /// No description provided for @onboarding2Title.
  ///
  /// In en, this message translates to:
  /// **'Build application packets'**
  String get onboarding2Title;

  /// No description provided for @onboarding2Body.
  ///
  /// In en, this message translates to:
  /// **'Collect the documents for a rental, loan, visa or job application in the right order, with a checklist so nothing is missing.'**
  String get onboarding2Body;

  /// No description provided for @onboarding3Title.
  ///
  /// In en, this message translates to:
  /// **'Honest and simple'**
  String get onboarding3Title;

  /// No description provided for @onboarding3Body.
  ///
  /// In en, this message translates to:
  /// **'Unlimited scanning with no watermark and no ads. Optional extras are priced up front, before you ever pay.'**
  String get onboarding3Body;

  /// No description provided for @onboardingGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get onboardingGetStarted;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboardingPage.
  ///
  /// In en, this message translates to:
  /// **'Page {current} of {total}'**
  String onboardingPage(int current, int total);

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'PacketPal'**
  String get homeTitle;

  /// No description provided for @homeTagline.
  ///
  /// In en, this message translates to:
  /// **'Your documents stay on this phone.'**
  String get homeTagline;

  /// No description provided for @homeQuickScan.
  ///
  /// In en, this message translates to:
  /// **'Quick scan'**
  String get homeQuickScan;

  /// No description provided for @homeQuickScanSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Capture a single document'**
  String get homeQuickScanSubtitle;

  /// No description provided for @homeNewPacket.
  ///
  /// In en, this message translates to:
  /// **'New packet'**
  String get homeNewPacket;

  /// No description provided for @homeNewPacketSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Rental, loan, visa, job'**
  String get homeNewPacketSubtitle;

  /// No description provided for @homeRecent.
  ///
  /// In en, this message translates to:
  /// **'Recent documents'**
  String get homeRecent;

  /// No description provided for @homeSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get homeSeeAll;

  /// No description provided for @homeEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Nothing scanned yet'**
  String get homeEmptyTitle;

  /// No description provided for @homeEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Tap the scan button to capture your first document. It is saved only on this device.'**
  String get homeEmptyBody;

  /// No description provided for @scanRationaleTitle.
  ///
  /// In en, this message translates to:
  /// **'Camera access'**
  String get scanRationaleTitle;

  /// No description provided for @scanRationaleBody.
  ///
  /// In en, this message translates to:
  /// **'PacketPal opens your camera to photograph documents. Pictures are processed and stored on this device only and are never uploaded. Your phone will now ask for permission.'**
  String get scanRationaleBody;

  /// No description provided for @scanRationaleContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get scanRationaleContinue;

  /// No description provided for @scanAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add pages'**
  String get scanAddTitle;

  /// No description provided for @scanFromCamera.
  ///
  /// In en, this message translates to:
  /// **'Scan with camera'**
  String get scanFromCamera;

  /// No description provided for @scanFromCameraSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Automatic edge detection'**
  String get scanFromCameraSubtitle;

  /// No description provided for @scanFromPhotos.
  ///
  /// In en, this message translates to:
  /// **'Import from photos'**
  String get scanFromPhotos;

  /// No description provided for @scanFromPhotosSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pick pictures from your gallery'**
  String get scanFromPhotosSubtitle;

  /// No description provided for @scanFromFiles.
  ///
  /// In en, this message translates to:
  /// **'Import from files'**
  String get scanFromFiles;

  /// No description provided for @scanFromFilesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Images and PDFs'**
  String get scanFromFilesSubtitle;

  /// No description provided for @scanImporting.
  ///
  /// In en, this message translates to:
  /// **'Preparing pages…'**
  String get scanImporting;

  /// No description provided for @scanFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not capture: {message}'**
  String scanFailed(String message);

  /// No description provided for @scanNothingAdded.
  ///
  /// In en, this message translates to:
  /// **'No pages were added.'**
  String get scanNothingAdded;

  /// No description provided for @editorTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit page'**
  String get editorTitle;

  /// No description provided for @editorCrop.
  ///
  /// In en, this message translates to:
  /// **'Crop'**
  String get editorCrop;

  /// No description provided for @editorFilters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get editorFilters;

  /// No description provided for @cropHint.
  ///
  /// In en, this message translates to:
  /// **'Drag the corners to fit the page edges.'**
  String get cropHint;

  /// No description provided for @cropReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get cropReset;

  /// No description provided for @cropHandleLabel.
  ///
  /// In en, this message translates to:
  /// **'{corner} corner of the crop area'**
  String cropHandleLabel(String corner);

  /// No description provided for @cropTopLeft.
  ///
  /// In en, this message translates to:
  /// **'Top left'**
  String get cropTopLeft;

  /// No description provided for @cropTopRight.
  ///
  /// In en, this message translates to:
  /// **'Top right'**
  String get cropTopRight;

  /// No description provided for @cropBottomRight.
  ///
  /// In en, this message translates to:
  /// **'Bottom right'**
  String get cropBottomRight;

  /// No description provided for @cropBottomLeft.
  ///
  /// In en, this message translates to:
  /// **'Bottom left'**
  String get cropBottomLeft;

  /// No description provided for @filterOriginal.
  ///
  /// In en, this message translates to:
  /// **'Original'**
  String get filterOriginal;

  /// No description provided for @filterEnhanced.
  ///
  /// In en, this message translates to:
  /// **'Enhanced'**
  String get filterEnhanced;

  /// No description provided for @filterGrayscale.
  ///
  /// In en, this message translates to:
  /// **'Grayscale'**
  String get filterGrayscale;

  /// No description provided for @filterBlackWhite.
  ///
  /// In en, this message translates to:
  /// **'Black & white'**
  String get filterBlackWhite;

  /// No description provided for @rotateRight.
  ///
  /// In en, this message translates to:
  /// **'Rotate right'**
  String get rotateRight;

  /// No description provided for @applyFilterToAll.
  ///
  /// In en, this message translates to:
  /// **'Apply to all pages'**
  String get applyFilterToAll;

  /// No description provided for @editorPreviewFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not update the preview.'**
  String get editorPreviewFailed;

  /// No description provided for @editorSavingPage.
  ///
  /// In en, this message translates to:
  /// **'Saving page…'**
  String get editorSavingPage;

  /// No description provided for @cropPageOf.
  ///
  /// In en, this message translates to:
  /// **'Crop page {current} of {total}'**
  String cropPageOf(int current, int total);

  /// No description provided for @reviewTitle.
  ///
  /// In en, this message translates to:
  /// **'New document'**
  String get reviewTitle;

  /// No description provided for @reviewNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Document name'**
  String get reviewNameLabel;

  /// No description provided for @reviewSave.
  ///
  /// In en, this message translates to:
  /// **'Save document'**
  String get reviewSave;

  /// No description provided for @reviewSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get reviewSaving;

  /// No description provided for @reviewAddPages.
  ///
  /// In en, this message translates to:
  /// **'Add pages'**
  String get reviewAddPages;

  /// No description provided for @reviewPagesCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 page} other{{count} pages}}'**
  String reviewPagesCount(int count);

  /// No description provided for @reviewDiscardTitle.
  ///
  /// In en, this message translates to:
  /// **'Discard this scan?'**
  String get reviewDiscardTitle;

  /// No description provided for @reviewDiscardBody.
  ///
  /// In en, this message translates to:
  /// **'The pages you captured will be deleted.'**
  String get reviewDiscardBody;

  /// No description provided for @reviewDiscard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get reviewDiscard;

  /// No description provided for @reviewKeep.
  ///
  /// In en, this message translates to:
  /// **'Keep editing'**
  String get reviewKeep;

  /// No description provided for @reviewPageLabel.
  ///
  /// In en, this message translates to:
  /// **'Page {number}'**
  String reviewPageLabel(int number);

  /// No description provided for @reviewEditPage.
  ///
  /// In en, this message translates to:
  /// **'Edit page {number}'**
  String reviewEditPage(int number);

  /// No description provided for @reviewDeletePage.
  ///
  /// In en, this message translates to:
  /// **'Delete page {number}'**
  String reviewDeletePage(int number);

  /// No description provided for @reviewDragHint.
  ///
  /// In en, this message translates to:
  /// **'Drag the handle to reorder'**
  String get reviewDragHint;

  /// No description provided for @reviewReorderHandle.
  ///
  /// In en, this message translates to:
  /// **'Reorder page {number}'**
  String reviewReorderHandle(int number);

  /// No description provided for @reviewEmpty.
  ///
  /// In en, this message translates to:
  /// **'No pages yet. Add some to continue.'**
  String get reviewEmpty;

  /// No description provided for @reviewSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not save the document.'**
  String get reviewSaveFailed;

  /// No description provided for @libraryTitle.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get libraryTitle;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search names and text inside scans'**
  String get searchHint;

  /// No description provided for @searchClear.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get searchClear;

  /// No description provided for @sortNewest.
  ///
  /// In en, this message translates to:
  /// **'Newest first'**
  String get sortNewest;

  /// No description provided for @sortOldest.
  ///
  /// In en, this message translates to:
  /// **'Oldest first'**
  String get sortOldest;

  /// No description provided for @sortNameAsc.
  ///
  /// In en, this message translates to:
  /// **'Name A–Z'**
  String get sortNameAsc;

  /// No description provided for @sortNameDesc.
  ///
  /// In en, this message translates to:
  /// **'Name Z–A'**
  String get sortNameDesc;

  /// No description provided for @sortMenuLabel.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sortMenuLabel;

  /// No description provided for @viewGrid.
  ///
  /// In en, this message translates to:
  /// **'Grid view'**
  String get viewGrid;

  /// No description provided for @viewList.
  ///
  /// In en, this message translates to:
  /// **'List view'**
  String get viewList;

  /// No description provided for @foldersAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get foldersAll;

  /// No description provided for @folderNew.
  ///
  /// In en, this message translates to:
  /// **'New folder'**
  String get folderNew;

  /// No description provided for @folderNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Folder name'**
  String get folderNameLabel;

  /// No description provided for @folderRenameTitle.
  ///
  /// In en, this message translates to:
  /// **'Rename folder'**
  String get folderRenameTitle;

  /// No description provided for @folderDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete folder?'**
  String get folderDeleteTitle;

  /// No description provided for @folderDeleteBody.
  ///
  /// In en, this message translates to:
  /// **'Documents inside are kept and become unfiled.'**
  String get folderDeleteBody;

  /// No description provided for @folderMoveTitle.
  ///
  /// In en, this message translates to:
  /// **'Move to folder'**
  String get folderMoveTitle;

  /// No description provided for @folderNone.
  ///
  /// In en, this message translates to:
  /// **'No folder'**
  String get folderNone;

  /// No description provided for @selectedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String selectedCount(int count);

  /// No description provided for @selectionClear.
  ///
  /// In en, this message translates to:
  /// **'Cancel selection'**
  String get selectionClear;

  /// No description provided for @documentsDeleted.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Document deleted} other{{count} documents deleted}}'**
  String documentsDeleted(int count);

  /// No description provided for @libraryEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No documents yet'**
  String get libraryEmptyTitle;

  /// No description provided for @libraryEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Scanned and imported documents will appear here.'**
  String get libraryEmptyBody;

  /// No description provided for @libraryNoResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'No matches'**
  String get libraryNoResultsTitle;

  /// No description provided for @libraryNoResultsBody.
  ///
  /// In en, this message translates to:
  /// **'Nothing matched “{query}”.'**
  String libraryNoResultsBody(String query);

  /// No description provided for @documentCopyTitle.
  ///
  /// In en, this message translates to:
  /// **'{title} (copy)'**
  String documentCopyTitle(String title);

  /// No description provided for @documentSemantics.
  ///
  /// In en, this message translates to:
  /// **'{title}, {pages, plural, =1{1 page} other{{pages} pages}}'**
  String documentSemantics(String title, int pages);

  /// No description provided for @detailNotFound.
  ///
  /// In en, this message translates to:
  /// **'This document no longer exists.'**
  String get detailNotFound;

  /// No description provided for @detailRenameTitle.
  ///
  /// In en, this message translates to:
  /// **'Rename document'**
  String get detailRenameTitle;

  /// No description provided for @detailDuplicate.
  ///
  /// In en, this message translates to:
  /// **'Duplicate'**
  String get detailDuplicate;

  /// No description provided for @detailExport.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get detailExport;

  /// No description provided for @detailCopyText.
  ///
  /// In en, this message translates to:
  /// **'Copy text'**
  String get detailCopyText;

  /// No description provided for @detailTextCopied.
  ///
  /// In en, this message translates to:
  /// **'Text copied'**
  String get detailTextCopied;

  /// No description provided for @detailNoText.
  ///
  /// In en, this message translates to:
  /// **'No text was found in this document yet.'**
  String get detailNoText;

  /// No description provided for @detailAddPages.
  ///
  /// In en, this message translates to:
  /// **'Add pages'**
  String get detailAddPages;

  /// No description provided for @detailEditPage.
  ///
  /// In en, this message translates to:
  /// **'Edit page'**
  String get detailEditPage;

  /// No description provided for @detailDeletePage.
  ///
  /// In en, this message translates to:
  /// **'Delete page'**
  String get detailDeletePage;

  /// No description provided for @detailLastPage.
  ///
  /// In en, this message translates to:
  /// **'A document needs at least one page. Delete the whole document instead.'**
  String get detailLastPage;

  /// No description provided for @detailPageDeleted.
  ///
  /// In en, this message translates to:
  /// **'Page deleted'**
  String get detailPageDeleted;

  /// No description provided for @detailTagsLabel.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get detailTagsLabel;

  /// No description provided for @detailAddTag.
  ///
  /// In en, this message translates to:
  /// **'Add tag'**
  String get detailAddTag;

  /// No description provided for @detailTagHint.
  ///
  /// In en, this message translates to:
  /// **'Tag name'**
  String get detailTagHint;

  /// No description provided for @detailIndexing.
  ///
  /// In en, this message translates to:
  /// **'Reading text…'**
  String get detailIndexing;

  /// No description provided for @detailCreated.
  ///
  /// In en, this message translates to:
  /// **'Scanned {date}'**
  String detailCreated(String date);

  /// No description provided for @exportTitle.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get exportTitle;

  /// No description provided for @exportPdf.
  ///
  /// In en, this message translates to:
  /// **'PDF'**
  String get exportPdf;

  /// No description provided for @exportPdfSubtitle.
  ///
  /// In en, this message translates to:
  /// **'One searchable file, text layer included'**
  String get exportPdfSubtitle;

  /// No description provided for @exportImages.
  ///
  /// In en, this message translates to:
  /// **'Images (JPG)'**
  String get exportImages;

  /// No description provided for @exportImagesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'One picture per page'**
  String get exportImagesSubtitle;

  /// No description provided for @exportBuilding.
  ///
  /// In en, this message translates to:
  /// **'Preparing file…'**
  String get exportBuilding;

  /// No description provided for @exportFailed.
  ///
  /// In en, this message translates to:
  /// **'Export failed. Please try again.'**
  String get exportFailed;

  /// No description provided for @exportShareSubject.
  ///
  /// In en, this message translates to:
  /// **'{title}'**
  String exportShareSubject(String title);

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'Match system'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @settingsScanning.
  ///
  /// In en, this message translates to:
  /// **'Scanning'**
  String get settingsScanning;

  /// No description provided for @settingsOcrLanguage.
  ///
  /// In en, this message translates to:
  /// **'Text recognition language'**
  String get settingsOcrLanguage;

  /// No description provided for @ocrLatin.
  ///
  /// In en, this message translates to:
  /// **'Latin (English, Spanish, French…)'**
  String get ocrLatin;

  /// No description provided for @ocrDevanagari.
  ///
  /// In en, this message translates to:
  /// **'Devanagari (Hindi, Marathi…)'**
  String get ocrDevanagari;

  /// No description provided for @ocrChinese.
  ///
  /// In en, this message translates to:
  /// **'Chinese'**
  String get ocrChinese;

  /// No description provided for @ocrJapanese.
  ///
  /// In en, this message translates to:
  /// **'Japanese'**
  String get ocrJapanese;

  /// No description provided for @ocrKorean.
  ///
  /// In en, this message translates to:
  /// **'Korean'**
  String get ocrKorean;

  /// No description provided for @settingsPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get settingsPrivacy;

  /// No description provided for @settingsPrivacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your scans never leave this device'**
  String get settingsPrivacyTitle;

  /// No description provided for @settingsPrivacyBody.
  ///
  /// In en, this message translates to:
  /// **'PacketPal has no account and no cloud upload. Text recognition runs on the phone. Nothing about your documents is sent anywhere.'**
  String get settingsPrivacyBody;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @settingsHelp.
  ///
  /// In en, this message translates to:
  /// **'Help & FAQ'**
  String get settingsHelp;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @settingsLicenses.
  ///
  /// In en, this message translates to:
  /// **'Open-source licenses'**
  String get settingsLicenses;

  /// No description provided for @settingsAboutBody.
  ///
  /// In en, this message translates to:
  /// **'Privacy-first document scanner and packet builder.'**
  String get settingsAboutBody;

  /// No description provided for @settingsComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get settingsComingSoon;

  /// No description provided for @packetsTitle.
  ///
  /// In en, this message translates to:
  /// **'Packets'**
  String get packetsTitle;

  /// No description provided for @packetsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Application packets are on the way'**
  String get packetsEmptyTitle;

  /// No description provided for @packetsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Soon you will be able to collect documents for rental, loan, visa and job applications with a checklist and export them in one tap.'**
  String get packetsEmptyBody;

  /// No description provided for @helpTitle.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get helpTitle;

  /// No description provided for @helpQ1.
  ///
  /// In en, this message translates to:
  /// **'Where are my scans stored?'**
  String get helpQ1;

  /// No description provided for @helpA1.
  ///
  /// In en, this message translates to:
  /// **'Only in private storage inside this app on your phone. They are not uploaded anywhere.'**
  String get helpA1;

  /// No description provided for @helpQ2.
  ///
  /// In en, this message translates to:
  /// **'How do I scan several pages?'**
  String get helpQ2;

  /// No description provided for @helpA2.
  ///
  /// In en, this message translates to:
  /// **'Tap the scan button and keep capturing pages. You can also add pages later from a document.'**
  String get helpA2;

  /// No description provided for @helpQ3.
  ///
  /// In en, this message translates to:
  /// **'Can I change a scan after saving?'**
  String get helpQ3;

  /// No description provided for @helpA3.
  ///
  /// In en, this message translates to:
  /// **'Yes. Open the document, choose a page and adjust the crop, filter or rotation. The original picture is always kept.'**
  String get helpA3;

  /// No description provided for @helpQ4.
  ///
  /// In en, this message translates to:
  /// **'How does search work?'**
  String get helpQ4;

  /// No description provided for @helpA4.
  ///
  /// In en, this message translates to:
  /// **'Text in every scan is read on your phone, so you can search for names and words inside documents.'**
  String get helpA4;

  /// No description provided for @kindBankStatement.
  ///
  /// In en, this message translates to:
  /// **'Bank Statement'**
  String get kindBankStatement;

  /// No description provided for @kindPayStub.
  ///
  /// In en, this message translates to:
  /// **'Pay Stub'**
  String get kindPayStub;

  /// No description provided for @kindPassport.
  ///
  /// In en, this message translates to:
  /// **'Passport'**
  String get kindPassport;

  /// No description provided for @kindDriverLicense.
  ///
  /// In en, this message translates to:
  /// **'Driver\'s License'**
  String get kindDriverLicense;

  /// No description provided for @kindIdCard.
  ///
  /// In en, this message translates to:
  /// **'ID Card'**
  String get kindIdCard;

  /// No description provided for @kindUtilityBill.
  ///
  /// In en, this message translates to:
  /// **'Utility Bill'**
  String get kindUtilityBill;

  /// No description provided for @kindLeaseAgreement.
  ///
  /// In en, this message translates to:
  /// **'Lease Agreement'**
  String get kindLeaseAgreement;

  /// No description provided for @kindTaxDocument.
  ///
  /// In en, this message translates to:
  /// **'Tax Document'**
  String get kindTaxDocument;

  /// No description provided for @kindInvoice.
  ///
  /// In en, this message translates to:
  /// **'Invoice'**
  String get kindInvoice;

  /// No description provided for @kindReceipt.
  ///
  /// In en, this message translates to:
  /// **'Receipt'**
  String get kindReceipt;

  /// No description provided for @kindReferenceLetter.
  ///
  /// In en, this message translates to:
  /// **'Reference Letter'**
  String get kindReferenceLetter;

  /// No description provided for @kindOfferLetter.
  ///
  /// In en, this message translates to:
  /// **'Offer Letter'**
  String get kindOfferLetter;

  /// No description provided for @kindInsurance.
  ///
  /// In en, this message translates to:
  /// **'Insurance'**
  String get kindInsurance;

  /// No description provided for @kindBirthCertificate.
  ///
  /// In en, this message translates to:
  /// **'Birth Certificate'**
  String get kindBirthCertificate;

  /// No description provided for @kindFallback.
  ///
  /// In en, this message translates to:
  /// **'Document'**
  String get kindFallback;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
