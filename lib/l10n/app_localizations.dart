import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr')
  ];

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @onboarding1Title.
  ///
  /// In en, this message translates to:
  /// **'Comprehensive Patient Profiles'**
  String get onboarding1Title;

  /// No description provided for @onboarding1Desc.
  ///
  /// In en, this message translates to:
  /// **'Quickly access patient histories, treatment plans, and notes with a few taps.'**
  String get onboarding1Desc;

  /// No description provided for @onboarding2Title.
  ///
  /// In en, this message translates to:
  /// **'Manage Appointments with Ease'**
  String get onboarding2Title;

  /// No description provided for @onboarding2Desc.
  ///
  /// In en, this message translates to:
  /// **'Create, reschedule, or cancel appointments with a synced calendar.'**
  String get onboarding2Desc;

  /// No description provided for @onboarding3Title.
  ///
  /// In en, this message translates to:
  /// **'Easy Invoicing for Patients'**
  String get onboarding3Title;

  /// No description provided for @onboarding3Desc.
  ///
  /// In en, this message translates to:
  /// **'Generate and track invoices in a few clicks. Monitor payments and balances.'**
  String get onboarding3Desc;

  /// No description provided for @continueBtn.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueBtn;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Cliniify'**
  String get welcomeTitle;

  /// No description provided for @welcomeDesc.
  ///
  /// In en, this message translates to:
  /// **'Effortlessly manage appointments, patients, and invoices.'**
  String get welcomeDesc;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @userIdLabel.
  ///
  /// In en, this message translates to:
  /// **'User ID'**
  String get userIdLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get rememberMe;

  /// No description provided for @logInWithOtp.
  ///
  /// In en, this message translates to:
  /// **'Log in with OTP '**
  String get logInWithOtp;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get dontHaveAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @empoweringHealthcare.
  ///
  /// In en, this message translates to:
  /// **'Empowering Healthcare'**
  String get empoweringHealthcare;

  /// No description provided for @andMedicalPractices.
  ///
  /// In en, this message translates to:
  /// **'& Medical Practices'**
  String get andMedicalPractices;

  /// No description provided for @selectClinicTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Clinic'**
  String get selectClinicTitle;

  /// No description provided for @selectYourClinicLabel.
  ///
  /// In en, this message translates to:
  /// **'Select your Clinic'**
  String get selectYourClinicLabel;

  /// No description provided for @unknownClinic.
  ///
  /// In en, this message translates to:
  /// **'Unknown Clinic'**
  String get unknownClinic;

  /// No description provided for @backBtn.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get backBtn;

  /// No description provided for @deleteButton.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteButton;

  /// No description provided for @errorEnterUserId.
  ///
  /// In en, this message translates to:
  /// **'Please enter your User ID'**
  String get errorEnterUserId;

  /// No description provided for @errorValidPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid 10-digit phone number'**
  String get errorValidPhone;

  /// No description provided for @errorValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get errorValidEmail;

  /// No description provided for @errorEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter email'**
  String get errorEnterEmail;

  /// No description provided for @errorOtpSent.
  ///
  /// In en, this message translates to:
  /// **'OTP sent successfully'**
  String get errorOtpSent;

  /// No description provided for @errorOtpFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to request OTP'**
  String get errorOtpFailed;

  /// No description provided for @errorNoInternet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Please connect to the Internet.'**
  String get errorNoInternet;

  /// No description provided for @errorInvalidCreds.
  ///
  /// In en, this message translates to:
  /// **'Invalid Email or Password.'**
  String get errorInvalidCreds;

  /// No description provided for @errorLoginFailed.
  ///
  /// In en, this message translates to:
  /// **'An error occurred during login.'**
  String get errorLoginFailed;

  /// No description provided for @errorSelectClinic.
  ///
  /// In en, this message translates to:
  /// **'Please select a clinic'**
  String get errorSelectClinic;

  /// No description provided for @errorAssignRoles.
  ///
  /// In en, this message translates to:
  /// **'Error assigning roles.'**
  String get errorAssignRoles;

  /// No description provided for @createAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccountTitle;

  /// No description provided for @doctorNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Doctor Name'**
  String get doctorNameLabel;

  /// No description provided for @clinicNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Clinic Name'**
  String get clinicNameLabel;

  /// No description provided for @emailIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Email ID'**
  String get emailIdLabel;

  /// No description provided for @phoneNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumberLabel;

  /// No description provided for @setPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Set Password'**
  String get setPasswordLabel;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPasswordLabel;

  /// No description provided for @errorPasswordShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get errorPasswordShort;

  /// No description provided for @errorPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get errorPasswordMismatch;

  /// No description provided for @agreeToTermsPrefix.
  ///
  /// In en, this message translates to:
  /// **'I read and agree to the '**
  String get agreeToTermsPrefix;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsAndConditions;

  /// No description provided for @andText.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get andText;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @generalSection.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get generalSection;

  /// No description provided for @myClinics.
  ///
  /// In en, this message translates to:
  /// **'My Clinics'**
  String get myClinics;

  /// No description provided for @subscription.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get subscription;

  /// No description provided for @clinicalNotes.
  ///
  /// In en, this message translates to:
  /// **'Clinical Notes'**
  String get clinicalNotes;

  /// No description provided for @aboutSection.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutSection;

  /// No description provided for @accountSection.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountSection;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @homeTab.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTab;

  /// No description provided for @appointmentsTab.
  ///
  /// In en, this message translates to:
  /// **'Appointments'**
  String get appointmentsTab;

  /// No description provided for @patientsTab.
  ///
  /// In en, this message translates to:
  /// **'Patients'**
  String get patientsTab;

  /// No description provided for @reportsTab.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reportsTab;

  /// No description provided for @profileTab.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTab;

  /// No description provided for @todaysAppointments.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Appointments'**
  String get todaysAppointments;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @todaysSummary.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Summary'**
  String get todaysSummary;

  /// No description provided for @noAppointmentsToday.
  ///
  /// In en, this message translates to:
  /// **'No Appointments Today'**
  String get noAppointmentsToday;

  /// No description provided for @scheduleClearDesc.
  ///
  /// In en, this message translates to:
  /// **'Your schedule is clear. Take a break or manage other clinic tasks.'**
  String get scheduleClearDesc;

  /// No description provided for @financialOverview.
  ///
  /// In en, this message translates to:
  /// **'Here is your financial overview'**
  String get financialOverview;

  /// No description provided for @todaysIncome.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Income'**
  String get todaysIncome;

  /// No description provided for @sevenDayTrend.
  ///
  /// In en, this message translates to:
  /// **'7-Day Trend'**
  String get sevenDayTrend;

  /// No description provided for @errorLoadingFinancial.
  ///
  /// In en, this message translates to:
  /// **'Error loading financial data'**
  String get errorLoadingFinancial;

  /// No description provided for @noFinancialData.
  ///
  /// In en, this message translates to:
  /// **'No financial data available'**
  String get noFinancialData;

  /// No description provided for @appointmentsToday.
  ///
  /// In en, this message translates to:
  /// **'Appointments\nToday'**
  String get appointmentsToday;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @patients.
  ///
  /// In en, this message translates to:
  /// **'Patients'**
  String get patients;

  /// No description provided for @newCount.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get newCount;

  /// No description provided for @appointments.
  ///
  /// In en, this message translates to:
  /// **'Appointments'**
  String get appointments;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @users.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get users;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @procedures.
  ///
  /// In en, this message translates to:
  /// **'Procedures'**
  String get procedures;

  /// No description provided for @patientLabel.
  ///
  /// In en, this message translates to:
  /// **'Patient'**
  String get patientLabel;

  /// No description provided for @unknownPatient.
  ///
  /// In en, this message translates to:
  /// **'Unknown Patient'**
  String get unknownPatient;

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get notAvailable;

  /// No description provided for @proceduresAndItems.
  ///
  /// In en, this message translates to:
  /// **'Procedures & Items'**
  String get proceduresAndItems;

  /// No description provided for @unknownItem.
  ///
  /// In en, this message translates to:
  /// **'Unknown Item'**
  String get unknownItem;

  /// No description provided for @qtyLabel.
  ///
  /// In en, this message translates to:
  /// **'Qty'**
  String get qtyLabel;

  /// No description provided for @noItemsRecorded.
  ///
  /// In en, this message translates to:
  /// **'No items recorded'**
  String get noItemsRecorded;

  /// No description provided for @paymentsLabel.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get paymentsLabel;

  /// No description provided for @receiptNoLabel.
  ///
  /// In en, this message translates to:
  /// **'Receipt No'**
  String get receiptNoLabel;

  /// No description provided for @paidModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Paid Mode'**
  String get paidModeLabel;

  /// No description provided for @totalAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get totalAmountLabel;

  /// No description provided for @noPaymentsRecorded.
  ///
  /// In en, this message translates to:
  /// **'No payments recorded'**
  String get noPaymentsRecorded;

  /// No description provided for @errorLoadingSummary.
  ///
  /// In en, this message translates to:
  /// **'Error Loading Summary'**
  String get errorLoadingSummary;

  /// No description provided for @noDailySummary.
  ///
  /// In en, this message translates to:
  /// **'No Daily Summary'**
  String get noDailySummary;

  /// No description provided for @tryRefreshingPage.
  ///
  /// In en, this message translates to:
  /// **'Please try refreshing the page.'**
  String get tryRefreshingPage;

  /// No description provided for @noBillingRecordsToday.
  ///
  /// In en, this message translates to:
  /// **'No billing records found for today.'**
  String get noBillingRecordsToday;

  /// No description provided for @axonProcessingIntelligence.
  ///
  /// In en, this message translates to:
  /// **'Processing intelligence. You will shortly receive clinical notes.'**
  String get axonProcessingIntelligence;

  /// No description provided for @axonNoQuestionsReceived.
  ///
  /// In en, this message translates to:
  /// **'No questions or diagnosis received. Attempting to generate notes.'**
  String get axonNoQuestionsReceived;

  /// No description provided for @axonNotesSavedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Clinical notes saved successfully'**
  String get axonNotesSavedSuccess;

  /// No description provided for @axonNotesSavedError.
  ///
  /// In en, this message translates to:
  /// **'Clinical notes not saved'**
  String get axonNotesSavedError;

  /// No description provided for @axonSessionRefreshed.
  ///
  /// In en, this message translates to:
  /// **'Session refreshed. Ready for new input.'**
  String get axonSessionRefreshed;

  /// No description provided for @axonEndSessionTitle.
  ///
  /// In en, this message translates to:
  /// **'End Axon Session'**
  String get axonEndSessionTitle;

  /// No description provided for @axonEnterPatientName.
  ///
  /// In en, this message translates to:
  /// **'Enter patient name to save clinical notes:'**
  String get axonEnterPatientName;

  /// No description provided for @axonPatientNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Patient Name'**
  String get axonPatientNameLabel;

  /// No description provided for @axonPatientNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. John Doe'**
  String get axonPatientNameHint;

  /// No description provided for @axonCancelBtn.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get axonCancelBtn;

  /// No description provided for @axonSavingBtn.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get axonSavingBtn;

  /// No description provided for @axonSaveBtn.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get axonSaveBtn;

  /// No description provided for @axonStopSessionTitle.
  ///
  /// In en, this message translates to:
  /// **'Stop Axon Session?'**
  String get axonStopSessionTitle;

  /// No description provided for @axonStopSessionWarning.
  ///
  /// In en, this message translates to:
  /// **'Once you stop, all unsaved data will be lost.'**
  String get axonStopSessionWarning;

  /// No description provided for @axonStopBtn.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get axonStopBtn;

  /// No description provided for @axonTitle.
  ///
  /// In en, this message translates to:
  /// **'Axon AI'**
  String get axonTitle;

  /// No description provided for @axonPlatformReady.
  ///
  /// In en, this message translates to:
  /// **'Cliniify AI Platform – Ready'**
  String get axonPlatformReady;

  /// No description provided for @axonHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'The Neural\nBrain Behind\nEvery Clinic.'**
  String get axonHeroTitle;

  /// No description provided for @axonHeroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Axon is Cliniify\'s unified AI intelligence layer — powering real-time diagnosis, auto-documentation, smart prescriptions, predictive scheduling, and clinical decision support across every specialty.'**
  String get axonHeroSubtitle;

  /// No description provided for @axonStartSessionBtn.
  ///
  /// In en, this message translates to:
  /// **'Start Session'**
  String get axonStartSessionBtn;

  /// No description provided for @axonSavedNotesBtn.
  ///
  /// In en, this message translates to:
  /// **'Saved Notes'**
  String get axonSavedNotesBtn;

  /// No description provided for @axonEncryptionNotice.
  ///
  /// In en, this message translates to:
  /// **'End-to-End Encrypted. Data is never used to train public models.'**
  String get axonEncryptionNotice;

  /// No description provided for @axonListening.
  ///
  /// In en, this message translates to:
  /// **'Listening to patient...'**
  String get axonListening;

  /// No description provided for @axonTranscribing.
  ///
  /// In en, this message translates to:
  /// **'Transcribing'**
  String get axonTranscribing;

  /// No description provided for @axonNextQuestions.
  ///
  /// In en, this message translates to:
  /// **'Possible Next Questions'**
  String get axonNextQuestions;

  /// No description provided for @axonClinicalPossibilities.
  ///
  /// In en, this message translates to:
  /// **'Clinical Possibilities'**
  String get axonClinicalPossibilities;

  /// No description provided for @axonMedicalNotes.
  ///
  /// In en, this message translates to:
  /// **'Medical Notes'**
  String get axonMedicalNotes;

  /// No description provided for @axonNotesBtn.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get axonNotesBtn;

  /// No description provided for @axonAnalyzingContext.
  ///
  /// In en, this message translates to:
  /// **'Analyzing context...'**
  String get axonAnalyzingContext;

  /// No description provided for @profileDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile Details'**
  String get profileDetailsTitle;

  /// No description provided for @fullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullNameLabel;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @selectedClinicLabel.
  ///
  /// In en, this message translates to:
  /// **'Selected Clinic'**
  String get selectedClinicLabel;

  /// No description provided for @subscriptionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions'**
  String get subscriptionsTitle;

  /// No description provided for @subscriptionInfo.
  ///
  /// In en, this message translates to:
  /// **'Subscription Info'**
  String get subscriptionInfo;

  /// No description provided for @termsConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsConditions;

  /// No description provided for @inAppPurchasesNotAllowed.
  ///
  /// In en, this message translates to:
  /// **'In-app purchases are not allowed.'**
  String get inAppPurchasesNotAllowed;

  /// No description provided for @okBtn.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get okBtn;

  /// No description provided for @cancelBtn.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelBtn;

  /// No description provided for @purchaseFailed.
  ///
  /// In en, this message translates to:
  /// **'Purchase Failed'**
  String get purchaseFailed;

  /// No description provided for @purchaseError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred during the purchase: {errorMessage}.'**
  String purchaseError(String errorMessage);

  /// No description provided for @errorLoadingPlans.
  ///
  /// In en, this message translates to:
  /// **'Error loading plans: {error}'**
  String errorLoadingPlans(String error);

  /// No description provided for @subscribeNow.
  ///
  /// In en, this message translates to:
  /// **'Subscribe Now'**
  String get subscribeNow;

  /// No description provided for @activeBadge.
  ///
  /// In en, this message translates to:
  /// **'ACTIVE'**
  String get activeBadge;

  /// No description provided for @stdPlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Cliniify Pro Standard (1 Year)'**
  String get stdPlanTitle;

  /// No description provided for @stdPlanDesc.
  ///
  /// In en, this message translates to:
  /// **'The Standard Year subscription provides essential clinic management tools to enhance your dental practice\'s daily operations. It includes the following features:'**
  String get stdPlanDesc;

  /// No description provided for @featApptScheduling.
  ///
  /// In en, this message translates to:
  /// **'Appointment Scheduling'**
  String get featApptScheduling;

  /// No description provided for @featApptSchedulingDesc.
  ///
  /// In en, this message translates to:
  /// **'Effortlessly book, manage, and modify patient appointments.'**
  String get featApptSchedulingDesc;

  /// No description provided for @featAdvInvoicing.
  ///
  /// In en, this message translates to:
  /// **'Advanced Invoicing'**
  String get featAdvInvoicing;

  /// No description provided for @featAdvInvoicingDesc.
  ///
  /// In en, this message translates to:
  /// **'Generate patient invoices in advance to streamline payment workflows.'**
  String get featAdvInvoicingDesc;

  /// No description provided for @featDigitalEMR.
  ///
  /// In en, this message translates to:
  /// **'Digital EMR'**
  String get featDigitalEMR;

  /// No description provided for @featDigitalEMRDesc.
  ///
  /// In en, this message translates to:
  /// **'Securely store and manage patient health records, reducing paperwork and improving clinic efficiency.'**
  String get featDigitalEMRDesc;

  /// No description provided for @prmPlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Cliniify Pro Premium (1 Year)'**
  String get prmPlanTitle;

  /// No description provided for @prmPlanDesc.
  ///
  /// In en, this message translates to:
  /// **'The Premium Year subscription builds upon the Standard plan, offering advanced tools for more comprehensive clinic management. It includes all the features of the Standard plan, plus:'**
  String get prmPlanDesc;

  /// No description provided for @featAdvReporting.
  ///
  /// In en, this message translates to:
  /// **'Advanced Reporting'**
  String get featAdvReporting;

  /// No description provided for @featAdvReportingDesc.
  ///
  /// In en, this message translates to:
  /// **'Access deeper insights into clinic performance with comprehensive patient reports and data analytics to improve patient care and optimize operations.'**
  String get featAdvReportingDesc;

  /// No description provided for @featUserMgmt.
  ///
  /// In en, this message translates to:
  /// **'User Management'**
  String get featUserMgmt;

  /// No description provided for @featUserMgmtDesc.
  ///
  /// In en, this message translates to:
  /// **'Manage staff permissions and roles, enabling more efficient clinic operations by controlling access to various features.'**
  String get featUserMgmtDesc;

  /// No description provided for @privacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Privacy Matters'**
  String get privacyTitle;

  /// No description provided for @privacyContent.
  ///
  /// In en, this message translates to:
  /// **'By using our Clinic Management Software, you agree to the terms outlined in this Privacy Policy. We at Cliniify, are committed to protecting the privacy of our users. This Privacy Policy outlines how we collect, use, disclose, and protect your personal information in connection with our Clinic Management Software and the solutions we provide.'**
  String get privacyContent;

  /// No description provided for @policiesTitle.
  ///
  /// In en, this message translates to:
  /// **'POLICIES & DETAILS'**
  String get policiesTitle;

  /// No description provided for @infoCollection.
  ///
  /// In en, this message translates to:
  /// **'Information Collection'**
  String get infoCollection;

  /// No description provided for @infoCollectionContent.
  ///
  /// In en, this message translates to:
  /// **'We collect personal information such as names, phone numbers, and email addresses. Additionally, our software processes health-related information and treatment history.'**
  String get infoCollectionContent;

  /// No description provided for @dataUsage.
  ///
  /// In en, this message translates to:
  /// **'Data Usage'**
  String get dataUsage;

  /// No description provided for @dataUsageContent.
  ///
  /// In en, this message translates to:
  /// **'Information is used to provide services like appointment scheduling and records management, and to send important notifications or service updates.'**
  String get dataUsageContent;

  /// No description provided for @infoSharing.
  ///
  /// In en, this message translates to:
  /// **'Information Sharing'**
  String get infoSharing;

  /// No description provided for @infoSharingContent.
  ///
  /// In en, this message translates to:
  /// **'We only share data with verified third-party providers who maintain strict confidentiality or when required by legal obligations.'**
  String get infoSharingContent;

  /// No description provided for @contactChanges.
  ///
  /// In en, this message translates to:
  /// **'Contact & Changes'**
  String get contactChanges;

  /// No description provided for @contactChangesContent.
  ///
  /// In en, this message translates to:
  /// **'We may modify this policy over time. For any data inquiries, please contact us at '**
  String get contactChangesContent;

  /// No description provided for @termsTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsTitle;

  /// No description provided for @agreementTitle.
  ///
  /// In en, this message translates to:
  /// **'Agreement of Use'**
  String get agreementTitle;

  /// No description provided for @agreementContent.
  ///
  /// In en, this message translates to:
  /// **'These Terms of Use (\"Terms\") govern your use of the Cliniify Dental Clinic Management Software (\"Software\") and our website. Please read these Terms carefully, as they constitute a legally binding agreement between you and Cliniify. By using our Software or logging into our product, you agree to comply with and be bound by these Terms. If you do not agree with these Terms, please refrain from using Cliniify\'s services.'**
  String get agreementContent;

  /// No description provided for @legalFramework.
  ///
  /// In en, this message translates to:
  /// **'LEGAL FRAMEWORK'**
  String get legalFramework;

  /// No description provided for @acceptanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Acceptance of Terms'**
  String get acceptanceTitle;

  /// No description provided for @acceptanceContent.
  ///
  /// In en, this message translates to:
  /// **'By accessing and using Cliniify\'s Software and website, you acknowledge your agreement with the terms mentioned below.'**
  String get acceptanceContent;

  /// No description provided for @userResponsibilitiesTitle.
  ///
  /// In en, this message translates to:
  /// **'User Responsibilities'**
  String get userResponsibilitiesTitle;

  /// No description provided for @userResponsibilitiesContent.
  ///
  /// In en, this message translates to:
  /// **'You are granted a limited, non-exclusive license for clinic management. You are responsible for maintaining account confidentiality and all activities under your credentials.'**
  String get userResponsibilitiesContent;

  /// No description provided for @prohibitedActionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Prohibited Actions'**
  String get prohibitedActionsTitle;

  /// No description provided for @prohibitedActionsList1.
  ///
  /// In en, this message translates to:
  /// **'Attempt to reverse engineer the Software.'**
  String get prohibitedActionsList1;

  /// No description provided for @prohibitedActionsList2.
  ///
  /// In en, this message translates to:
  /// **'Use for unlawful or unauthorized purposes.'**
  String get prohibitedActionsList2;

  /// No description provided for @prohibitedActionsList3.
  ///
  /// In en, this message translates to:
  /// **'Infringe upon intellectual property rights.'**
  String get prohibitedActionsList3;

  /// No description provided for @prohibitedActionsList4.
  ///
  /// In en, this message translates to:
  /// **'Unauthorized access or sharing credentials.'**
  String get prohibitedActionsList4;

  /// No description provided for @updatesSupportTitle.
  ///
  /// In en, this message translates to:
  /// **'Updates & Support'**
  String get updatesSupportTitle;

  /// No description provided for @updatesSupportContent.
  ///
  /// In en, this message translates to:
  /// **'Cliniify may release updates at its discretion. We are not obligated to provide constant support, though we strive to assist our users.'**
  String get updatesSupportContent;

  /// No description provided for @contactInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get contactInfoTitle;

  /// No description provided for @contactInfoContent.
  ///
  /// In en, this message translates to:
  /// **'If you have any questions regarding these Terms or the use of Cliniify, please contact us at '**
  String get contactInfoContent;

  /// No description provided for @clinicalNotesTitle.
  ///
  /// In en, this message translates to:
  /// **'Clinical Notes'**
  String get clinicalNotesTitle;

  /// No description provided for @clinicalNotesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No clinical notes found'**
  String get clinicalNotesEmpty;

  /// No description provided for @clinicalNotesEmptyDesc.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t created any clinical notes yet. Start by creating a new note to document your patient interactions and treatment plans.'**
  String get clinicalNotesEmptyDesc;

  /// No description provided for @deleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccountTitle;

  /// No description provided for @deleteAccountDescription.
  ///
  /// In en, this message translates to:
  /// **'Are you certain you want to delete your account? Deleting your account will result in the permanent loss of your profile, including all medical records and appointment history.'**
  String get deleteAccountDescription;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @logoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logoutTitle;

  /// No description provided for @logoutDescription.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out? You will need to enter your credentials again to access your clinics.'**
  String get logoutDescription;

  /// No description provided for @logoutButton.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logoutButton;

  /// No description provided for @appointmentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Appointments'**
  String get appointmentsTitle;

  /// No description provided for @jumpToToday.
  ///
  /// In en, this message translates to:
  /// **'Jump to Today'**
  String get jumpToToday;

  /// No description provided for @errorLoadingAppointments.
  ///
  /// In en, this message translates to:
  /// **'Error Loading Appointments'**
  String get errorLoadingAppointments;

  /// No description provided for @noAppointments.
  ///
  /// In en, this message translates to:
  /// **'No Appointments'**
  String get noAppointments;

  /// No description provided for @pleaseTryPullingDown.
  ///
  /// In en, this message translates to:
  /// **'Please try pulling down to refresh.'**
  String get pleaseTryPullingDown;

  /// No description provided for @enjoyYourFreeTime.
  ///
  /// In en, this message translates to:
  /// **'Enjoy your free time!'**
  String get enjoyYourFreeTime;

  /// No description provided for @addAppointmentTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Appointment'**
  String get addAppointmentTitle;

  /// No description provided for @confirmAppointment.
  ///
  /// In en, this message translates to:
  /// **'Confirm Appointment'**
  String get confirmAppointment;

  /// No description provided for @patientAndDoctor.
  ///
  /// In en, this message translates to:
  /// **'Patient & Doctor'**
  String get patientAndDoctor;

  /// No description provided for @patient.
  ///
  /// In en, this message translates to:
  /// **'Patient'**
  String get patient;

  /// No description provided for @selectPatient.
  ///
  /// In en, this message translates to:
  /// **'Select Patient'**
  String get selectPatient;

  /// No description provided for @doctor.
  ///
  /// In en, this message translates to:
  /// **'Doctor'**
  String get doctor;

  /// No description provided for @selectDoctor.
  ///
  /// In en, this message translates to:
  /// **'Select Doctor'**
  String get selectDoctor;

  /// No description provided for @timings.
  ///
  /// In en, this message translates to:
  /// **'Timings'**
  String get timings;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @selectTime.
  ///
  /// In en, this message translates to:
  /// **'Select Time'**
  String get selectTime;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @medicalDetails.
  ///
  /// In en, this message translates to:
  /// **'Medical Details'**
  String get medicalDetails;

  /// No description provided for @commonIssue.
  ///
  /// In en, this message translates to:
  /// **'Common Issue'**
  String get commonIssue;

  /// No description provided for @selectIssue.
  ///
  /// In en, this message translates to:
  /// **'Select Issue'**
  String get selectIssue;

  /// No description provided for @procedure.
  ///
  /// In en, this message translates to:
  /// **'Procedure'**
  String get procedure;

  /// No description provided for @selectProcedure.
  ///
  /// In en, this message translates to:
  /// **'Select Procedure'**
  String get selectProcedure;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @descriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Write clinical notes or patient requests here...'**
  String get descriptionHint;

  /// No description provided for @min.
  ///
  /// In en, this message translates to:
  /// **'Min'**
  String get min;

  /// No description provided for @hr.
  ///
  /// In en, this message translates to:
  /// **'Hr'**
  String get hr;

  /// No description provided for @errorSelectPatient.
  ///
  /// In en, this message translates to:
  /// **'Please select a patient'**
  String get errorSelectPatient;

  /// No description provided for @errorSelectDoctor.
  ///
  /// In en, this message translates to:
  /// **'Please select a doctor'**
  String get errorSelectDoctor;

  /// No description provided for @errorSelectDate.
  ///
  /// In en, this message translates to:
  /// **'Please select a date'**
  String get errorSelectDate;

  /// No description provided for @errorSelectTime.
  ///
  /// In en, this message translates to:
  /// **'Please select a time'**
  String get errorSelectTime;

  /// No description provided for @successAppointmentCreated.
  ///
  /// In en, this message translates to:
  /// **'Appointment created successfully'**
  String get successAppointmentCreated;

  /// No description provided for @errorSomethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorSomethingWentWrong;

  /// No description provided for @searchPatient.
  ///
  /// In en, this message translates to:
  /// **'Search Patient'**
  String get searchPatient;

  /// No description provided for @typePatientName.
  ///
  /// In en, this message translates to:
  /// **'Type patient name...'**
  String get typePatientName;

  /// No description provided for @noPatientFound.
  ///
  /// In en, this message translates to:
  /// **'No Patient Found'**
  String get noPatientFound;

  /// No description provided for @addNewPatient.
  ///
  /// In en, this message translates to:
  /// **'Add New Patient'**
  String get addNewPatient;

  /// No description provided for @searchDoctor.
  ///
  /// In en, this message translates to:
  /// **'Search doctor name...'**
  String get searchDoctor;

  /// No description provided for @noDoctorsFound.
  ///
  /// In en, this message translates to:
  /// **'No Doctors Found'**
  String get noDoctorsFound;

  /// No description provided for @noName.
  ///
  /// In en, this message translates to:
  /// **'No Name'**
  String get noName;

  /// No description provided for @selectCommonIssue.
  ///
  /// In en, this message translates to:
  /// **'Select Common Issue'**
  String get selectCommonIssue;

  /// No description provided for @searchProcedure.
  ///
  /// In en, this message translates to:
  /// **'Search procedure name...'**
  String get searchProcedure;

  /// No description provided for @noProceduresFound.
  ///
  /// In en, this message translates to:
  /// **'No Procedures Found'**
  String get noProceduresFound;

  /// No description provided for @noIssueName.
  ///
  /// In en, this message translates to:
  /// **'No Issue Name'**
  String get noIssueName;

  /// No description provided for @searchTreatment.
  ///
  /// In en, this message translates to:
  /// **'Search treatment name...'**
  String get searchTreatment;

  /// No description provided for @noTreatmentsFound.
  ///
  /// In en, this message translates to:
  /// **'No Treatments Found'**
  String get noTreatmentsFound;

  /// No description provided for @noTreatmentName.
  ///
  /// In en, this message translates to:
  /// **'No Treatment Name'**
  String get noTreatmentName;

  /// No description provided for @editAppointmentTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Appointment'**
  String get editAppointmentTitle;

  /// No description provided for @updateAppointmentBtn.
  ///
  /// In en, this message translates to:
  /// **'Update Appointment'**
  String get updateAppointmentBtn;

  /// No description provided for @patientDoctorSection.
  ///
  /// In en, this message translates to:
  /// **'Patient & Doctor'**
  String get patientDoctorSection;

  /// No description provided for @doctorLabel.
  ///
  /// In en, this message translates to:
  /// **'Doctor'**
  String get doctorLabel;

  /// No description provided for @timingsStatusSection.
  ///
  /// In en, this message translates to:
  /// **'Timings & Status'**
  String get timingsStatusSection;

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateLabel;

  /// No description provided for @timeLabel.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get timeLabel;

  /// No description provided for @durationSection.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get durationSection;

  /// No description provided for @statusSection.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get statusSection;

  /// No description provided for @statusRequested.
  ///
  /// In en, this message translates to:
  /// **'Requested'**
  String get statusRequested;

  /// No description provided for @statusConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get statusConfirmed;

  /// No description provided for @statusRescheduled.
  ///
  /// In en, this message translates to:
  /// **'Rescheduled'**
  String get statusRescheduled;

  /// No description provided for @statusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get statusCancelled;

  /// No description provided for @statusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get statusCompleted;

  /// No description provided for @medicalDetailsSection.
  ///
  /// In en, this message translates to:
  /// **'Medical Details'**
  String get medicalDetailsSection;

  /// No description provided for @commonIssueLabel.
  ///
  /// In en, this message translates to:
  /// **'Common Issue'**
  String get commonIssueLabel;

  /// No description provided for @procedureLabel.
  ///
  /// In en, this message translates to:
  /// **'Procedure'**
  String get procedureLabel;

  /// No description provided for @descriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get descriptionLabel;

  /// No description provided for @descriptionHintEdit.
  ///
  /// In en, this message translates to:
  /// **'Write clinical notes or updates here...'**
  String get descriptionHintEdit;

  /// No description provided for @errorSelectStatus.
  ///
  /// In en, this message translates to:
  /// **'Please select a status'**
  String get errorSelectStatus;

  /// No description provided for @errorPatientContextMissing.
  ///
  /// In en, this message translates to:
  /// **'Patient context missing'**
  String get errorPatientContextMissing;

  /// No description provided for @successApptUpdated.
  ///
  /// In en, this message translates to:
  /// **'Appointment updated successfully'**
  String get successApptUpdated;

  /// No description provided for @minShort.
  ///
  /// In en, this message translates to:
  /// **'Min'**
  String get minShort;

  /// No description provided for @hrShort.
  ///
  /// In en, this message translates to:
  /// **'Hr'**
  String get hrShort;

  /// No description provided for @appointmentDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Appointment Details'**
  String get appointmentDetailsTitle;

  /// No description provided for @appointmentDetailsNotFound.
  ///
  /// In en, this message translates to:
  /// **'Appointment Details Not Found'**
  String get appointmentDetailsNotFound;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @years.
  ///
  /// In en, this message translates to:
  /// **'Years'**
  String get years;

  /// No description provided for @appointmentInfo.
  ///
  /// In en, this message translates to:
  /// **'Appointment Info'**
  String get appointmentInfo;

  /// No description provided for @clinicalDetails.
  ///
  /// In en, this message translates to:
  /// **'Clinical Details'**
  String get clinicalDetails;

  /// No description provided for @plannedProcedure.
  ///
  /// In en, this message translates to:
  /// **'Planned Procedure'**
  String get plannedProcedure;

  /// No description provided for @noProcedurePlanned.
  ///
  /// In en, this message translates to:
  /// **'No Procedure Planned'**
  String get noProcedurePlanned;

  /// No description provided for @noDescriptionAvailable.
  ///
  /// In en, this message translates to:
  /// **'No Description Available'**
  String get noDescriptionAvailable;

  /// No description provided for @deleteAppointmentTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Appointment'**
  String get deleteAppointmentTitle;

  /// No description provided for @deleteAppointmentDescription.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this appointment?'**
  String get deleteAppointmentDescription;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @appointmentDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Appointment deleted successfully'**
  String get appointmentDeletedSuccess;

  /// No description provided for @errorLoadingApptDetails.
  ///
  /// In en, this message translates to:
  /// **'Failed to load details.'**
  String get errorLoadingApptDetails;

  /// No description provided for @scheduledTime.
  ///
  /// In en, this message translates to:
  /// **'Scheduled Time'**
  String get scheduledTime;

  /// No description provided for @searchPatientHint.
  ///
  /// In en, this message translates to:
  /// **'Search patient name...'**
  String get searchPatientHint;

  /// No description provided for @noPatientsFound.
  ///
  /// In en, this message translates to:
  /// **'No Patients Found'**
  String get noPatientsFound;

  /// No description provided for @startTypingToSearch.
  ///
  /// In en, this message translates to:
  /// **'Start typing to search for a patient.'**
  String get startTypingToSearch;

  /// No description provided for @tryAdjustingSearch.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your search criteria.'**
  String get tryAdjustingSearch;

  /// No description provided for @errorLoadingData.
  ///
  /// In en, this message translates to:
  /// **'Error Loading Data'**
  String get errorLoadingData;

  /// No description provided for @addPatientTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Patient'**
  String get addPatientTitle;

  /// No description provided for @clinicDetails.
  ///
  /// In en, this message translates to:
  /// **'Clinic Details'**
  String get clinicDetails;

  /// No description provided for @patientNameSec.
  ///
  /// In en, this message translates to:
  /// **'Patient Name'**
  String get patientNameSec;

  /// No description provided for @contactDetails.
  ///
  /// In en, this message translates to:
  /// **'Contact Details'**
  String get contactDetails;

  /// No description provided for @generalDetails.
  ///
  /// In en, this message translates to:
  /// **'General Details'**
  String get generalDetails;

  /// No description provided for @addressDetails.
  ///
  /// In en, this message translates to:
  /// **'Address Details'**
  String get addressDetails;

  /// No description provided for @otherDetails.
  ///
  /// In en, this message translates to:
  /// **'Other Details'**
  String get otherDetails;

  /// No description provided for @uploadPicture.
  ///
  /// In en, this message translates to:
  /// **'Upload Picture'**
  String get uploadPicture;

  /// No description provided for @otherHistoryNotes.
  ///
  /// In en, this message translates to:
  /// **'Other History Notes'**
  String get otherHistoryNotes;

  /// No description provided for @patientIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Patient ID'**
  String get patientIdLabel;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @enterFirstName.
  ///
  /// In en, this message translates to:
  /// **'Enter First Name'**
  String get enterFirstName;

  /// No description provided for @middleName.
  ///
  /// In en, this message translates to:
  /// **'Middle Name'**
  String get middleName;

  /// No description provided for @enterMiddleName.
  ///
  /// In en, this message translates to:
  /// **'Enter Middle Name'**
  String get enterMiddleName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @enterLastName.
  ///
  /// In en, this message translates to:
  /// **'Enter Last Name'**
  String get enterLastName;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'patient@example.com'**
  String get emailHint;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @enterPrimaryPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter Primary Phone'**
  String get enterPrimaryPhone;

  /// No description provided for @secondaryPhone.
  ///
  /// In en, this message translates to:
  /// **'Secondary Phone'**
  String get secondaryPhone;

  /// No description provided for @enterAlternatePhone.
  ///
  /// In en, this message translates to:
  /// **'Enter Alternate Phone'**
  String get enterAlternatePhone;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// No description provided for @selectDob.
  ///
  /// In en, this message translates to:
  /// **'Select DOB'**
  String get selectDob;

  /// No description provided for @ageLabel.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get ageLabel;

  /// No description provided for @enterAge.
  ///
  /// In en, this message translates to:
  /// **'Enter Age'**
  String get enterAge;

  /// No description provided for @genderLabel.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get genderLabel;

  /// No description provided for @selectGender.
  ///
  /// In en, this message translates to:
  /// **'Select Gender'**
  String get selectGender;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @bloodGroupLabel.
  ///
  /// In en, this message translates to:
  /// **'Blood Group'**
  String get bloodGroupLabel;

  /// No description provided for @selectBloodGroup.
  ///
  /// In en, this message translates to:
  /// **'Select Blood Group'**
  String get selectBloodGroup;

  /// No description provided for @addressLabel.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get addressLabel;

  /// No description provided for @streetFlatNo.
  ///
  /// In en, this message translates to:
  /// **'Street / Flat No.'**
  String get streetFlatNo;

  /// No description provided for @localityLabel.
  ///
  /// In en, this message translates to:
  /// **'Locality'**
  String get localityLabel;

  /// No description provided for @enterLocality.
  ///
  /// In en, this message translates to:
  /// **'Enter Locality'**
  String get enterLocality;

  /// No description provided for @cityLabel.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get cityLabel;

  /// No description provided for @enterCity.
  ///
  /// In en, this message translates to:
  /// **'Enter City'**
  String get enterCity;

  /// No description provided for @pincodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Pincode'**
  String get pincodeLabel;

  /// No description provided for @sixDigitPincode.
  ///
  /// In en, this message translates to:
  /// **'6 Digit Pincode'**
  String get sixDigitPincode;

  /// No description provided for @errorPincodeLength.
  ///
  /// In en, this message translates to:
  /// **'Pincode must be 6 digits'**
  String get errorPincodeLength;

  /// No description provided for @referenceLabel.
  ///
  /// In en, this message translates to:
  /// **'Reference'**
  String get referenceLabel;

  /// No description provided for @selectReference.
  ///
  /// In en, this message translates to:
  /// **'Select Reference'**
  String get selectReference;

  /// No description provided for @medicalHistoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Medical History'**
  String get medicalHistoryLabel;

  /// No description provided for @selectHistory.
  ///
  /// In en, this message translates to:
  /// **'Select History'**
  String get selectHistory;

  /// No description provided for @selectedSuffix.
  ///
  /// In en, this message translates to:
  /// **' Selected'**
  String get selectedSuffix;

  /// No description provided for @patientGroupsLabel.
  ///
  /// In en, this message translates to:
  /// **'Patient Groups'**
  String get patientGroupsLabel;

  /// No description provided for @selectGroups.
  ///
  /// In en, this message translates to:
  /// **'Select Groups'**
  String get selectGroups;

  /// No description provided for @profileImageLabel.
  ///
  /// In en, this message translates to:
  /// **'Profile Image'**
  String get profileImageLabel;

  /// No description provided for @selectImageBtn.
  ///
  /// In en, this message translates to:
  /// **'Select Image'**
  String get selectImageBtn;

  /// No description provided for @additionalNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Enter any additional medical history or notes here...'**
  String get additionalNotesHint;

  /// No description provided for @addPatientBtn.
  ///
  /// In en, this message translates to:
  /// **'Add Patient'**
  String get addPatientBtn;

  /// No description provided for @errorDobOrAgeReq.
  ///
  /// In en, this message translates to:
  /// **'DOB or Age is required'**
  String get errorDobOrAgeReq;

  /// No description provided for @successPatientCreated.
  ///
  /// In en, this message translates to:
  /// **'Patient created successfully'**
  String get successPatientCreated;

  /// No description provided for @selectImageSource.
  ///
  /// In en, this message translates to:
  /// **'Select Image Source'**
  String get selectImageSource;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @errorPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Permission denied'**
  String get errorPermissionDenied;

  /// No description provided for @selectOption.
  ///
  /// In en, this message translates to:
  /// **'Select Option'**
  String get selectOption;

  /// No description provided for @selectReferenceTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Reference'**
  String get selectReferenceTitle;

  /// No description provided for @referencesNotFound.
  ///
  /// In en, this message translates to:
  /// **'References Not Found'**
  String get referencesNotFound;

  /// No description provided for @selectMedicalHistory.
  ///
  /// In en, this message translates to:
  /// **'Select Medical History'**
  String get selectMedicalHistory;

  /// No description provided for @medicalHistoryNotFound.
  ///
  /// In en, this message translates to:
  /// **'Medical History Not Found'**
  String get medicalHistoryNotFound;

  /// No description provided for @addItems.
  ///
  /// In en, this message translates to:
  /// **'Add Items'**
  String get addItems;

  /// No description provided for @addSelectedItems.
  ///
  /// In en, this message translates to:
  /// **'Add {count} Selected Items'**
  String addSelectedItems(int count);

  /// No description provided for @selectPatientsGroup.
  ///
  /// In en, this message translates to:
  /// **'Select Patients Group'**
  String get selectPatientsGroup;

  /// No description provided for @patientsGroupNotFound.
  ///
  /// In en, this message translates to:
  /// **'Patients Group Not Found'**
  String get patientsGroupNotFound;

  /// No description provided for @addItemsPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Add Selected Items'**
  String get addItemsPlaceholder;

  /// No description provided for @filterPatients.
  ///
  /// In en, this message translates to:
  /// **'Filter Patients'**
  String get filterPatients;

  /// No description provided for @smartGroups.
  ///
  /// In en, this message translates to:
  /// **'Smart Groups'**
  String get smartGroups;

  /// No description provided for @allPatients.
  ///
  /// In en, this message translates to:
  /// **'All Patients'**
  String get allPatients;

  /// No description provided for @malePatients.
  ///
  /// In en, this message translates to:
  /// **'Male Patients'**
  String get malePatients;

  /// No description provided for @femalePatients.
  ///
  /// In en, this message translates to:
  /// **'Female Patients'**
  String get femalePatients;

  /// No description provided for @femalesOver30.
  ///
  /// In en, this message translates to:
  /// **'Females Over 30'**
  String get femalesOver30;

  /// No description provided for @femalesUnder30.
  ///
  /// In en, this message translates to:
  /// **'Females Under 30'**
  String get femalesUnder30;

  /// No description provided for @customGroups.
  ///
  /// In en, this message translates to:
  /// **'Custom Groups'**
  String get customGroups;

  /// No description provided for @noCustomGroups.
  ///
  /// In en, this message translates to:
  /// **'No custom groups created'**
  String get noCustomGroups;

  /// No description provided for @unnamedGroup.
  ///
  /// In en, this message translates to:
  /// **'Unnamed Group'**
  String get unnamedGroup;

  /// No description provided for @couldNotLoadGroups.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load groups'**
  String get couldNotLoadGroups;

  /// No description provided for @patientTimeline.
  ///
  /// In en, this message translates to:
  /// **'Patient\'s Timeline'**
  String get patientTimeline;

  /// No description provided for @viewProfile.
  ///
  /// In en, this message translates to:
  /// **'View Profile'**
  String get viewProfile;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @deletePatient.
  ///
  /// In en, this message translates to:
  /// **'Delete Patient'**
  String get deletePatient;

  /// No description provided for @noEmailProvided.
  ///
  /// In en, this message translates to:
  /// **'No email provided'**
  String get noEmailProvided;

  /// No description provided for @noTimelineEventsFound.
  ///
  /// In en, this message translates to:
  /// **'No timeline events found'**
  String get noTimelineEventsFound;

  /// No description provided for @errorLoadingTimeline.
  ///
  /// In en, this message translates to:
  /// **'Error loading timeline'**
  String get errorLoadingTimeline;

  /// No description provided for @addAppointment.
  ///
  /// In en, this message translates to:
  /// **'Add Appointment'**
  String get addAppointment;

  /// No description provided for @addPrescription.
  ///
  /// In en, this message translates to:
  /// **'Add Prescription'**
  String get addPrescription;

  /// No description provided for @addInvoice.
  ///
  /// In en, this message translates to:
  /// **'Add Invoice'**
  String get addInvoice;

  /// No description provided for @addFile.
  ///
  /// In en, this message translates to:
  /// **'Add File'**
  String get addFile;

  /// No description provided for @prescriptionAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Prescription added successfully'**
  String get prescriptionAddedSuccessfully;

  /// No description provided for @paymentDue.
  ///
  /// In en, this message translates to:
  /// **'Payment Due'**
  String get paymentDue;

  /// No description provided for @advanceBalance.
  ///
  /// In en, this message translates to:
  /// **'Advance Balance'**
  String get advanceBalance;

  /// No description provided for @areYouSureYouWantToDeletePatient.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this patient? This action cannot be undone.'**
  String get areYouSureYouWantToDeletePatient;

  /// No description provided for @patientDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Patient deleted successfully'**
  String get patientDeletedSuccessfully;

  /// No description provided for @errorDeletingPatient.
  ///
  /// In en, this message translates to:
  /// **'Error deleting patient. Please try again.'**
  String get errorDeletingPatient;

  /// No description provided for @errorLoadingPatientDetails.
  ///
  /// In en, this message translates to:
  /// **'Error loading patient details. Please try again.'**
  String get errorLoadingPatientDetails;

  /// No description provided for @errorLoadingPatientTimeline.
  ///
  /// In en, this message translates to:
  /// **'Error loading patient timeline. Please try again.'**
  String get errorLoadingPatientTimeline;

  /// No description provided for @invoiceDetails.
  ///
  /// In en, this message translates to:
  /// **'Invoice Details'**
  String get invoiceDetails;

  /// No description provided for @invoiceNumber.
  ///
  /// In en, this message translates to:
  /// **'Invoice Number'**
  String get invoiceNumber;

  /// No description provided for @invoiceDate.
  ///
  /// In en, this message translates to:
  /// **'Invoice Date'**
  String get invoiceDate;

  /// No description provided for @invoiceAmount.
  ///
  /// In en, this message translates to:
  /// **'Invoice Amount'**
  String get invoiceAmount;

  /// No description provided for @invoicePaid.
  ///
  /// In en, this message translates to:
  /// **'Invoice Paid'**
  String get invoicePaid;

  /// No description provided for @invoicePaidOn.
  ///
  /// In en, this message translates to:
  /// **'Invoice Paid On'**
  String get invoicePaidOn;

  /// No description provided for @patientDetails.
  ///
  /// In en, this message translates to:
  /// **'Patient Details'**
  String get patientDetails;

  /// No description provided for @patientName.
  ///
  /// In en, this message translates to:
  /// **'Patient Name'**
  String get patientName;

  /// No description provided for @patientAge.
  ///
  /// In en, this message translates to:
  /// **'Patient Age'**
  String get patientAge;

  /// No description provided for @patientGender.
  ///
  /// In en, this message translates to:
  /// **'Patient Gender'**
  String get patientGender;

  /// No description provided for @patientAddress.
  ///
  /// In en, this message translates to:
  /// **'Patient Address'**
  String get patientAddress;

  /// No description provided for @patientPhone.
  ///
  /// In en, this message translates to:
  /// **'Patient Phone'**
  String get patientPhone;

  /// No description provided for @patientEmail.
  ///
  /// In en, this message translates to:
  /// **'Patient Email'**
  String get patientEmail;

  /// No description provided for @patientBirthDate.
  ///
  /// In en, this message translates to:
  /// **'Patient Birth Date'**
  String get patientBirthDate;

  /// No description provided for @patientInsurance.
  ///
  /// In en, this message translates to:
  /// **'Patient Insurance'**
  String get patientInsurance;

  /// No description provided for @patientInsuranceNumber.
  ///
  /// In en, this message translates to:
  /// **'Patient Insurance Number'**
  String get patientInsuranceNumber;

  /// No description provided for @patientInsuranceStartDate.
  ///
  /// In en, this message translates to:
  /// **'Patient Insurance Start Date'**
  String get patientInsuranceStartDate;

  /// No description provided for @patientInsuranceEndDate.
  ///
  /// In en, this message translates to:
  /// **'Patient Insurance End Date'**
  String get patientInsuranceEndDate;

  /// No description provided for @patientInsuranceCoverage.
  ///
  /// In en, this message translates to:
  /// **'Patient Insurance Coverage'**
  String get patientInsuranceCoverage;

  /// No description provided for @addPatient.
  ///
  /// In en, this message translates to:
  /// **'Add Patient'**
  String get addPatient;

  /// No description provided for @editPatient.
  ///
  /// In en, this message translates to:
  /// **'Edit Patient'**
  String get editPatient;

  /// No description provided for @deleteInvoice.
  ///
  /// In en, this message translates to:
  /// **'Delete Invoice'**
  String get deleteInvoice;

  /// No description provided for @areYouSureYouWantToDeleteInvoice.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this invoice?'**
  String get areYouSureYouWantToDeleteInvoice;

  /// No description provided for @invoiceDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Invoice deleted successfully'**
  String get invoiceDeletedSuccessfully;

  /// No description provided for @invoiceItems.
  ///
  /// In en, this message translates to:
  /// **'Invoice Items'**
  String get invoiceItems;

  /// No description provided for @itemName.
  ///
  /// In en, this message translates to:
  /// **'Item Name'**
  String get itemName;

  /// No description provided for @itemQty.
  ///
  /// In en, this message translates to:
  /// **'Item Qty'**
  String get itemQty;

  /// No description provided for @itemCost.
  ///
  /// In en, this message translates to:
  /// **'Item Cost'**
  String get itemCost;

  /// No description provided for @itemDiscount.
  ///
  /// In en, this message translates to:
  /// **'Item Discount'**
  String get itemDiscount;

  /// No description provided for @itemDiscountType.
  ///
  /// In en, this message translates to:
  /// **'Item Discount Type'**
  String get itemDiscountType;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @discount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discount;

  /// No description provided for @discountType.
  ///
  /// In en, this message translates to:
  /// **'Discount Type'**
  String get discountType;

  /// No description provided for @collected.
  ///
  /// In en, this message translates to:
  /// **'Collected'**
  String get collected;

  /// No description provided for @balanceDue.
  ///
  /// In en, this message translates to:
  /// **'Balance Due'**
  String get balanceDue;

  /// No description provided for @billNumber.
  ///
  /// In en, this message translates to:
  /// **'Bill Number'**
  String get billNumber;

  /// No description provided for @by.
  ///
  /// In en, this message translates to:
  /// **'By'**
  String get by;

  /// No description provided for @paidAmount.
  ///
  /// In en, this message translates to:
  /// **'Paid Amount'**
  String get paidAmount;

  /// No description provided for @due.
  ///
  /// In en, this message translates to:
  /// **'Due'**
  String get due;

  /// No description provided for @collectPayment.
  ///
  /// In en, this message translates to:
  /// **'Collect Payment'**
  String get collectPayment;

  /// No description provided for @errorLoadingInvoice.
  ///
  /// In en, this message translates to:
  /// **'Error loading invoice. Please try again.'**
  String get errorLoadingInvoice;

  /// No description provided for @errorLoadingInvoiceDetails.
  ///
  /// In en, this message translates to:
  /// **'Error loading invoice details. Please try again.'**
  String get errorLoadingInvoiceDetails;

  /// No description provided for @errorLoadingInvoiceItems.
  ///
  /// In en, this message translates to:
  /// **'Error loading invoice items. Please try again.'**
  String get errorLoadingInvoiceItems;

  /// No description provided for @noInvoiceDataFound.
  ///
  /// In en, this message translates to:
  /// **'No invoice data found'**
  String get noInvoiceDataFound;

  /// No description provided for @noInvoiceItemsFound.
  ///
  /// In en, this message translates to:
  /// **'No invoice items found'**
  String get noInvoiceItemsFound;

  /// No description provided for @successInvoiceCreated.
  ///
  /// In en, this message translates to:
  /// **'Invoice created successfully'**
  String get successInvoiceCreated;

  /// No description provided for @successInvoiceUpdated.
  ///
  /// In en, this message translates to:
  /// **'Invoice updated successfully'**
  String get successInvoiceUpdated;

  /// No description provided for @errorInvoiceNotFound.
  ///
  /// In en, this message translates to:
  /// **'Invoice not found'**
  String get errorInvoiceNotFound;

  /// No description provided for @invoiceUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Invoice updated successfully'**
  String get invoiceUpdatedSuccessfully;

  /// No description provided for @invoiceCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Invoice created successfully'**
  String get invoiceCreatedSuccessfully;

  /// No description provided for @errorCreatingInvoice.
  ///
  /// In en, this message translates to:
  /// **'Error creating invoice. Please try again.'**
  String get errorCreatingInvoice;

  /// No description provided for @errorUpdatingInvoice.
  ///
  /// In en, this message translates to:
  /// **'Error updating invoice. Please try again.'**
  String get errorUpdatingInvoice;

  /// No description provided for @totalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get totalAmount;

  /// No description provided for @amountPaid.
  ///
  /// In en, this message translates to:
  /// **'Amount Paid'**
  String get amountPaid;

  /// No description provided for @amountDue.
  ///
  /// In en, this message translates to:
  /// **'Amount Due'**
  String get amountDue;

  /// No description provided for @paymentCollectedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Payment collected successfully'**
  String get paymentCollectedSuccessfully;

  /// No description provided for @errorCollectingPayment.
  ///
  /// In en, this message translates to:
  /// **'Error collecting payment. Please try again.'**
  String get errorCollectingPayment;

  /// No description provided for @errorLoadingPaymentDetails.
  ///
  /// In en, this message translates to:
  /// **'Error loading payment details. Please try again.'**
  String get errorLoadingPaymentDetails;

  /// No description provided for @noPaymentDataFound.
  ///
  /// In en, this message translates to:
  /// **'No payment data found'**
  String get noPaymentDataFound;

  /// No description provided for @successPaymentCreated.
  ///
  /// In en, this message translates to:
  /// **'Payment created successfully'**
  String get successPaymentCreated;

  /// No description provided for @successPaymentUpdated.
  ///
  /// In en, this message translates to:
  /// **'Payment updated successfully'**
  String get successPaymentUpdated;

  /// No description provided for @errorPaymentNotFound.
  ///
  /// In en, this message translates to:
  /// **'Payment not found'**
  String get errorPaymentNotFound;

  /// No description provided for @paymentUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Payment updated successfully'**
  String get paymentUpdatedSuccessfully;

  /// No description provided for @paymentCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Payment created successfully'**
  String get paymentCreatedSuccessfully;

  /// No description provided for @errorCreatingPayment.
  ///
  /// In en, this message translates to:
  /// **'Error creating payment. Please try again.'**
  String get errorCreatingPayment;

  /// No description provided for @errorUpdatingPayment.
  ///
  /// In en, this message translates to:
  /// **'Error updating payment. Please try again.'**
  String get errorUpdatingPayment;

  /// No description provided for @overallIncome.
  ///
  /// In en, this message translates to:
  /// **'Overall Income'**
  String get overallIncome;

  /// No description provided for @sevenDayIncome.
  ///
  /// In en, this message translates to:
  /// **'7-Day Income'**
  String get sevenDayIncome;

  /// No description provided for @thirtyDayIncome.
  ///
  /// In en, this message translates to:
  /// **'30-Day Income'**
  String get thirtyDayIncome;

  /// No description provided for @todayLabel.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get todayLabel;

  /// No description provided for @avgLabel.
  ///
  /// In en, this message translates to:
  /// **'Avg:'**
  String get avgLabel;

  /// No description provided for @paidLabel.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paidLabel;

  /// No description provided for @pendingLabel.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pendingLabel;

  /// No description provided for @fromDate.
  ///
  /// In en, this message translates to:
  /// **'From Date'**
  String get fromDate;

  /// No description provided for @toDate.
  ///
  /// In en, this message translates to:
  /// **'To Date'**
  String get toDate;

  /// No description provided for @financialSummary.
  ///
  /// In en, this message translates to:
  /// **'Financial Summary'**
  String get financialSummary;

  /// No description provided for @totalCost.
  ///
  /// In en, this message translates to:
  /// **'Total Cost'**
  String get totalCost;

  /// No description provided for @totalIncome.
  ///
  /// In en, this message translates to:
  /// **'Total Income'**
  String get totalIncome;

  /// No description provided for @incomeDistribution.
  ///
  /// In en, this message translates to:
  /// **'Income Distribution'**
  String get incomeDistribution;

  /// No description provided for @period.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get period;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'to'**
  String get to;

  /// No description provided for @transactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactions;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @noIncomeDataFound.
  ///
  /// In en, this message translates to:
  /// **'No Income Data Found'**
  String get noIncomeDataFound;

  /// No description provided for @paymentSummary.
  ///
  /// In en, this message translates to:
  /// **'Payment Summary'**
  String get paymentSummary;

  /// No description provided for @advancedPayments.
  ///
  /// In en, this message translates to:
  /// **'Advanced Payments'**
  String get advancedPayments;

  /// No description provided for @totalPayments.
  ///
  /// In en, this message translates to:
  /// **'Total Payments'**
  String get totalPayments;

  /// No description provided for @recentPayments.
  ///
  /// In en, this message translates to:
  /// **'Recent Payments'**
  String get recentPayments;

  /// No description provided for @paymentMode.
  ///
  /// In en, this message translates to:
  /// **'Payment Mode'**
  String get paymentMode;

  /// No description provided for @appointmentSummary.
  ///
  /// In en, this message translates to:
  /// **'Appointment Summary'**
  String get appointmentSummary;

  /// No description provided for @totalAppointments.
  ///
  /// In en, this message translates to:
  /// **'Total Appointments'**
  String get totalAppointments;

  /// No description provided for @appointmentDetails.
  ///
  /// In en, this message translates to:
  /// **'Appointment Details'**
  String get appointmentDetails;

  /// No description provided for @noAppointmentsFound.
  ///
  /// In en, this message translates to:
  /// **'No Appointments Found'**
  String get noAppointmentsFound;

  /// No description provided for @registrationSummary.
  ///
  /// In en, this message translates to:
  /// **'Registration Summary'**
  String get registrationSummary;

  /// No description provided for @totalNewPatients.
  ///
  /// In en, this message translates to:
  /// **'Total New Patients'**
  String get totalNewPatients;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phoneLabel;

  /// No description provided for @noPhone.
  ///
  /// In en, this message translates to:
  /// **'No Phone'**
  String get noPhone;

  /// No description provided for @noPatientDataFound.
  ///
  /// In en, this message translates to:
  /// **'No Patient Data Found'**
  String get noPatientDataFound;

  /// No description provided for @tryAdjustingDateRange.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your date range.'**
  String get tryAdjustingDateRange;

  /// No description provided for @outstandingBalance.
  ///
  /// In en, this message translates to:
  /// **'Outstanding Balance'**
  String get outstandingBalance;

  /// No description provided for @totalDue.
  ///
  /// In en, this message translates to:
  /// **'Total Due'**
  String get totalDue;

  /// No description provided for @patientWiseDues.
  ///
  /// In en, this message translates to:
  /// **'Patient Wise Dues'**
  String get patientWiseDues;

  /// No description provided for @noDueAmountsFound.
  ///
  /// In en, this message translates to:
  /// **'No Due Amounts Found'**
  String get noDueAmountsFound;

  /// No description provided for @reportNotFound.
  ///
  /// In en, this message translates to:
  /// **'Report Not Found'**
  String get reportNotFound;

  /// No description provided for @totalLabDues.
  ///
  /// In en, this message translates to:
  /// **'Total Lab Dues'**
  String get totalLabDues;

  /// No description provided for @pendingPayments.
  ///
  /// In en, this message translates to:
  /// **'Pending Payments'**
  String get pendingPayments;

  /// No description provided for @idLabel.
  ///
  /// In en, this message translates to:
  /// **'ID'**
  String get idLabel;

  /// No description provided for @dueLabel.
  ///
  /// In en, this message translates to:
  /// **'Due'**
  String get dueLabel;

  /// No description provided for @noLabDuesFound.
  ///
  /// In en, this message translates to:
  /// **'No Lab Dues Found'**
  String get noLabDuesFound;

  /// No description provided for @errorLoadingReports.
  ///
  /// In en, this message translates to:
  /// **'Error loading reports'**
  String get errorLoadingReports;

  /// No description provided for @fromDateShort.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get fromDateShort;

  /// No description provided for @toDateShort.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get toDateShort;

  /// No description provided for @selectBtn.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get selectBtn;

  /// No description provided for @totalReferenceCount.
  ///
  /// In en, this message translates to:
  /// **'Total Reference Count'**
  String get totalReferenceCount;

  /// No description provided for @sourceBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Source Breakdown'**
  String get sourceBreakdown;

  /// No description provided for @patientsCount.
  ///
  /// In en, this message translates to:
  /// **'Patients'**
  String get patientsCount;

  /// No description provided for @referenceDataNotFound.
  ///
  /// In en, this message translates to:
  /// **'Reference Data Not Found'**
  String get referenceDataNotFound;

  /// No description provided for @noRecordsFound.
  ///
  /// In en, this message translates to:
  /// **'No Records Found'**
  String get noRecordsFound;

  /// No description provided for @usageSummary.
  ///
  /// In en, this message translates to:
  /// **'Usage Summary'**
  String get usageSummary;

  /// No description provided for @totalMaterials.
  ///
  /// In en, this message translates to:
  /// **'Total Materials'**
  String get totalMaterials;

  /// No description provided for @proceduresConducted.
  ///
  /// In en, this message translates to:
  /// **'Procedures Conducted'**
  String get proceduresConducted;

  /// No description provided for @materialInventoryBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Material Inventory Breakdown'**
  String get materialInventoryBreakdown;

  /// No description provided for @quantityUsed.
  ///
  /// In en, this message translates to:
  /// **'Quantity Used'**
  String get quantityUsed;

  /// No description provided for @noMaterialUsageData.
  ///
  /// In en, this message translates to:
  /// **'No Material Usage Data'**
  String get noMaterialUsageData;

  /// No description provided for @trySelectingDifferentDateRange.
  ///
  /// In en, this message translates to:
  /// **'Try selecting a different date range.'**
  String get trySelectingDifferentDateRange;
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
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
