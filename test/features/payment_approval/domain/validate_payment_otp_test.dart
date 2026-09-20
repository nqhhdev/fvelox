import 'package:flutter_test/flutter_test.dart';

import 'package:fvelox/features/payment_approval/domain/interactors/approval/validate_payment_otp_interactor.dart';

void main() {
  const validatePaymentOtp = ValidatePaymentOtpInteractor();

  test('accepts the demo OTP', () async {
    final state = await validatePaymentOtp.execute('8888').last;

    expect(state.isSuccess, isTrue);
    expect(state.isValid, isTrue);
  });

  test('rejects an invalid OTP', () async {
    final state = await validatePaymentOtp.execute('1234').last;

    expect(state.isFailure, isTrue);
    expect(state.failure?.code, 'invalid_otp');
  });
}
