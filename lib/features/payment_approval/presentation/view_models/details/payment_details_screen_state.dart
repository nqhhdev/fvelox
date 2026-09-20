import 'package:fvelox/core/errors/app_failure.dart';
import 'package:fvelox/features/payment_approval/domain/entities/payment.dart';

final class PaymentDetailsScreenState {
  const PaymentDetailsScreenState({
    this.payment,
    this.isLoading = false,
    this.failure,
  });

  final Payment? payment;
  final bool isLoading;
  final AppFailure? failure;

  PaymentDetailsScreenState copyWith({
    Payment? payment,
    bool? isLoading,
    AppFailure? failure,
    bool clearFailure = false,
  }) => PaymentDetailsScreenState(
    payment: payment ?? this.payment,
    isLoading: isLoading ?? this.isLoading,
    failure: clearFailure ? null : failure ?? this.failure,
  );
}
