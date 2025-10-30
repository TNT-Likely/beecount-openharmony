import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Bee Accounting';

  @override
  String get tabHome => 'Home';

  @override
  String get tabAnalytics => 'Charts';

  @override
  String get tabLedgers => 'Ledgers';

  @override
  String get tabMine => 'Mine';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get commonSave => 'Save';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonAdd => 'Add';

  @override
  String get commonOk => 'OK';

  @override
  String get commonYes => 'Yes';

  @override
  String get commonNo => 'No';

  @override
  String get commonLoading => 'Loading...';

  @override
  String get commonEmpty => 'No data';

  @override
  String get commonError => 'Error';

  @override
  String get commonSuccess => 'Success';

  @override
  String get commonFailed => 'Failed';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonBack => 'Back';

  @override
  String get commonNext => 'Next';

  @override
  String get commonPrevious => 'Previous';

  @override
  String get commonFinish => 'Finish';

  @override
  String get commonClose => 'Close';

  @override
  String get commonCopy => 'Copy';

  @override
  String get commonSearch => 'Search';

  @override
  String get commonNoteHint => 'Note...';

  @override
  String get commonFilter => 'Filter';

  @override
  String get commonClear => 'Clear';

  @override
  String get commonSelectAll => 'Select All';

  @override
  String get commonSettings => 'Settings';

  @override
  String get commonHelp => 'Help';

  @override
  String get commonAbout => 'About';

  @override
  String get commonLanguage => 'Language';

  @override
  String get commonCurrent => 'Current';

  @override
  String get commonTutorial => 'Tutorial';

  @override
  String get commonConfigure => 'Configure';

  @override
  String get commonWeekdayMonday => 'Monday';

  @override
  String get commonWeekdayTuesday => 'Tuesday';

  @override
  String get commonWeekdayWednesday => 'Wednesday';

  @override
  String get commonWeekdayThursday => 'Thursday';

  @override
  String get commonWeekdayFriday => 'Friday';

  @override
  String get commonWeekdaySaturday => 'Saturday';

  @override
  String get commonWeekdaySunday => 'Sunday';

  @override
  String get homeTitle => 'Bee Accounting';

  @override
  String get homeIncome => 'Income';

  @override
  String get homeExpense => 'Expense';

  @override
  String get homeBalance => 'Balance';

  @override
  String get homeTotal => 'Total';

  @override
  String get homeAverage => 'Average';

  @override
  String get homeDailyAvg => 'Daily Avg';

  @override
  String get homeMonthlyAvg => 'Monthly Avg';

  @override
  String get homeNoRecords => 'No records yet';

  @override
  String get homeAddRecord => 'Add record by tapping the plus button';

  @override
  String get homeHideAmounts => 'Hide amounts';

  @override
  String get homeShowAmounts => 'Show amounts';

  @override
  String get homeSelectDate => 'Select date';

  @override
  String get homeAppTitle => 'Bee Accounting';

  @override
  String get homeSearch => 'Search';

  @override
  String get homeShowAmount => 'Show amounts';

  @override
  String get homeHideAmount => 'Hide amounts';

  @override
  String homeYear(int year) {
    return '$year';
  }

  @override
  String homeMonth(String month) {
    return '${month}M';
  }

  @override
  String get homeNoRecordsSubtext => 'Tap the plus button at the bottom to add a record';

  @override
  String get searchTitle => 'Search';

  @override
  String get searchHint => 'Search notes, categories or amounts...';

  @override
  String get searchAmountRange => 'Amount range filter';

  @override
  String get searchMinAmount => 'Min amount';

  @override
  String get searchMaxAmount => 'Max amount';

  @override
  String get searchTo => 'to';

  @override
  String get searchNoInput => 'Enter keywords to start searching';

  @override
  String get searchNoResults => 'No matching results found';

  @override
  String get searchResultsEmpty => 'No matching results found';

  @override
  String get searchResultsEmptyHint => 'Try other keywords or adjust filter conditions';

  @override
  String get analyticsTitle => 'Analytics';

  @override
  String get analyticsMonth => 'Month';

  @override
  String get analyticsYear => 'Year';

  @override
  String get analyticsAll => 'All';

  @override
  String get analyticsSummary => 'Summary';

  @override
  String get analyticsCategoryRanking => 'Category Ranking';

  @override
  String get analyticsCurrentPeriod => 'Current Period';

  @override
  String get analyticsNoDataSubtext => 'Swipe left/right to switch periods, or tap button to toggle income/expense';

  @override
  String get analyticsSwipeHint => 'Swipe left/right to change period';

  @override
  String get analyticsTipContent => '1) Swipe left/right at bottom to switch Expense/Income/Balance\\n2) Swipe left/right in chart area to switch periods';

  @override
  String analyticsSwitchTo(String type) {
    return 'Switch to $type';
  }

  @override
  String get analyticsTipHeader => 'Tip: Top capsule can switch Month/Year/All';

  @override
  String get analyticsSwipeToSwitch => 'Swipe to switch';

  @override
  String get analyticsAllYears => 'All Years';

  @override
  String get analyticsToday => 'Today';

  @override
  String get splashAppName => 'Bee Accounting';

  @override
  String get splashSlogan => 'Record Every Drop';

  @override
  String get splashSecurityTitle => 'Open Source Data Security';

  @override
  String get splashSecurityFeature1 => '• Local data storage, complete privacy control';

  @override
  String get splashSecurityFeature2 => '• Open source code transparency, trustworthy security';

  @override
  String get splashSecurityFeature3 => '• Optional cloud sync, consistent data across devices';

  @override
  String get splashInitializing => 'Initializing data...';

  @override
  String get ledgersTitle => 'Ledger Management';

  @override
  String get ledgersNew => 'New Ledger';

  @override
  String get ledgersClear => 'Clear Current Ledger';

  @override
  String get ledgersClearConfirm => 'Clear current ledger?';

  @override
  String get ledgersClearMessage => 'All transaction records in this ledger will be deleted and cannot be recovered.';

  @override
  String get ledgersEdit => 'Edit Ledger';

  @override
  String get ledgersDelete => 'Delete Ledger';

  @override
  String get ledgersDeleteConfirm => 'Delete Ledger';

  @override
  String get ledgersDeleteMessage => 'Are you sure you want to delete this ledger and all its records? This action cannot be undone.\\nIf there is a backup in the cloud, it will also be deleted.';

  @override
  String get ledgersDeleted => 'Deleted';

  @override
  String get ledgersDeleteFailed => 'Delete Failed';

  @override
  String ledgersRecordsDeleted(int count) {
    return 'Deleted $count records';
  }

  @override
  String get ledgersName => 'Name';

  @override
  String get ledgersDefaultLedgerName => 'Default Ledger';

  @override
  String get ledgersDefaultAccountName => 'Cash';

  @override
  String get accountTitle => 'Account';

  @override
  String get ledgersCurrency => 'Currency';

  @override
  String get ledgersSelectCurrency => 'Select Currency';

  @override
  String get ledgersSearchCurrency => 'Search: Chinese or code';

  @override
  String get ledgersCreate => 'Create';

  @override
  String get ledgersActions => 'Actions';

  @override
  String ledgersRecords(String count) {
    return 'Records: $count';
  }

  @override
  String ledgersBalance(String balance) {
    return 'Balance: $balance';
  }

  @override
  String get categoryTitle => 'Category Management';

  @override
  String get categoryNew => 'New Category';

  @override
  String get categoryExpense => 'Expense Categories';

  @override
  String get categoryIncome => 'Income Categories';

  @override
  String get categoryEmpty => 'No categories';

  @override
  String get categoryDefault => 'Default Category';

  @override
  String get categoryCustomTag => 'Custom';

  @override
  String get categoryReorderTip => 'Long press to drag and reorder categories';

  @override
  String categoryLoadFailed(String error) {
    return 'Load failed: $error';
  }

  @override
  String get iconPickerTitle => 'Select Icon';

  @override
  String get iconCategoryFood => 'Food';

  @override
  String get iconCategoryTransport => 'Transport';

  @override
  String get iconCategoryShopping => 'Shopping';

  @override
  String get iconCategoryEntertainment => 'Entertainment';

  @override
  String get iconCategoryLife => 'Life';

  @override
  String get iconCategoryHealth => 'Health';

  @override
  String get iconCategoryEducation => 'Education';

  @override
  String get iconCategoryWork => 'Work';

  @override
  String get iconCategoryFinance => 'Finance';

  @override
  String get iconCategoryReward => 'Reward';

  @override
  String get iconCategoryOther => 'Other';

  @override
  String get iconCategoryDining => 'Dining';

  @override
  String get importTitle => 'Import Bills';

  @override
  String get importSelectFile => 'Please select a file to import (CSV/TSV/XLSX supported)';

  @override
  String get importBillType => 'Bill Type';

  @override
  String get importBillTypeGeneric => 'Generic CSV';

  @override
  String get importBillTypeAlipay => 'Alipay';

  @override
  String get importBillTypeWechat => 'WeChat';

  @override
  String get importChooseFile => 'Choose File';

  @override
  String get importNoFileSelected => 'No file selected';

  @override
  String get importHint => 'Tip: Please select a file to start importing (CSV/TSV/XLSX)';

  @override
  String get importReading => 'Reading file…';

  @override
  String get importPreparing => 'Preparing…';

  @override
  String importColumnNumber(Object number) {
    return 'Column $number';
  }

  @override
  String get importConfirmMapping => 'Confirm Mapping';

  @override
  String get importCategoryMapping => 'Category Mapping';

  @override
  String get importNoDataParsed => 'No data parsed. Please return to previous page to check CSV content or separator.';

  @override
  String get importFieldDate => 'Date';

  @override
  String get importFieldType => 'Type';

  @override
  String get importFieldAmount => 'Amount';

  @override
  String get importFieldCategory => 'Category';

  @override
  String get importFieldNote => 'Note';

  @override
  String get importPreview => 'Data Preview';

  @override
  String importPreviewLimit(Object shown, Object total) {
    return 'Showing first $shown of $total records';
  }

  @override
  String get importCategoryNotSelected => 'Category not selected';

  @override
  String get importCategoryMappingDescription => 'Please select corresponding local categories for each category name:';

  @override
  String get importKeepOriginalName => 'Keep original name';

  @override
  String importProgress(Object fail, Object ok) {
    return 'Importing, success: $ok, failed: $fail';
  }

  @override
  String get importCancelImport => 'Cancel Import';

  @override
  String get importCompleteTitle => 'Import Complete';

  @override
  String importCompletedCount(Object count) {
    return 'Successfully imported $count records';
  }

  @override
  String get importFailed => 'Import Failed';

  @override
  String importFailedMessage(Object error) {
    return 'Import failed: $error';
  }

  @override
  String get importSelectCategoryFirst => 'Please select category mapping first';

  @override
  String get importNextStep => 'Next Step';

  @override
  String get importPreviousStep => 'Previous Step';

  @override
  String get importStartImport => 'Start Import';

  @override
  String get importAutoDetect => 'Auto Detect';

  @override
  String get importInProgress => 'Import in Progress';

  @override
  String importProgressDetail(Object done, Object fail, Object ok, Object total) {
    return 'Imported $done / $total records, success $ok, failed $fail';
  }

  @override
  String get importBackgroundImport => 'Background Import';

  @override
  String get importCancelled => 'Import Cancelled';

  @override
  String importCompleted(Object cancelled, Object fail, Object ok) {
    return 'Import Completed$cancelled, success $ok, failed $fail';
  }

  @override
  String importFileOpenError(String error) {
    return 'Unable to open file picker: $error';
  }

  @override
  String get mineTitle => 'Mine';

  @override
  String get mineSettings => 'Settings';

  @override
  String get mineTheme => 'Theme Settings';

  @override
  String get mineFont => 'Font Settings';

  @override
  String get mineReminder => 'Reminder Settings';

  @override
  String get mineData => 'Data Management';

  @override
  String get mineImport => 'Import Data';

  @override
  String get mineExport => 'Export Data';

  @override
  String get mineCloud => 'Cloud Service';

  @override
  String get mineAbout => 'About';

  @override
  String get mineVersion => 'Version';

  @override
  String get mineUpdate => 'Check for Updates';

  @override
  String get mineLanguageSettings => 'Language Settings';

  @override
  String get mineLanguageSettingsSubtitle => 'Switch application language';

  @override
  String get languageTitle => 'Language Settings';

  @override
  String get languageChinese => '中文';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSystemDefault => 'Follow System';

  @override
  String get deleteConfirmTitle => 'Delete Confirmation';

  @override
  String get deleteConfirmMessage => 'Are you sure you want to delete this record?';

  @override
  String get logCopied => 'Log copied';

  @override
  String get waitingRestore => 'Waiting for restore task to start...';

  @override
  String get restoreTitle => 'Cloud Restore';

  @override
  String get copyLog => 'Copy Log';

  @override
  String restoreProgress(Object current, Object total) {
    return 'Restoring ($current/$total)';
  }

  @override
  String get restorePreparing => 'Preparing...';

  @override
  String restoreLedgerProgress(String ledger, int done, int total) {
    return 'Ledger: $ledger  Records: $done/$total';
  }

  @override
  String get mineSlogan => 'Bee Accounting, Every Penny Counts';

  @override
  String get mineDaysCount => 'Days';

  @override
  String get mineTotalRecords => 'Records';

  @override
  String get mineCurrentBalance => 'Balance';

  @override
  String get mineCloudService => 'Cloud Service';

  @override
  String get mineCloudServiceLoading => 'Loading...';

  @override
  String mineCloudServiceError(Object error) {
    return 'Error: $error';
  }

  @override
  String get mineCloudServiceDefault => 'Default Cloud (Enabled)';

  @override
  String get mineCloudServiceOffline => 'Default Mode (Offline)';

  @override
  String get mineCloudServiceCustom => 'Custom Supabase';

  @override
  String get mineCloudServiceWebDAV => 'Custom Cloud Service (WebDAV)';

  @override
  String get mineFirstFullUpload => 'First Full Upload';

  @override
  String get mineFirstFullUploadSubtitle => 'Upload all local ledgers to current Supabase';

  @override
  String get mineFirstFullUploadComplete => 'Complete';

  @override
  String get mineFirstFullUploadMessage => 'Current ledger uploaded. Switch to other ledgers to upload them.';

  @override
  String get mineFirstFullUploadFailed => 'Failed';

  @override
  String get mineSyncTitle => 'Sync';

  @override
  String get mineSyncNotLoggedIn => 'Not logged in';

  @override
  String get mineSyncNotConfigured => 'Cloud not configured';

  @override
  String get mineSyncNoRemote => 'No cloud backup';

  @override
  String mineSyncInSync(Object count) {
    return 'Synced (local $count records)';
  }

  @override
  String mineSyncLocalNewer(Object count) {
    return 'Local newer (local $count records, upload recommended)';
  }

  @override
  String get mineSyncCloudNewer => 'Cloud newer (download recommended)';

  @override
  String get mineSyncDifferent => 'Local and cloud differ';

  @override
  String get mineSyncError => 'Failed to get status';

  @override
  String get mineSyncDetailTitle => 'Sync Status Details';

  @override
  String mineSyncLocalRecords(Object count) {
    return 'Local records: $count';
  }

  @override
  String mineSyncCloudRecords(Object count) {
    return 'Cloud records: $count';
  }

  @override
  String mineSyncCloudLatest(Object time) {
    return 'Cloud latest record time: $time';
  }

  @override
  String mineSyncLocalFingerprint(Object fingerprint) {
    return 'Local fingerprint: $fingerprint';
  }

  @override
  String mineSyncCloudFingerprint(Object fingerprint) {
    return 'Cloud fingerprint: $fingerprint';
  }

  @override
  String mineSyncMessage(Object message) {
    return 'Message: $message';
  }

  @override
  String get mineUploadTitle => 'Upload';

  @override
  String get mineUploadNeedLogin => 'Login required';

  @override
  String get mineUploadInProgress => 'Uploading...';

  @override
  String get mineUploadRefreshing => 'Refreshing...';

  @override
  String get mineUploadSynced => 'Synced';

  @override
  String get mineUploadSuccess => 'Uploaded';

  @override
  String get mineUploadSuccessMessage => 'Current ledger synced to cloud';

  @override
  String get mineDownloadTitle => 'Download';

  @override
  String get mineDownloadComplete => 'Complete';

  @override
  String mineDownloadResult(Object deleted, Object inserted, Object skipped) {
    return 'New imports: $inserted\nExisting skipped: $skipped\nDuplicates cleaned: $deleted';
  }

  @override
  String get mineLoginTitle => 'Login / Register';

  @override
  String get mineLoginSubtitle => 'Only needed for sync';

  @override
  String get mineLoggedInEmail => 'Logged in';

  @override
  String get mineLogoutSubtitle => 'Tap to logout';

  @override
  String get mineLogoutConfirmTitle => 'Logout';

  @override
  String get mineLogoutConfirmMessage => 'Are you sure you want to logout?\nYou won\'t be able to use cloud sync after logout.';

  @override
  String get mineLogoutButton => 'Logout';

  @override
  String get mineAutoSyncTitle => 'Auto sync ledger';

  @override
  String get mineAutoSyncSubtitle => 'Auto upload to cloud after recording';

  @override
  String get mineAutoSyncNeedLogin => 'Login required to enable';

  @override
  String get mineImportProgressTitle => 'Importing in background...';

  @override
  String mineImportProgressSubtitle(Object done, Object fail, Object ok, Object total) {
    return 'Progress: $done/$total, Success $ok, Failed $fail';
  }

  @override
  String get mineImportCompleteTitle => 'Import complete';

  @override
  String mineImportCompleteSubtitle(Object fail, Object ok) {
    return 'Success $ok, Failed $fail';
  }

  @override
  String get mineCategoryManagement => 'Category Management';

  @override
  String get mineCategoryManagementSubtitle => 'Edit custom categories';

  @override
  String get mineCategoryMigration => 'Category Migration';

  @override
  String get mineCategoryMigrationSubtitle => 'Migrate category data to other categories';

  @override
  String get mineRecurringTransactions => 'Recurring Bills';

  @override
  String get mineRecurringTransactionsSubtitle => 'Manage recurring bills';

  @override
  String get mineReminderSettings => 'Reminder Settings';

  @override
  String get mineReminderSettingsSubtitle => 'Set daily recording reminders';

  @override
  String get minePersonalize => 'Personalization';

  @override
  String get mineDisplayScale => 'Display Scale';

  @override
  String get mineDisplayScaleSubtitle => 'Adjust text and UI element sizes';

  @override
  String get mineAboutTitle => 'About';

  @override
  String mineAboutMessage(Object version) {
    return 'App: Bee Accounting\nVersion: $version\nSource: https://github.com/TNT-Likely/BeeCount\nLicense: See LICENSE in repository';
  }

  @override
  String get mineAboutOpenGitHub => 'Open GitHub';

  @override
  String get mineCheckUpdate => 'Check Update';

  @override
  String get mineCheckUpdateInProgress => 'Checking update...';

  @override
  String get mineCheckUpdateSubtitle => 'Checking for latest version';

  @override
  String get mineUpdateDownload => 'Download Update';

  @override
  String get mineFeedback => 'Feedback';

  @override
  String get mineFeedbackSubtitle => 'Report issues or suggestions';

  @override
  String get mineRefreshStats => 'Refresh Stats (Debug)';

  @override
  String get mineRefreshStatsSubtitle => 'Trigger global stats provider recalculation';

  @override
  String get mineRefreshSync => 'Refresh Sync Status (Debug)';

  @override
  String get mineRefreshSyncSubtitle => 'Trigger sync status provider refresh';

  @override
  String get categoryEditTitle => 'Edit Category';

  @override
  String get categoryNewTitle => 'New Category';

  @override
  String get categoryDetailTooltip => 'Category Details';

  @override
  String get categoryMigrationTooltip => 'Category Migration';

  @override
  String get categoryMigrationTitle => 'Category Migration';

  @override
  String get categoryMigrationDescription => 'Category Migration Instructions';

  @override
  String get categoryMigrationDescriptionContent => '• Migrate all transaction records from one category to another\n• After migration, all transaction data from the source category will be transferred to the target category\n• This operation cannot be undone, please choose carefully';

  @override
  String get categoryMigrationFromLabel => 'From Category';

  @override
  String get categoryMigrationFromHint => 'Select category to migrate from';

  @override
  String get categoryMigrationToLabel => 'To Category';

  @override
  String get categoryMigrationToHint => 'Select target category';

  @override
  String get categoryMigrationToHintFirst => 'Please select source category first';

  @override
  String get categoryMigrationStartButton => 'Start Migration';

  @override
  String categoryMigrationTransactionCount(int count) {
    return '$count records';
  }

  @override
  String get categoryMigrationCannotTitle => 'Cannot Migrate';

  @override
  String get categoryMigrationCannotMessage => 'Selected categories cannot be migrated, please check category status.';

  @override
  String get categoryExpenseType => 'Expense Category';

  @override
  String get categoryIncomeType => 'Income Category';

  @override
  String get categoryDefaultTitle => 'Default Category';

  @override
  String get categoryDefaultMessage => 'Default categories cannot be modified, but you can view details and migrate data';

  @override
  String get categoryNameDining => 'Dining';

  @override
  String get categoryNameTransport => 'Transport';

  @override
  String get categoryNameShopping => 'Shopping';

  @override
  String get categoryNameEntertainment => 'Entertainment';

  @override
  String get categoryNameHome => 'Home';

  @override
  String get categoryNameFamily => 'Family';

  @override
  String get categoryNameCommunication => 'Communication';

  @override
  String get categoryNameUtilities => 'Utilities';

  @override
  String get categoryNameHousing => 'Housing';

  @override
  String get categoryNameMedical => 'Medical';

  @override
  String get categoryNameEducation => 'Education';

  @override
  String get categoryNamePets => 'Pets';

  @override
  String get categoryNameSports => 'Sports';

  @override
  String get categoryNameDigital => 'Digital';

  @override
  String get categoryNameTravel => 'Travel';

  @override
  String get categoryNameAlcoholTobacco => 'Alcohol & Tobacco';

  @override
  String get categoryNameBabyCare => 'Baby Care';

  @override
  String get categoryNameBeauty => 'Beauty';

  @override
  String get categoryNameRepair => 'Repair';

  @override
  String get categoryNameSocial => 'Social';

  @override
  String get categoryNameLearning => 'Learning';

  @override
  String get categoryNameCar => 'Car';

  @override
  String get categoryNameTaxi => 'Taxi';

  @override
  String get categoryNameSubway => 'Subway';

  @override
  String get categoryNameDelivery => 'Delivery';

  @override
  String get categoryNameProperty => 'Property';

  @override
  String get categoryNameParking => 'Parking';

  @override
  String get categoryNameDonation => 'Donation';

  @override
  String get categoryNameGift => 'Gift';

  @override
  String get categoryNameTax => 'Tax';

  @override
  String get categoryNameBeverage => 'Beverage';

  @override
  String get categoryNameClothing => 'Clothing';

  @override
  String get categoryNameSnacks => 'Snacks';

  @override
  String get categoryNameRedPacket => 'Red Packet';

  @override
  String get categoryNameFruit => 'Fruit';

  @override
  String get categoryNameGame => 'Game';

  @override
  String get categoryNameBook => 'Book';

  @override
  String get categoryNameLover => 'Lover';

  @override
  String get categoryNameDecoration => 'Decoration';

  @override
  String get categoryNameDailyGoods => 'Daily Goods';

  @override
  String get categoryNameLottery => 'Lottery';

  @override
  String get categoryNameStock => 'Stock';

  @override
  String get categoryNameSocialSecurity => 'Social Security';

  @override
  String get categoryNameExpress => 'Express';

  @override
  String get categoryNameWork => 'Work';

  @override
  String get categoryNameSalary => 'Salary';

  @override
  String get categoryNameInvestment => 'Investment';

  @override
  String get categoryNameBonus => 'Bonus';

  @override
  String get categoryNameReimbursement => 'Reimbursement';

  @override
  String get categoryNamePartTime => 'Part-time';

  @override
  String get categoryNameInterest => 'Interest';

  @override
  String get categoryNameRefund => 'Refund';

  @override
  String get categoryNameSecondHand => 'Second-hand Sale';

  @override
  String get categoryNameSocialBenefit => 'Social Benefit';

  @override
  String get categoryNameTaxRefund => 'Tax Refund';

  @override
  String get categoryNameProvidentFund => 'Provident Fund';

  @override
  String get categoryNameLabel => 'Category Name';

  @override
  String get categoryNameHint => 'Enter category name';

  @override
  String get categoryNameHintDefault => 'Default category name cannot be modified';

  @override
  String get categoryNameRequired => 'Please enter category name';

  @override
  String get categoryNameTooLong => 'Category name cannot exceed 4 characters';

  @override
  String get categoryIconLabel => 'Category Icon';

  @override
  String get categoryIconDefaultMessage => 'Default category icon cannot be modified';

  @override
  String get categoryDangerousOperations => 'Dangerous Operations';

  @override
  String get categoryDeleteTitle => 'Delete Category';

  @override
  String get categoryDeleteSubtitle => 'Cannot be recovered after deletion';

  @override
  String get categoryDefaultCannotSave => 'Default category cannot be saved';

  @override
  String get categorySaveError => 'Save failed';

  @override
  String categoryUpdated(Object name) {
    return 'Category \"$name\" updated';
  }

  @override
  String categoryCreated(Object name) {
    return 'Category \"$name\" created';
  }

  @override
  String get categoryCannotDelete => 'Cannot delete';

  @override
  String categoryCannotDeleteMessage(Object count) {
    return 'This category has $count transaction records. Please handle them first.';
  }

  @override
  String get categoryDeleteConfirmTitle => 'Delete Category';

  @override
  String categoryDeleteConfirmMessage(Object name) {
    return 'Are you sure you want to delete category \"$name\"? This action cannot be undone.';
  }

  @override
  String get categoryDeleteError => 'Delete failed';

  @override
  String categoryDeleted(Object name) {
    return 'Category \"$name\" deleted';
  }

  @override
  String get personalizeTitle => 'Personalize';

  @override
  String get personalizeCustomColor => 'Choose custom color';

  @override
  String get personalizeCustomTitle => 'Custom';

  @override
  String personalizeHue(Object value) {
    return 'Hue ($value°)';
  }

  @override
  String personalizeSaturation(Object value) {
    return 'Saturation ($value%)';
  }

  @override
  String personalizeBrightness(Object value) {
    return 'Brightness ($value%)';
  }

  @override
  String get personalizeSelectColor => 'Select this color';

  @override
  String get fontSettingsTitle => 'Display Scale';

  @override
  String fontSettingsCurrentScale(Object scale) {
    return 'Current scale: x$scale';
  }

  @override
  String get fontSettingsPreview => 'Live Preview';

  @override
  String get fontSettingsPreviewText => 'Spent 23.50 on lunch today, record it;\nRecorded for 45 days this month, 320 entries;\nPersistence is victory!';

  @override
  String fontSettingsCurrentLevel(Object level, Object scale) {
    return 'Current level: $level (scale x$scale)';
  }

  @override
  String get fontSettingsQuickLevel => 'Quick Levels';

  @override
  String get fontSettingsCustomAdjust => 'Custom Adjustment';

  @override
  String get fontSettingsDescription => 'Note: This setting ensures consistent display at 1.0x across all devices, with device differences auto-compensated; adjust values for personalized scaling on this consistent base.';

  @override
  String get fontSettingsExtraSmall => 'Extra Small';

  @override
  String get fontSettingsVerySmall => 'Very Small';

  @override
  String get fontSettingsSmall => 'Small';

  @override
  String get fontSettingsStandard => 'Standard';

  @override
  String get fontSettingsLarge => 'Large';

  @override
  String get fontSettingsBig => 'Big';

  @override
  String get fontSettingsVeryBig => 'Very Big';

  @override
  String get fontSettingsExtraBig => 'Extra Big';

  @override
  String get fontSettingsMoreStyles => 'More Styles';

  @override
  String get fontSettingsPageTitle => 'Page Title';

  @override
  String get fontSettingsBlockTitle => 'Block Title';

  @override
  String get fontSettingsBodyExample => 'Body Text';

  @override
  String get fontSettingsLabelExample => 'Label Text';

  @override
  String get fontSettingsStrongNumber => 'Strong Number';

  @override
  String get fontSettingsListTitle => 'List Item Title';

  @override
  String get fontSettingsListSubtitle => 'Helper Text';

  @override
  String get fontSettingsScreenInfo => 'Screen Adaptation Info';

  @override
  String get fontSettingsScreenDensity => 'Screen Density';

  @override
  String get fontSettingsScreenWidth => 'Screen Width';

  @override
  String get fontSettingsDeviceScale => 'Device Scale';

  @override
  String get fontSettingsUserScale => 'User Scale';

  @override
  String get fontSettingsFinalScale => 'Final Scale';

  @override
  String get fontSettingsBaseDevice => 'Base Device';

  @override
  String get fontSettingsRecommendedScale => 'Recommended Scale';

  @override
  String get fontSettingsYes => 'Yes';

  @override
  String get fontSettingsNo => 'No';

  @override
  String get fontSettingsScaleExample => 'This box and spacing auto-scale based on device';

  @override
  String get fontSettingsPreciseAdjust => 'Precise Adjustment';

  @override
  String get fontSettingsResetTo1x => 'Reset to 1.0x';

  @override
  String get fontSettingsAdaptBase => 'Adapt to Base';

  @override
  String get reminderTitle => 'Recording Reminder';

  @override
  String get reminderSubtitle => 'Set daily recording reminder time';

  @override
  String get reminderDailyTitle => 'Daily Recording Reminder';

  @override
  String get reminderDailySubtitle => 'When enabled, will remind you to record at specified time';

  @override
  String get reminderTimeTitle => 'Reminder Time';

  @override
  String get reminderTestNotification => 'Send Test Notification';

  @override
  String get reminderTestSent => 'Test notification sent';

  @override
  String get reminderTestTitle => 'Test Notification';

  @override
  String get reminderTestBody => 'This is a test notification, tap to see the effect';

  @override
  String get reminderTestDelayBody => 'This is a 15-second delayed test notification';

  @override
  String get reminderQuickTest => 'Quick Test (15s later)';

  @override
  String get reminderQuickTestMessage => 'Quick test set for 15 seconds later, keep app in background';

  @override
  String get reminderFlutterTest => '🔧 Test Flutter Notification Click (Dev)';

  @override
  String get reminderFlutterTestMessage => 'Flutter test notification sent, tap to see if app opens';

  @override
  String get reminderAlarmTest => '🔧 Test AlarmManager Notification Click (Dev)';

  @override
  String get reminderAlarmTestMessage => 'AlarmManager test notification set (1s later), tap to see if app opens';

  @override
  String get reminderDirectTest => '🔧 Direct Test NotificationReceiver (Dev)';

  @override
  String get reminderDirectTestMessage => 'Directly called NotificationReceiver to create notification, check if tap works';

  @override
  String get reminderCheckStatus => '🔧 Check Notification Status (Dev)';

  @override
  String get reminderNotificationStatus => 'Notification Status';

  @override
  String reminderPendingCount(Object count) {
    return 'Pending notifications: $count';
  }

  @override
  String get reminderNoPending => 'No pending notifications';

  @override
  String get reminderCheckBattery => 'Check Battery Optimization Status';

  @override
  String get reminderBatteryStatus => 'Battery Optimization Status';

  @override
  String reminderManufacturer(Object value) {
    return 'Manufacturer: $value';
  }

  @override
  String reminderModel(Object value) {
    return 'Model: $value';
  }

  @override
  String reminderAndroidVersion(Object value) {
    return 'Android Version: $value';
  }

  @override
  String get reminderBatteryIgnored => 'Battery optimization: Ignored ✅';

  @override
  String get reminderBatteryNotIgnored => 'Battery optimization: Not ignored ⚠️';

  @override
  String get reminderBatteryAdvice => 'Recommend disabling battery optimization for proper notifications';

  @override
  String get reminderGoToSettings => 'Go to Settings';

  @override
  String get reminderCheckChannel => 'Check Notification Channel Settings';

  @override
  String get reminderChannelStatus => 'Notification Channel Status';

  @override
  String get reminderChannelEnabled => 'Channel enabled: Yes ✅';

  @override
  String get reminderChannelDisabled => 'Channel enabled: No ❌';

  @override
  String reminderChannelImportance(Object value) {
    return 'Importance: $value';
  }

  @override
  String get reminderChannelSoundOn => 'Sound: On 🔊';

  @override
  String get reminderChannelSoundOff => 'Sound: Off 🔇';

  @override
  String get reminderChannelVibrationOn => 'Vibration: On 📳';

  @override
  String get reminderChannelVibrationOff => 'Vibration: Off';

  @override
  String get reminderChannelDndBypass => 'Do Not Disturb: Can bypass';

  @override
  String get reminderChannelDndNoBypass => 'Do Not Disturb: Cannot bypass';

  @override
  String get reminderChannelAdvice => '⚠️ Recommended settings:';

  @override
  String get reminderChannelAdviceImportance => '• Importance: Urgent or High';

  @override
  String get reminderChannelAdviceSound => '• Enable sound and vibration';

  @override
  String get reminderChannelAdviceBanner => '• Allow banner notifications';

  @override
  String get reminderChannelAdviceXiaomi => '• Xiaomi phones need individual channel setup';

  @override
  String get reminderChannelGood => '✅ Notification channel well configured';

  @override
  String get reminderOpenAppSettings => 'Open App Settings';

  @override
  String get reminderAppSettingsMessage => 'Please allow notifications and disable battery optimization in settings';

  @override
  String get reminderIOSTest => '🍎 iOS Notification Debug Test';

  @override
  String get reminderIOSTestTitle => 'iOS Notification Test';

  @override
  String get reminderIOSTestMessage => 'Test notification sent.\n\n🍎 iOS Simulator limitations:\n• Notifications may not show in notification center\n• Banner alerts may not work\n• But Xcode console will show logs\n\n💡 Debug methods:\n• Check Xcode console output\n• Check Flutter log info\n• Use real device for full experience';

  @override
  String get reminderDescription => 'Tip: When recording reminder is enabled, the system will send notifications at the specified time daily to remind you to record income and expenses.';

  @override
  String get reminderIOSInstructions => '🍎 iOS notification settings:\n• Settings > Notifications > Bee Accounting\n• Enable \"Allow Notifications\"\n• Set notification style: Banner or Alert\n• Enable sound and vibration\n\n⚠️ iOS Simulator limitations:\n• Simulator notification features are limited\n• Recommend using real device\n• Check Xcode console for notification status\n\nIf testing in simulator, observe:\n• Xcode console log output\n• Flutter Debug Console info\n• In-app popups confirming notification sent';

  @override
  String get reminderAndroidInstructions => 'If notifications don\'t work properly, check:\n• App is allowed to send notifications\n• Disable battery optimization/power saving for app\n• Allow app to run in background and auto-start\n• Android 12+ needs exact alarm permission\n\n📱 Xiaomi phone special settings:\n• Settings > App Management > Bee Accounting > Notification Management\n• Tap \"Recording Reminder\" channel\n• Set importance to \"Urgent\" or \"High\"\n• Enable \"Banner notifications\", \"Sound\", \"Vibration\"\n• Security Center > App Management > Permissions > Auto-start\n\n🔒 Lock background methods:\n• Find Bee Accounting in recent tasks\n• Pull down app card to show lock icon\n• Tap lock icon to prevent cleanup';

  @override
  String get categoryDetailLoadFailed => 'Load failed';

  @override
  String get categoryDetailSummaryTitle => 'Category Summary';

  @override
  String get categoryDetailTotalCount => 'Total Count';

  @override
  String get categoryDetailTotalAmount => 'Total Amount';

  @override
  String get categoryDetailAverageAmount => 'Average Amount';

  @override
  String get categoryDetailSortTitle => 'Sort';

  @override
  String get categoryDetailSortTimeDesc => 'Time ↓';

  @override
  String get categoryDetailSortTimeAsc => 'Time ↑';

  @override
  String get categoryDetailSortAmountDesc => 'Amount ↓';

  @override
  String get categoryDetailSortAmountAsc => 'Amount ↑';

  @override
  String get categoryDetailNoTransactions => 'No transactions';

  @override
  String get categoryDetailNoTransactionsSubtext => 'No transactions in this category yet';

  @override
  String get categoryDetailDeleteFailed => 'Delete failed';

  @override
  String get categoryMigrationConfirmTitle => 'Confirm Migration';

  @override
  String categoryMigrationConfirmMessage(Object count, Object fromName, Object toName) {
    return 'Migrate $count transactions from \"$fromName\" to \"$toName\"?\n\nThis operation cannot be undone!';
  }

  @override
  String get categoryMigrationConfirmOk => 'Confirm Migration';

  @override
  String get categoryMigrationCompleteTitle => 'Migration Complete';

  @override
  String categoryMigrationCompleteMessage(Object count, Object fromName, Object toName) {
    return 'Successfully migrated $count transactions from \"$fromName\" to \"$toName\".';
  }

  @override
  String get categoryMigrationFailedTitle => 'Migration Failed';

  @override
  String categoryMigrationFailedMessage(Object error) {
    return 'Migration error: $error';
  }

  @override
  String categoryMigrationTransactionLabel(int count) {
    return '$count records';
  }

  @override
  String get categoryPickerExpenseTab => 'Expense';

  @override
  String get categoryPickerIncomeTab => 'Income';

  @override
  String get categoryPickerCancel => 'Cancel';

  @override
  String get categoryPickerEmpty => 'No categories';

  @override
  String get cloudBackupFound => 'Cloud Backup Found';

  @override
  String get cloudBackupRestoreMessage => 'Cloud and local ledgers are inconsistent. Restore from cloud?\n(Will enter restore progress page)';

  @override
  String get cloudBackupRestoreFailed => 'Restore Failed';

  @override
  String get mineCloudBackupRestoreTitle => 'Cloud Backup Found';

  @override
  String get mineAutoSyncRemoteDesc => 'Auto upload to cloud after recording';

  @override
  String get mineAutoSyncLoginRequired => 'Login required to enable';

  @override
  String get mineImportCompleteAllSuccess => 'All Success';

  @override
  String get mineImportCompleteTitleShort => 'Import Complete';

  @override
  String get mineAboutAppName => 'App: Bee Accounting';

  @override
  String mineAboutVersion(Object version) {
    return 'Version: $version';
  }

  @override
  String get mineAboutRepo => 'Source: https://github.com/TNT-Likely/BeeCount';

  @override
  String get mineAboutLicense => 'License: See LICENSE in repository';

  @override
  String get mineCheckUpdateDetecting => 'Checking update...';

  @override
  String get mineCheckUpdateSubtitleDetecting => 'Checking for latest version';

  @override
  String get mineUpdateDownloadTitle => 'Download Update';

  @override
  String get mineDebugRefreshStats => 'Refresh Stats (Debug)';

  @override
  String get mineDebugRefreshStatsSubtitle => 'Trigger global stats provider recalculation';

  @override
  String get mineDebugRefreshSync => 'Refresh Sync Status (Debug)';

  @override
  String get mineDebugRefreshSyncSubtitle => 'Trigger sync status provider refresh';

  @override
  String get cloudCurrentService => 'Current Cloud Service';

  @override
  String get cloudConnected => 'Connected';

  @override
  String get cloudOfflineMode => 'Offline Mode';

  @override
  String get cloudAvailableServices => 'Available Cloud Services';

  @override
  String get cloudReadCustomConfigFailed => 'Failed to read custom configuration';

  @override
  String get cloudFirstUploadNotComplete => 'First full upload not completed';

  @override
  String get cloudFirstUploadInstruction => 'Login and manually execute \"Upload\" in \"Mine/Sync\" to complete initialization';

  @override
  String get cloudNotConfigured => 'Not configured';

  @override
  String get cloudNotTested => 'Not tested';

  @override
  String get cloudConnectionNormal => 'Connection normal';

  @override
  String get cloudConnectionFailed => 'Connection failed';

  @override
  String get cloudAddCustomService => 'Add custom cloud service';

  @override
  String get cloudCustomServiceName => 'Custom Cloud Service';

  @override
  String get cloudDefaultServiceName => 'Default Cloud Service';

  @override
  String get cloudUseYourSupabase => 'Use your own Supabase';

  @override
  String get cloudTest => 'Test';

  @override
  String get cloudSwitchService => 'Switch Cloud Service';

  @override
  String get cloudSwitchToBuiltinConfirm => 'Are you sure you want to switch to the default cloud service? This will log out the current session.';

  @override
  String get cloudSwitchToCustomConfirm => 'Are you sure you want to switch to the custom cloud service? This will log out the current session.';

  @override
  String get cloudSwitched => 'Switched';

  @override
  String get cloudSwitchedToBuiltin => 'Switched to default cloud service and logged out';

  @override
  String get cloudSwitchFailed => 'Switch failed';

  @override
  String get cloudActivateFailed => 'Activation failed';

  @override
  String get cloudActivateFailedMessage => 'Saved configuration is invalid';

  @override
  String get cloudActivated => 'Activated';

  @override
  String get cloudActivatedMessage => 'Switched to custom cloud service and logged out, please log in again';

  @override
  String get cloudEditCustomService => 'Edit custom cloud service';

  @override
  String get cloudAddCustomServiceTitle => 'Add custom cloud service';

  @override
  String get cloudSupabaseUrlLabel => 'Supabase URL';

  @override
  String get cloudSupabaseUrlHint => 'https://xxx.supabase.co';

  @override
  String get cloudAnonKeyLabel => 'Anon Key';

  @override
  String get cloudAnonKeyHint => 'Note: Do not fill in service_role Key; Anon Key is publicly available.';

  @override
  String get cloudInvalidInput => 'Invalid input';

  @override
  String get cloudValidationEmptyFields => 'URL and Key cannot be empty';

  @override
  String get cloudValidationHttpsRequired => 'URL must start with https://';

  @override
  String get cloudValidationKeyTooShort => 'Key length is too short, may be invalid';

  @override
  String get cloudValidationServiceRoleKey => 'service_role Key is not allowed';

  @override
  String get cloudValidationHttpRequired => 'URL must start with http:// or https://';

  @override
  String get cloudSelectServiceType => 'Select Cloud Service Type';

  @override
  String get cloudWebdavUrlLabel => 'WebDAV Server URL';

  @override
  String get cloudWebdavUrlHint => 'https://dav.jianguoyun.com/dav/';

  @override
  String get cloudWebdavUsernameLabel => 'Username';

  @override
  String get cloudWebdavPasswordLabel => 'Password';

  @override
  String get cloudWebdavPathLabel => 'Remote Path';

  @override
  String get cloudWebdavPathHint => '/BeeCount';

  @override
  String get cloudWebdavHint => 'Supports Nutstore, Nextcloud, Synology, etc.';

  @override
  String get cloudConfigUpdated => 'Configuration updated';

  @override
  String get cloudConfigSaved => 'Configuration saved';

  @override
  String get cloudTestComplete => 'Test complete';

  @override
  String get cloudTestSuccess => 'Connection test successful!';

  @override
  String get cloudTestFailed => 'Connection test failed, please check if the configuration is correct.';

  @override
  String get cloudTestError => 'Test failed';

  @override
  String get cloudClearConfig => 'Clear configuration';

  @override
  String get cloudClearConfigConfirm => 'Are you sure you want to clear the custom cloud service configuration? (Development environment only)';

  @override
  String get cloudConfigCleared => 'Custom cloud service configuration cleared';

  @override
  String get cloudClearFailed => 'Clear failed';

  @override
  String get cloudServiceDescription => 'Built-in cloud service (free but may be unstable, recommend using your own or regular backup)';

  @override
  String get cloudServiceDescriptionNotConfigured => 'Current build does not have built-in cloud service configuration';

  @override
  String cloudServiceDescriptionCustom(String url) {
    return 'Server: $url';
  }

  @override
  String get authLogin => 'Login';

  @override
  String get authSignup => 'Sign Up';

  @override
  String get authRegister => 'Register';

  @override
  String get authEmail => 'Email';

  @override
  String get authPassword => 'Password';

  @override
  String get authPasswordRequirement => 'Password (at least 6 characters, include letters and numbers)';

  @override
  String get authConfirmPassword => 'Confirm Password';

  @override
  String get authInvalidEmail => 'Please enter a valid email address';

  @override
  String get authPasswordRequirementShort => 'Password must contain letters and numbers, at least 6 characters';

  @override
  String get authPasswordMismatch => 'Passwords do not match';

  @override
  String get authResendVerification => 'Resend verification email';

  @override
  String get authSignupSuccess => 'Registration successful';

  @override
  String get authVerificationEmailSent => 'Verification email sent, please go to your email to complete verification before logging in.';

  @override
  String get authBackToMinePage => 'Back to My Page';

  @override
  String get authVerificationEmailResent => 'Verification email resent.';

  @override
  String get authResendAction => 'resend verification';

  @override
  String get authErrorInvalidCredentials => 'Email or password is incorrect.';

  @override
  String get authErrorEmailNotConfirmed => 'Email not verified, please complete verification in your email before logging in.';

  @override
  String get authErrorRateLimit => 'Too many attempts, please try again later.';

  @override
  String get authErrorNetworkIssue => 'Network error, please check your connection and try again.';

  @override
  String get authErrorLoginFailed => 'Login failed, please try again later.';

  @override
  String get authErrorEmailInvalid => 'Email address is invalid, please check for spelling errors.';

  @override
  String get authErrorEmailExists => 'This email is already registered, please login directly or reset password.';

  @override
  String get authErrorWeakPassword => 'Password is too simple, please include letters and numbers, at least 6 characters.';

  @override
  String get authErrorSignupFailed => 'Registration failed, please try again later.';

  @override
  String authErrorUserNotFound(String action) {
    return 'Email not registered, cannot $action.';
  }

  @override
  String authErrorEmailNotVerified(String action) {
    return 'Email not verified, cannot $action.';
  }

  @override
  String authErrorActionFailed(String action) {
    return '$action failed, please try again later.';
  }

  @override
  String get importSelectCsvFile => 'Please select a file to import (CSV/TSV/XLSX supported)';

  @override
  String get exportTitle => 'Export';

  @override
  String get exportDescription => 'Click the button below to select save location and export current ledger to CSV file.';

  @override
  String get exportButtonIOS => 'Export and Share (iOS)';

  @override
  String get exportButtonAndroid => 'Select Folder and Export';

  @override
  String exportSavedTo(String path) {
    return 'Saved to: $path';
  }

  @override
  String get exportSelectFolder => 'Select Export Folder';

  @override
  String get exportCsvHeaderType => 'Type';

  @override
  String get exportCsvHeaderCategory => 'Category';

  @override
  String get exportCsvHeaderAmount => 'Amount';

  @override
  String get exportCsvHeaderNote => 'Note';

  @override
  String get exportCsvHeaderTime => 'Time';

  @override
  String get exportShareText => 'BeeCount Export File';

  @override
  String get exportSuccessTitle => 'Export Successful';

  @override
  String exportSuccessMessageIOS(String path) {
    return 'Saved and available in share history:\n$path';
  }

  @override
  String exportSuccessMessageAndroid(String path) {
    return 'Saved to:\n$path';
  }

  @override
  String get exportFailedTitle => 'Export Failed';

  @override
  String get exportTypeIncome => 'Income';

  @override
  String get exportTypeExpense => 'Expense';

  @override
  String get exportTypeTransfer => 'Transfer';

  @override
  String get personalizeThemeHoney => 'Bee Yellow';

  @override
  String get personalizeThemeOrange => 'Flame Orange';

  @override
  String get personalizeThemeGreen => 'Emerald Green';

  @override
  String get personalizeThemePurple => 'Purple Lotus';

  @override
  String get personalizeThemePink => 'Cherry Pink';

  @override
  String get personalizeThemeBlue => 'Sky Blue';

  @override
  String get personalizeThemeMint => 'Forest Moon';

  @override
  String get personalizeThemeSand => 'Sunset Dune';

  @override
  String get personalizeThemeLavender => 'Snow & Pine';

  @override
  String get personalizeThemeSky => 'Misty Wonderland';

  @override
  String get personalizeThemeWarmOrange => 'Warm Orange';

  @override
  String get personalizeThemeMintGreen => 'Mint Green';

  @override
  String get personalizeThemeRoseGold => 'Rose Gold';

  @override
  String get personalizeThemeDeepBlue => 'Deep Blue';

  @override
  String get personalizeThemeMapleRed => 'Maple Red';

  @override
  String get personalizeThemeEmerald => 'Emerald';

  @override
  String get personalizeThemeLavenderPurple => 'Lavender';

  @override
  String get personalizeThemeAmber => 'Amber';

  @override
  String get personalizeThemeRouge => 'Rouge Red';

  @override
  String get personalizeThemeIndigo => 'Indigo Blue';

  @override
  String get personalizeThemeOlive => 'Olive Green';

  @override
  String get personalizeThemeCoral => 'Coral Pink';

  @override
  String get personalizeThemeDarkGreen => 'Dark Green';

  @override
  String get personalizeThemeViolet => 'Violet';

  @override
  String get personalizeThemeSunset => 'Sunset Orange';

  @override
  String get personalizeThemePeacock => 'Peacock Blue';

  @override
  String get personalizeThemeLime => 'Lime Green';

  @override
  String get analyticsMonthlyAvg => 'Monthly Avg';

  @override
  String get analyticsDailyAvg => 'Daily Avg';

  @override
  String get analyticsOverallAvg => 'Overall Avg';

  @override
  String get analyticsTotalIncome => 'Total Income: ';

  @override
  String get analyticsTotalExpense => 'Total Expense: ';

  @override
  String get analyticsBalance => 'Balance: ';

  @override
  String analyticsAvgIncome(String avgLabel) {
    return '$avgLabel Income: ';
  }

  @override
  String analyticsAvgExpense(String avgLabel) {
    return '$avgLabel Expense: ';
  }

  @override
  String get analyticsExpense => 'Expense';

  @override
  String get analyticsIncome => 'Income';

  @override
  String analyticsTotal(String type) {
    return 'Total $type: ';
  }

  @override
  String analyticsAverage(String avgLabel) {
    return '$avgLabel: ';
  }

  @override
  String get updateCheckTitle => 'Check Update';

  @override
  String get updateNewVersionFound => 'New Version Found';

  @override
  String updateNewVersionTitle(String version) {
    return 'New Version $version Found';
  }

  @override
  String get updateNoApkFound => 'APK download link not found';

  @override
  String get updateAlreadyLatest => 'Already latest version';

  @override
  String get updateCheckFailed => 'Update check failed';

  @override
  String get updatePermissionDenied => 'Permission denied';

  @override
  String get updateUserCancelled => 'User cancelled';

  @override
  String get updateDownloadTitle => 'Download Update';

  @override
  String updateDownloading(String percent) {
    return 'Downloading: $percent%';
  }

  @override
  String get updateDownloadBackgroundHint => 'You can switch the app to background, download will continue';

  @override
  String get updateCancelButton => 'Cancel';

  @override
  String get updateBackgroundDownload => 'Background Download';

  @override
  String get updateLaterButton => 'Later';

  @override
  String get updateDownloadButton => 'Download';

  @override
  String get updateFoundCachedTitle => 'Found Downloaded Version';

  @override
  String updateFoundCachedMessage(String path) {
    return 'Found a previously downloaded installer, install directly?\\n\\nClick \"OK\" to install immediately, click \"Cancel\" to close this dialog.\\n\\nFile path: $path';
  }

  @override
  String get updateInstallingCachedApk => 'Installing cached APK';

  @override
  String get updateDownloadComplete => 'Download Complete';

  @override
  String get updateInstallStarted => 'Download complete, installer started';

  @override
  String get updateInstallFailed => 'Installation failed';

  @override
  String get updateDownloadCompleteManual => 'Download complete, can install manually';

  @override
  String get updateDownloadCompleteException => 'Download complete, please install manually (dialog exception)';

  @override
  String get updateDownloadCompleteManualContext => 'Download complete, please install manually';

  @override
  String get updateDownloadFailed => 'Download failed';

  @override
  String get updateInstallTitle => 'Download Complete';

  @override
  String get updateInstallMessage => 'APK file download complete, install immediately?\\n\\nNote: The app will temporarily go to background during installation, this is normal.';

  @override
  String get updateInstallNow => 'Install Now';

  @override
  String get updateInstallLater => 'Install Later';

  @override
  String get updateNotificationTitle => 'BeeCount Update Download';

  @override
  String get updateNotificationBody => 'Downloading new version...';

  @override
  String get updateNotificationComplete => 'Download complete, tap to install';

  @override
  String get updateNotificationPermissionTitle => 'Notification Permission Denied';

  @override
  String get updateNotificationPermissionMessage => 'Cannot get notification permission, download progress will not show in notification bar, but download function works normally.';

  @override
  String get updateNotificationGuideTitle => 'If you need to enable notifications, follow these steps:';

  @override
  String get updateNotificationStep1 => 'Open system settings';

  @override
  String get updateNotificationStep2 => 'Find \"App Management\" or \"App Settings\"';

  @override
  String get updateNotificationStep3 => 'Find \"BeeCount\" app';

  @override
  String get updateNotificationStep4 => 'Click \"Permission Management\" or \"Notification Management\"';

  @override
  String get updateNotificationStep5 => 'Enable \"Notification Permission\"';

  @override
  String get updateNotificationMiuiHint => 'MIUI users: Xiaomi system has strict notification permission control, may need additional settings in Security Center';

  @override
  String get updateNotificationGotIt => 'Got it';

  @override
  String get updateCheckFailedTitle => 'Update Check Failed';

  @override
  String get updateDownloadFailedTitle => 'Download Failed';

  @override
  String get updateGoToGitHub => 'Go to GitHub';

  @override
  String get updateCannotOpenLink => 'Cannot open link';

  @override
  String get updateManualVisit => 'Please manually visit in browser:\\nhttps://github.com/TNT-Likely/BeeCount/releases';

  @override
  String get updateNoLocalApkTitle => 'No Update Package Found';

  @override
  String get updateNoLocalApkMessage => 'No downloaded update package file found.\\n\\nPlease first download new version through \"Check Update\".';

  @override
  String get updateInstallPackageTitle => 'Install Update Package';

  @override
  String get updateMultiplePackagesTitle => 'Found Multiple Update Packages';

  @override
  String updateMultiplePackagesMessage(int count, String path) {
    return 'Found $count update package files.\\n\\nRecommend using the latest downloaded version, or manually install in file manager.\\n\\nFile location: $path';
  }

  @override
  String get updateSearchFailedTitle => 'Search Failed';

  @override
  String updateSearchFailedMessage(String error) {
    return 'Error occurred while searching for local update packages: $error';
  }

  @override
  String get updateFoundCachedPackageTitle => 'Found Downloaded Update Package';

  @override
  String updateFoundCachedPackageMessage(String fileName, String fileSize) {
    return 'Detected previously downloaded update package:\\n\\nFile name: $fileName\\nSize: ${fileSize}MB\\n\\nInstall immediately?';
  }

  @override
  String get updateIgnoreButton => 'Ignore';

  @override
  String get updateInstallFailedTitle => 'Installation Failed';

  @override
  String get updateInstallFailedMessage => 'Cannot start APK installer, please check file permissions.';

  @override
  String get updateErrorTitle => 'Error';

  @override
  String updateReadCacheFailedMessage(String error) {
    return 'Failed to read cached update package: $error';
  }

  @override
  String get updateCheckingPermissions => 'Checking permissions...';

  @override
  String get updateCheckingCache => 'Checking local cache...';

  @override
  String get updatePreparingDownload => 'Preparing download...';

  @override
  String get updateUserCancelledDownload => 'User cancelled download';

  @override
  String get updateStartingInstaller => 'Starting installer...';

  @override
  String get updateInstallerStarted => 'Installer started';

  @override
  String get updateInstallationFailed => 'Installation failed';

  @override
  String get updateDownloadCompleted => 'Download completed';

  @override
  String get updateDownloadCompletedManual => 'Download completed, can install manually';

  @override
  String get updateDownloadCompletedDialog => 'Download completed, please install manually (dialog exception)';

  @override
  String get updateDownloadCompletedContext => 'Download completed, please install manually';

  @override
  String get updateDownloadFailedGeneric => 'Download failed';

  @override
  String get updateCheckingUpdate => 'Checking for updates...';

  @override
  String get updateCurrentLatestVersion => 'Already latest version';

  @override
  String get updateCheckFailedGeneric => 'Update check failed';

  @override
  String updateDownloadProgress(String percent) {
    return 'Downloading: $percent%';
  }

  @override
  String get updateNoApkFoundError => 'APK download link not found';

  @override
  String updateCheckingUpdateError(String error) {
    return 'Update check failed: $error';
  }

  @override
  String get updateNotificationChannelName => 'Update Download';

  @override
  String get updateNotificationDownloadingIndeterminate => 'Downloading new version...';

  @override
  String updateNotificationDownloadingProgress(String progress) {
    return 'Download progress: $progress%';
  }

  @override
  String get updateNotificationDownloadCompleteTitle => 'Download Complete';

  @override
  String get updateNotificationDownloadCompleteMessage => 'New version downloaded, tap to install';

  @override
  String get updateUserCancelledDownloadDialog => 'User cancelled download';

  @override
  String get updateCannotOpenLinkError => 'Cannot open link';

  @override
  String get updateNoLocalApkFoundMessage => 'No downloaded update package file found.\\n\\nPlease first download new version through \"Check Update\".';

  @override
  String updateInstallPackageFoundMessage(String fileName, String fileSize, String time) {
    return 'Found update package:\\n\\nFile name: $fileName\\nSize: ${fileSize}MB\\nDownload time: $time\\n\\nInstall immediately?';
  }

  @override
  String updateMultiplePackagesFoundMessage(int count, String path) {
    return 'Found $count update package files.\\n\\nRecommend using the latest downloaded version, or manually install in file manager.\\n\\nFile location: $path';
  }

  @override
  String updateSearchLocalApkError(String error) {
    return 'Error occurred while searching for local update packages: $error';
  }

  @override
  String updateCachedPackageFoundMessage(String fileName, String fileSize) {
    return 'Detected previously downloaded update package:\\n\\nFile name: $fileName\\nSize: ${fileSize}MB\\n\\nInstall immediately?';
  }

  @override
  String updateReadCachedPackageError(String error) {
    return 'Failed to read cached update package: $error';
  }

  @override
  String get reminderQuickTestSent => 'Quick test set for 15 seconds later, please keep app in background';

  @override
  String get reminderFlutterTestSent => 'Flutter test notification sent, click to see if it opens the app';

  @override
  String get reminderAlarmTestSent => 'AlarmManager test notification set (1 second later), click to see if it opens the app';

  @override
  String get updateOk => 'OK';

  @override
  String get updateCannotOpenLinkTitle => 'Cannot Open Link';

  @override
  String get updateCachedVersionTitle => 'Found Downloaded Version';

  @override
  String get updateCachedVersionMessage => 'Found previously downloaded installation package... Click \\\"OK\\\" to install immediately, click \\\"Cancel\\\" to close...';

  @override
  String get updateConfirmDownload => 'Download and Install Now';

  @override
  String get updateDownloadCompleteTitle => 'Download Complete';

  @override
  String get updateInstallConfirmMessage => 'New version has been downloaded. Install now?';

  @override
  String get updateNotificationPermissionGuideText => 'Download progress notifications are disabled, but this doesn\'t affect download functionality. To view progress:';

  @override
  String get updateNotificationGuideStep1 => 'Go to System Settings > App Management';

  @override
  String get updateNotificationGuideStep2 => 'Find \\\"BeeCount\\\" app';

  @override
  String get updateNotificationGuideStep3 => 'Enable notification permissions';

  @override
  String get updateNotificationGuideInfo => 'Downloads will continue normally in the background even without notifications';

  @override
  String get currencyCNY => 'Chinese Yuan';

  @override
  String get currencyUSD => 'US Dollar';

  @override
  String get currencyEUR => 'Euro';

  @override
  String get currencyJPY => 'Japanese Yen';

  @override
  String get currencyHKD => 'Hong Kong Dollar';

  @override
  String get currencyTWD => 'New Taiwan Dollar';

  @override
  String get currencyGBP => 'British Pound';

  @override
  String get currencyAUD => 'Australian Dollar';

  @override
  String get currencyCAD => 'Canadian Dollar';

  @override
  String get currencyKRW => 'South Korean Won';

  @override
  String get currencySGD => 'Singapore Dollar';

  @override
  String get currencyTHB => 'Thai Baht';

  @override
  String get currencyIDR => 'Indonesian Rupiah';

  @override
  String get currencyINR => 'Indian Rupee';

  @override
  String get currencyRUB => 'Russian Ruble';

  @override
  String get currencyBYN => 'Belarusian Ruble';

  @override
  String get supportProjectTitle => 'Support Project';

  @override
  String get supportProjectWhyTitle => 'Why We Need Your Support?';

  @override
  String get supportProjectWhyDescription => 'BeeCount is a completely free and open-source project with no ads or paid features. Ongoing operations require annual renewal of Apple Developer Account (\$99/year) to keep the iOS version accessible. Your support helps the project continue to grow and benefit more users.';

  @override
  String get supportProjectAchievementTitle => 'Initial Goal Achieved';

  @override
  String get supportProjectAchievementDescription => 'Thanks to all supporters! The first iOS TestFlight beta goal has been achieved, and the app is now live.';

  @override
  String get supportProjectOngoingTitle => 'Ongoing Operation Costs';

  @override
  String supportProjectCurrentAmount(String amount) {
    return 'Raised: $amount';
  }

  @override
  String supportProjectTargetAmount(String amount) {
    return 'Goal: $amount';
  }

  @override
  String supportProjectProgress(String progress) {
    return 'Progress: $progress';
  }

  @override
  String get supportProjectUsageTitle => 'How Funds Are Used';

  @override
  String get supportProjectUsage1 => 'Annual Apple Developer Account renewal (\$99/year)';

  @override
  String get supportProjectUsage2 => 'Continuous maintenance and new feature development';

  @override
  String get supportProjectUsage3 => 'Support for HarmonyOS and cross-platform adaptation';

  @override
  String get supportProjectViewDonationMethods => 'View Donation Methods';

  @override
  String get supportProjectNote => '💡 Donations are completely voluntary, the project remains free and open-source forever';

  @override
  String get supportProjectVoluntaryNote => 'Every contribution goes toward long-term maintenance, keeping BeeCount available for all users.';

  @override
  String get webdavConfiguredTitle => 'WebDAV Cloud Service Configured';

  @override
  String get webdavConfiguredMessage => 'WebDAV cloud service uses the credentials provided during configuration, no additional login required.';

  @override
  String get recurringTransactionTitle => 'Recurring Bills';

  @override
  String get recurringTransactionAdd => 'Add Recurring Bill';

  @override
  String get recurringTransactionEdit => 'Edit Recurring Bill';

  @override
  String get recurringTransactionFrequency => 'Frequency';

  @override
  String get recurringTransactionDaily => 'Daily';

  @override
  String get recurringTransactionWeekly => 'Weekly';

  @override
  String get recurringTransactionMonthly => 'Monthly';

  @override
  String get recurringTransactionYearly => 'Yearly';

  @override
  String get recurringTransactionInterval => 'Interval';

  @override
  String get recurringTransactionDayOfMonth => 'Day of Month';

  @override
  String get recurringTransactionStartDate => 'Start Date';

  @override
  String get recurringTransactionEndDate => 'End Date';

  @override
  String get recurringTransactionNoEndDate => 'Perpetual';

  @override
  String get recurringTransactionEnabled => 'Enabled';

  @override
  String get recurringTransactionDisabled => 'Disabled';

  @override
  String get recurringTransactionNextGeneration => 'Next Generation';

  @override
  String get recurringTransactionDeleteConfirm => 'Are you sure you want to delete this recurring bill?';

  @override
  String get recurringTransactionEmpty => 'No Recurring Bills';

  @override
  String get recurringTransactionEmptyHint => 'Tap the + button in the top right corner to add';

  @override
  String recurringTransactionEveryNDays(int n) {
    return 'Every $n day(s)';
  }

  @override
  String recurringTransactionEveryNWeeks(int n) {
    return 'Every $n week(s)';
  }

  @override
  String recurringTransactionEveryNMonths(int n) {
    return 'Every $n month(s)';
  }

  @override
  String recurringTransactionEveryNYears(int n) {
    return 'Every $n year(s)';
  }

  @override
  String get cloudDefaultServiceDisplayName => 'Default Cloud Service';

  @override
  String get cloudNotConfiguredDisplay => 'Not Configured';

  @override
  String get syncNotConfiguredMessage => 'Cloud not configured';

  @override
  String get syncNotLoggedInMessage => 'Not logged in';

  @override
  String get syncCloudBackupCorruptedMessage => 'Cloud backup content is corrupted, possibly due to encoding issues from earlier versions. Please click \'Upload Current Ledger to Cloud\' to overwrite and fix.';

  @override
  String get syncNoCloudBackupMessage => 'No cloud backup';

  @override
  String get syncAccessDeniedMessage => '403 Access denied (check storage RLS policy and path)';

  @override
  String get cloudTestConnection => 'Test Connection';

  @override
  String get cloudLocalStorageTitle => 'Local Storage';

  @override
  String get cloudLocalStorageSubtitle => 'Data is only saved on local device';

  @override
  String get cloudCustomSupabaseTitle => 'Custom Supabase';

  @override
  String get cloudCustomSupabaseSubtitle => 'Click to configure self-hosted Supabase';

  @override
  String get cloudCustomWebdavTitle => 'Custom WebDAV';

  @override
  String get cloudCustomWebdavSubtitle => 'Click to configure Nutstore/Nextcloud etc.';

  @override
  String get cloudStatusNotTested => 'Not tested';

  @override
  String get cloudStatusNormal => 'Connection normal';

  @override
  String get cloudStatusFailed => 'Connection failed';

  @override
  String get cloudCannotOpenLink => 'Cannot open link';

  @override
  String get cloudErrorAuthFailed => 'Authentication failed: Invalid API Key';

  @override
  String cloudErrorServerStatus(String code) {
    return 'Server returned status code $code';
  }

  @override
  String get cloudErrorWebdavNotSupported => 'Server does not support WebDAV protocol';

  @override
  String get cloudErrorAuthFailedCredentials => 'Authentication failed: Incorrect username or password';

  @override
  String get cloudErrorAccessDenied => 'Access denied: Please check permissions';

  @override
  String cloudErrorPathNotFound(String path) {
    return 'Server path not found: $path';
  }

  @override
  String cloudErrorNetwork(String message) {
    return 'Network error: $message';
  }

  @override
  String get cloudTestSuccessTitle => 'Test Successful';

  @override
  String get cloudTestSuccessMessage => 'Connection normal, configuration valid';

  @override
  String get cloudTestFailedTitle => 'Test Failed';

  @override
  String get cloudTestFailedMessage => 'Connection failed';

  @override
  String get cloudTestErrorTitle => 'Test Error';

  @override
  String get cloudSwitchConfirmTitle => 'Switch Cloud Service';

  @override
  String get cloudSwitchConfirmMessage => 'Switching cloud service will log out current account. Confirm switch?';

  @override
  String get cloudSwitchFailedTitle => 'Switch Failed';

  @override
  String get cloudSwitchFailedConfigMissing => 'Please configure this cloud service first';

  @override
  String get cloudConfigInvalidTitle => 'Invalid Configuration';

  @override
  String get cloudConfigInvalidMessage => 'Please fill in complete information';

  @override
  String get cloudSaveFailed => 'Save Failed';

  @override
  String cloudSwitchedTo(String type) {
    return 'Switched to $type';
  }

  @override
  String get cloudConfigureSupabaseTitle => 'Configure Supabase';

  @override
  String get cloudConfigureWebdavTitle => 'Configure WebDAV';

  @override
  String get cloudSupabaseAnonKeyHintLong => 'Paste complete anon key';

  @override
  String get cloudWebdavRemotePathLabel => 'Remote Path';

  @override
  String get cloudWebdavRemotePathHelperText => 'Remote directory path for data storage';

  @override
  String get accountsTitle => 'Account Management';

  @override
  String get accountsEmptyMessage => 'No accounts yet, tap the top right to add';

  @override
  String get accountAddTooltip => 'Add Account';

  @override
  String get accountAddButton => 'Add Account';

  @override
  String get accountBalance => 'Balance';

  @override
  String get accountEditTitle => 'Edit Account';

  @override
  String get accountNewTitle => 'New Account';

  @override
  String get accountNameLabel => 'Account Name';

  @override
  String get accountNameHint => 'e.g.: ICBC, Alipay, etc.';

  @override
  String get accountNameRequired => 'Please enter account name';

  @override
  String get accountTypeLabel => 'Account Type';

  @override
  String get accountTypeCash => 'Cash';

  @override
  String get accountTypeBankCard => 'Bank Card';

  @override
  String get accountTypeCreditCard => 'Credit Card';

  @override
  String get accountTypeAlipay => 'Alipay';

  @override
  String get accountTypeWechat => 'WeChat';

  @override
  String get accountTypeOther => 'Other';

  @override
  String get accountInitialBalance => 'Initial Balance';

  @override
  String get accountInitialBalanceHint => 'Enter initial balance (optional)';

  @override
  String get accountDeleteWarningTitle => 'Confirm Delete';

  @override
  String accountDeleteWarningMessage(int count) {
    return 'This account has $count related transactions. After deletion, account information in transaction records will be cleared. Confirm deletion?';
  }

  @override
  String get accountDeleteConfirm => 'Confirm to delete this account?';

  @override
  String get accountSelectTitle => 'Select Account';

  @override
  String get accountNone => 'No Account';

  @override
  String get accountsEnableFeature => 'Enable Account Feature';

  @override
  String get accountsFeatureDescription => 'Manage multiple payment accounts and track balance changes for each account';

  @override
  String get updateCorruptedFileTitle => 'Corrupted Installation Package';

  @override
  String get updateCorruptedFileMessage => 'The previously downloaded installation package is incomplete or corrupted. Delete and re-download?';
}
