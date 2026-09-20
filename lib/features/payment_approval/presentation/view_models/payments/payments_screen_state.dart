import 'package:fvelox/core/errors/app_failure.dart';
import 'package:fvelox/features/payment_approval/domain/entities/payment.dart';

final class PaymentsScreenState {
  const PaymentsScreenState({
    this.payments = const [],
    this.isLoading = true,
    this.isRefreshing = false,
    this.hasStartedLoading = false,
    this.isDeleting = false,
    this.failure,
  });

  final List<Payment> payments;

  /// True only while the first screen read is in progress.
  final bool isLoading;

  /// True while a later refresh keeps the current list on screen.
  final bool isRefreshing;
  final bool hasStartedLoading;
  final bool isDeleting;
  final AppFailure? failure;

  PaymentsScreenState copyWith({
    List<Payment>? payments,
    bool? isLoading,
    bool? isRefreshing,
    bool? hasStartedLoading,
    bool? isDeleting,
    AppFailure? failure,
    bool clearFailure = false,
  }) => PaymentsScreenState(
    payments: payments ?? this.payments,
    isLoading: isLoading ?? this.isLoading,
    isRefreshing: isRefreshing ?? this.isRefreshing,
    hasStartedLoading: hasStartedLoading ?? this.hasStartedLoading,
    isDeleting: isDeleting ?? this.isDeleting,
    failure: clearFailure ? null : failure ?? this.failure,
  );
}
