import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'fvelox_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of FveloxLocalizations
/// returned by `FveloxLocalizations.of(context)`.
///
/// Applications need to include `FveloxLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/fvelox_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: FveloxLocalizations.localizationsDelegates,
///   supportedLocales: FveloxLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the FveloxLocalizations.supportedLocales
/// property.
abstract class FveloxLocalizations {
  FveloxLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static FveloxLocalizations? of(BuildContext context) {
    return Localizations.of<FveloxLocalizations>(context, FveloxLocalizations);
  }

  static const LocalizationsDelegate<FveloxLocalizations> delegate =
      _FveloxLocalizationsDelegate();

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

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'fvelox'**
  String get appTitle;

  /// No description provided for @brandName.
  ///
  /// In en, this message translates to:
  /// **'fvelox'**
  String get brandName;

  /// No description provided for @homeTab.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTab;

  /// No description provided for @paymentsTab.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get paymentsTab;

  /// No description provided for @profileName.
  ///
  /// In en, this message translates to:
  /// **'Boss'**
  String get profileName;

  /// No description provided for @profileInitials.
  ///
  /// In en, this message translates to:
  /// **'BO'**
  String get profileInitials;

  /// No description provided for @createIncomingPaymentRequest.
  ///
  /// In en, this message translates to:
  /// **'Create incoming payment request'**
  String get createIncomingPaymentRequest;

  /// No description provided for @offlineCachedPayments.
  ///
  /// In en, this message translates to:
  /// **'Offline — showing cached payments'**
  String get offlineCachedPayments;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// No description provided for @greetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get greetingMorning;

  /// No description provided for @greetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get greetingAfternoon;

  /// No description provided for @greetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get greetingEvening;

  /// No description provided for @greeting.
  ///
  /// In en, this message translates to:
  /// **'{greeting}, {name}.'**
  String greeting(Object greeting, Object name);

  /// No description provided for @paymentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your payments, with composure.'**
  String get paymentSubtitle;

  /// No description provided for @recentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent activity'**
  String get recentActivity;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @approvedThisMonth.
  ///
  /// In en, this message translates to:
  /// **'Approved this month'**
  String get approvedThisMonth;

  /// No description provided for @paymentCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0 {0 payments} =1 {1 payment} other {{count} payments}}'**
  String paymentCount(int count);

  /// No description provided for @allDecidedPayments.
  ///
  /// In en, this message translates to:
  /// **'All decided payments'**
  String get allDecidedPayments;

  /// No description provided for @noDecidedPayments.
  ///
  /// In en, this message translates to:
  /// **'No decided payments yet.'**
  String get noDecidedPayments;

  /// No description provided for @approved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get approved;

  /// No description provided for @rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejected;

  /// No description provided for @paymentDetails.
  ///
  /// In en, this message translates to:
  /// **'Payment details'**
  String get paymentDetails;

  /// No description provided for @backTo.
  ///
  /// In en, this message translates to:
  /// **'Back to {destination}'**
  String backTo(Object destination);

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @reference.
  ///
  /// In en, this message translates to:
  /// **'Reference'**
  String get reference;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @incomingRequest.
  ///
  /// In en, this message translates to:
  /// **'Incoming request'**
  String get incomingRequest;

  /// No description provided for @reviewBeforeDecide.
  ///
  /// In en, this message translates to:
  /// **'Review before you decide.'**
  String get reviewBeforeDecide;

  /// No description provided for @incomingRequestDetails.
  ///
  /// In en, this message translates to:
  /// **'From: ••••••••••\nAmount: AED ••••••\nReference: {reference}'**
  String incomingRequestDetails(Object reference);

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @approve.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get approve;

  /// No description provided for @cancelRequest.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelRequest;

  /// No description provided for @changeDecision.
  ///
  /// In en, this message translates to:
  /// **'Change decision'**
  String get changeDecision;

  /// No description provided for @confirmAction.
  ///
  /// In en, this message translates to:
  /// **'Confirm action'**
  String get confirmAction;

  /// No description provided for @approvePayment.
  ///
  /// In en, this message translates to:
  /// **'Approve payment'**
  String get approvePayment;

  /// No description provided for @rejectPayment.
  ///
  /// In en, this message translates to:
  /// **'Reject payment'**
  String get rejectPayment;

  /// No description provided for @verificationCodePrompt.
  ///
  /// In en, this message translates to:
  /// **'Enter the 4-digit verification code to continue.'**
  String get verificationCodePrompt;

  /// No description provided for @otpHint.
  ///
  /// In en, this message translates to:
  /// **'••••'**
  String get otpHint;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @unavailableOffline.
  ///
  /// In en, this message translates to:
  /// **'Unavailable offline'**
  String get unavailableOffline;

  /// No description provided for @unableCreatePaymentRequest.
  ///
  /// In en, this message translates to:
  /// **'Unable to create a payment request.'**
  String get unableCreatePaymentRequest;

  /// No description provided for @paymentApprovalUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Payment approval is unavailable.'**
  String get paymentApprovalUnavailable;

  /// No description provided for @unableLoadPaymentDetails.
  ///
  /// In en, this message translates to:
  /// **'Unable to load payment details.'**
  String get unableLoadPaymentDetails;

  /// No description provided for @genericError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get genericError;

  /// No description provided for @invalidOtp.
  ///
  /// In en, this message translates to:
  /// **'That code is not valid. Please try again.'**
  String get invalidOtp;

  /// No description provided for @wrongCodeDemo.
  ///
  /// In en, this message translates to:
  /// **'Wrong code. Use 8888 for demo.'**
  String get wrongCodeDemo;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'A network error occurred.'**
  String get networkError;

  /// No description provided for @localStorageUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Local storage is unavailable.'**
  String get localStorageUnavailable;

  /// No description provided for @paymentNotFound.
  ///
  /// In en, this message translates to:
  /// **'Payment not found.'**
  String get paymentNotFound;

  /// No description provided for @paymentNotDecided.
  ///
  /// In en, this message translates to:
  /// **'This payment is still waiting for approval.'**
  String get paymentNotDecided;

  /// No description provided for @paymentAlreadyDecided.
  ///
  /// In en, this message translates to:
  /// **'This payment was already decided.'**
  String get paymentAlreadyDecided;

  /// No description provided for @invalidPaymentRequest.
  ///
  /// In en, this message translates to:
  /// **'Invalid payment request.'**
  String get invalidPaymentRequest;

  /// No description provided for @invalidServerResponse.
  ///
  /// In en, this message translates to:
  /// **'The server returned an invalid response.'**
  String get invalidServerResponse;

  /// No description provided for @offlineCreateRequest.
  ///
  /// In en, this message translates to:
  /// **'You are offline. Creating a payment request requires a connection.'**
  String get offlineCreateRequest;

  /// No description provided for @offlineDecision.
  ///
  /// In en, this message translates to:
  /// **'You are offline. Approving or rejecting requires a connection.'**
  String get offlineDecision;

  /// No description provided for @offlineDeletePayment.
  ///
  /// In en, this message translates to:
  /// **'You are offline. Deleting a payment requires a connection.'**
  String get offlineDeletePayment;

  /// No description provided for @paymentApprovedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Payment approved successfully.'**
  String get paymentApprovedSuccess;

  /// No description provided for @paymentRejectedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Payment rejected successfully.'**
  String get paymentRejectedSuccess;

  /// No description provided for @paymentDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Payment removed.'**
  String get paymentDeletedSuccess;

  /// No description provided for @unableDeletePayment.
  ///
  /// In en, this message translates to:
  /// **'Unable to remove this payment.'**
  String get unableDeletePayment;

  /// No description provided for @deletePayment.
  ///
  /// In en, this message translates to:
  /// **'Delete payment'**
  String get deletePayment;

  /// No description provided for @amountAed.
  ///
  /// In en, this message translates to:
  /// **'AED {amount}'**
  String amountAed(Object amount);
}

class _FveloxLocalizationsDelegate
    extends LocalizationsDelegate<FveloxLocalizations> {
  const _FveloxLocalizationsDelegate();

  @override
  Future<FveloxLocalizations> load(Locale locale) {
    return SynchronousFuture<FveloxLocalizations>(
      lookupFveloxLocalizations(locale),
    );
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_FveloxLocalizationsDelegate old) => false;
}

FveloxLocalizations lookupFveloxLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return FveloxLocalizationsEn();
  }

  throw FlutterError(
    'FveloxLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
