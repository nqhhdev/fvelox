import 'package:flutter_test/flutter_test.dart';

import 'package:fvelox/features/payment_approval/domain/entities/payment.dart';
import 'package:fvelox/features/payment_approval/presentation/view_models/approval/payment_approval_ui_controller.dart';

void main() {
  late PaymentApprovalUiController controller;

  setUp(() => controller = PaymentApprovalUiController());
  tearDown(() => controller.dispose());

  test('keeps approval form state independent from domain state', () {
    controller.beginFlow();
    controller.selectDecision(PaymentStatus.approved);
    controller.changeOtp('8888');

    expect(controller.state.decision, PaymentStatus.approved);
    expect(controller.state.otp, '8888');
    expect(controller.state.isFlowOpen, isTrue);
  });

  test('resets OTP state when returning to the review step', () {
    controller.selectDecision(PaymentStatus.rejected);
    controller.changeOtp('1234');
    final versionBeforeReset = controller.state.otpFieldVersion;

    controller.backToReview();

    expect(controller.state.decision, isNull);
    expect(controller.state.otp, isEmpty);
    expect(controller.state.otpFieldVersion, versionBeforeReset + 1);
  });

  test('keeps submit loading in UI state until the sheet closes', () {
    controller.beginFlow();
    controller.selectDecision(PaymentStatus.approved);

    controller.beginSubmit();
    expect(controller.state.isSubmitting, isTrue);

    controller.endSubmit();
    expect(controller.state.isSubmitting, isFalse);
  });

  test('keeps the submitted form stable while the sheet closes', () {
    controller.beginFlow();
    controller.selectDecision(PaymentStatus.rejected);
    controller.changeOtp('8888');
    controller.beginSubmit();

    controller.endFlow();

    expect(controller.state.decision, PaymentStatus.rejected);
    expect(controller.state.otp, '8888');
    expect(controller.state.isSubmitting, isFalse);
    expect(controller.state.isFlowOpen, isFalse);
  });
}
