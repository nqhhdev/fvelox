import 'package:fvelox/features/payment_approval/domain/entities/payment.dart';

final class PaymentApprovalUiState {
  const PaymentApprovalUiState({
    this.decision,
    this.otp = '',
    this.error,
    this.otpFieldVersion = 0,
    this.isFlowOpen = false,
    this.isSubmitting = false,
  });

  final PaymentStatus? decision;
  final String otp;
  final String? error;
  final int otpFieldVersion;
  final bool isFlowOpen;
  final bool isSubmitting;

  PaymentApprovalUiState copyWith({
    PaymentStatus? decision,
    String? otp,
    String? error,
    int? otpFieldVersion,
    bool? isFlowOpen,
    bool? isSubmitting,
    bool clearDecision = false,
    bool clearError = false,
  }) => PaymentApprovalUiState(
    decision: clearDecision ? null : decision ?? this.decision,
    otp: otp ?? this.otp,
    error: clearError ? null : error ?? this.error,
    otpFieldVersion: otpFieldVersion ?? this.otpFieldVersion,
    isFlowOpen: isFlowOpen ?? this.isFlowOpen,
    isSubmitting: isSubmitting ?? this.isSubmitting,
  );
}
