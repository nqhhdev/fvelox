import 'package:fvelox/core/errors/app_failure.dart';
import 'package:fvelox/l10n/generated/fvelox_localizations.dart';

extension AppFailureLocalization on AppFailure {
  String toLocalizedMessage(FveloxLocalizations l10n) => switch (this) {
    NetworkFailure(code: 'offline_create_request') => l10n.offlineCreateRequest,
    NetworkFailure(code: 'offline_decision') => l10n.offlineDecision,
    NetworkFailure(code: 'offline_delete_payment') => l10n.offlineDeletePayment,
    NetworkFailure() => l10n.networkError,
    LocalStorageFailure() => l10n.localStorageUnavailable,
    PaymentApiFailure(code: 'invalid_otp') => l10n.invalidOtp,
    PaymentApiFailure(code: 'payment_already_decided') =>
      l10n.paymentAlreadyDecided,
    PaymentApiFailure(code: 'payment_not_decided') => l10n.paymentNotDecided,
    PaymentApiFailure(code: 'payment_not_found') => l10n.paymentNotFound,
    PaymentApiFailure(code: 'payment_feature_disabled') =>
      l10n.paymentApprovalUnavailable,
    PaymentApiFailure(code: 'invalid_month' || 'invalid_id' || 'invalid_ids') =>
      l10n.invalidPaymentRequest,
    PaymentApiFailure(code: 'invalid_response') => l10n.invalidServerResponse,
    PaymentApiFailure(message: final message) when message.isNotEmpty =>
      message,
    PaymentApiFailure() => l10n.genericError,
    AppFailure() => l10n.genericError,
  };
}
