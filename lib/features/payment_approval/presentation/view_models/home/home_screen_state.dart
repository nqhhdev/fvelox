import 'package:fvelox/core/errors/app_failure.dart';
import 'package:fvelox/features/payment_approval/domain/entities/payment.dart';
import 'package:fvelox/features/payment_approval/domain/entities/payment_summary.dart';

final class HomeScreenState {
  const HomeScreenState({
    this.summary,
    this.recentPayments = const [],
    this.isLoading = true,
    this.isRefreshing = false,
    this.hasStartedLoading = false,
    this.isDeleting = false,
    this.failure,
  });

  final PaymentSummary? summary;
  final List<Payment> recentPayments;

  /// True only while the first screen read is in progress.
  final bool isLoading;

  /// True while a later refresh keeps the current content on screen.
  final bool isRefreshing;
  final bool hasStartedLoading;
  final bool isDeleting;
  final AppFailure? failure;

  HomeScreenState copyWith({
    PaymentSummary? summary,
    List<Payment>? recentPayments,
    bool? isLoading,
    bool? isRefreshing,
    bool? hasStartedLoading,
    bool? isDeleting,
    AppFailure? failure,
    bool clearFailure = false,
  }) => HomeScreenState(
    summary: summary ?? this.summary,
    recentPayments: recentPayments ?? this.recentPayments,
    isLoading: isLoading ?? this.isLoading,
    isRefreshing: isRefreshing ?? this.isRefreshing,
    hasStartedLoading: hasStartedLoading ?? this.hasStartedLoading,
    isDeleting: isDeleting ?? this.isDeleting,
    failure: clearFailure ? null : failure ?? this.failure,
  );
}
