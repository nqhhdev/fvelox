import 'package:fvelox/core/errors/app_failure.dart';
import 'package:fvelox/features/payment_approval/domain/entities/payment_summary.dart';
import 'package:fvelox/features/payment_approval/domain/app_state/shared/interactor_state_status.dart';

final class GetPaymentSummaryState {
  const GetPaymentSummaryState({
    this.status = InteractorStateStatus.initial,
    this.summary,
    this.failure,
    this.cause,
    this.stackTrace,
  });

  const GetPaymentSummaryState.initial() : this();

  const GetPaymentSummaryState.loading()
    : this(status: InteractorStateStatus.loading);

  const GetPaymentSummaryState.success(PaymentSummary summary)
    : this(status: InteractorStateStatus.success, summary: summary);

  const GetPaymentSummaryState.failure(
    AppFailure failure, {
    Object? cause,
    StackTrace? stackTrace,
  }) : this(
         status: InteractorStateStatus.failure,
         failure: failure,
         cause: cause,
         stackTrace: stackTrace,
       );

  final InteractorStateStatus status;
  final PaymentSummary? summary;
  final AppFailure? failure;
  final Object? cause;
  final StackTrace? stackTrace;

  bool get isSuccess => status == InteractorStateStatus.success;
  bool get isFailure => status == InteractorStateStatus.failure;
}
