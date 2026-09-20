// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'fvelox_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class FveloxLocalizationsEn extends FveloxLocalizations {
  FveloxLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'fvelox';

  @override
  String get brandName => 'fvelox';

  @override
  String get homeTab => 'Home';

  @override
  String get paymentsTab => 'Payments';

  @override
  String get profileName => 'Boss';

  @override
  String get profileInitials => 'BO';

  @override
  String get createIncomingPaymentRequest => 'Create incoming payment request';

  @override
  String get offlineCachedPayments => 'Offline — showing cached payments';

  @override
  String get retry => 'Retry';

  @override
  String get loading => 'Loading';

  @override
  String get greetingMorning => 'Good morning';

  @override
  String get greetingAfternoon => 'Good afternoon';

  @override
  String get greetingEvening => 'Good evening';

  @override
  String greeting(Object greeting, Object name) {
    return '$greeting, $name.';
  }

  @override
  String get paymentSubtitle => 'Your payments, with composure.';

  @override
  String get recentActivity => 'Recent activity';

  @override
  String get seeAll => 'See all';

  @override
  String get approvedThisMonth => 'Approved this month';

  @override
  String paymentCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count payments',
      one: '1 payment',
      zero: '0 payments',
    );
    return '$_temp0';
  }

  @override
  String get allDecidedPayments => 'All decided payments';

  @override
  String get noDecidedPayments => 'No decided payments yet.';

  @override
  String get approved => 'Approved';

  @override
  String get rejected => 'Rejected';

  @override
  String get paymentDetails => 'Payment details';

  @override
  String backTo(Object destination) {
    return 'Back to $destination';
  }

  @override
  String get date => 'Date';

  @override
  String get reference => 'Reference';

  @override
  String get note => 'Note';

  @override
  String get incomingRequest => 'Incoming request';

  @override
  String get reviewBeforeDecide => 'Review before you decide.';

  @override
  String incomingRequestDetails(Object reference) {
    return 'From: ••••••••••\nAmount: AED ••••••\nReference: $reference';
  }

  @override
  String get reject => 'Reject';

  @override
  String get approve => 'Approve';

  @override
  String get cancelRequest => 'Cancel';

  @override
  String get changeDecision => 'Change decision';

  @override
  String get confirmAction => 'Confirm action';

  @override
  String get approvePayment => 'Approve payment';

  @override
  String get rejectPayment => 'Reject payment';

  @override
  String get verificationCodePrompt =>
      'Enter the 4-digit verification code to continue.';

  @override
  String get otpHint => '••••';

  @override
  String get confirm => 'Confirm';

  @override
  String get unavailableOffline => 'Unavailable offline';

  @override
  String get unableCreatePaymentRequest =>
      'Unable to create a payment request.';

  @override
  String get paymentApprovalUnavailable => 'Payment approval is unavailable.';

  @override
  String get unableLoadPaymentDetails => 'Unable to load payment details.';

  @override
  String get genericError => 'Something went wrong. Please try again.';

  @override
  String get invalidOtp => 'That code is not valid. Please try again.';

  @override
  String get wrongCodeDemo => 'Wrong code. Use 8888 for demo.';

  @override
  String get networkError => 'A network error occurred.';

  @override
  String get localStorageUnavailable => 'Local storage is unavailable.';

  @override
  String get paymentNotFound => 'Payment not found.';

  @override
  String get paymentNotDecided => 'This payment is still waiting for approval.';

  @override
  String get paymentAlreadyDecided => 'This payment was already decided.';

  @override
  String get invalidPaymentRequest => 'Invalid payment request.';

  @override
  String get invalidServerResponse =>
      'The server returned an invalid response.';

  @override
  String get offlineCreateRequest =>
      'You are offline. Creating a payment request requires a connection.';

  @override
  String get offlineDecision =>
      'You are offline. Approving or rejecting requires a connection.';

  @override
  String get offlineDeletePayment =>
      'You are offline. Deleting a payment requires a connection.';

  @override
  String get paymentApprovedSuccess => 'Payment approved successfully.';

  @override
  String get paymentRejectedSuccess => 'Payment rejected successfully.';

  @override
  String get paymentDeletedSuccess => 'Payment removed.';

  @override
  String get unableDeletePayment => 'Unable to remove this payment.';

  @override
  String get deletePayment => 'Delete payment';

  @override
  String amountAed(Object amount) {
    return 'AED $amount';
  }
}
