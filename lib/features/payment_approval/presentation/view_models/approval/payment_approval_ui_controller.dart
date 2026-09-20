import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fvelox/features/payment_approval/domain/entities/payment.dart';
import 'package:fvelox/features/payment_approval/presentation/view_models/approval/payment_approval_ui_state.dart';

/// UI-only approval sheet state. Wired via `paymentApprovalUiControllerProvider`.
final class PaymentApprovalUiController
    extends StateNotifier<PaymentApprovalUiState> {
  PaymentApprovalUiController() : super(const PaymentApprovalUiState());

  void beginFlow() {
    state = state.copyWith(
      isFlowOpen: true,
      clearDecision: true,
      clearError: true,
      otp: '',
      otpFieldVersion: state.otpFieldVersion + 1,
      isSubmitting: false,
    );
  }

  void endFlow() {
    state = state.copyWith(isFlowOpen: false, isSubmitting: false);
  }

  void beginSubmit() {
    state = state.copyWith(isSubmitting: true, clearError: true);
  }

  void endSubmit() {
    state = state.copyWith(isSubmitting: false);
  }

  void selectDecision(PaymentStatus decision) {
    state = state.copyWith(
      decision: decision,
      clearError: true,
      otp: '',
      otpFieldVersion: state.otpFieldVersion + 1,
    );
  }

  void changeOtp(String otp) {
    state = state.copyWith(otp: otp, clearError: true);
  }

  void backToReview() {
    state = state.copyWith(
      clearDecision: true,
      clearError: true,
      otp: '',
      otpFieldVersion: state.otpFieldVersion + 1,
      isSubmitting: false,
    );
  }

  void setError(String message) {
    state = state.copyWith(
      error: message,
      otp: '',
      otpFieldVersion: state.otpFieldVersion + 1,
    );
  }
}
