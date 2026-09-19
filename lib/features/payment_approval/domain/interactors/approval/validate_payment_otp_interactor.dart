import 'package:fvelox/core/errors/app_failure.dart';
import 'package:fvelox/features/payment_approval/domain/app_state/approval/validate_payment_otp_state.dart';

final class ValidatePaymentOtpInteractor {
  const ValidatePaymentOtpInteractor();

  Stream<ValidatePaymentOtpState> execute(String otp) async* {
    yield const ValidatePaymentOtpState.loading();
    try {
      if (otp == '8888') {
        yield const ValidatePaymentOtpState.success();
        return;
      }
      yield ValidatePaymentOtpState.failure(
        const PaymentApiFailure(code: 'invalid_otp'),
      );
    } catch (error, stackTrace) {
      yield ValidatePaymentOtpState.failure(
        error is AppFailure ? error : const NetworkFailure(),
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }
}
