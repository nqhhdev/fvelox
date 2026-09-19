import 'package:fvelox/core/errors/app_failure.dart';
import 'package:fvelox/features/payment_approval/domain/app_state/shared/interactor_state_status.dart';

final class DeletePaymentState {
  const DeletePaymentState({
    this.status = InteractorStateStatus.initial,
    this.deletedPaymentId,
    this.failure,
    this.cause,
    this.stackTrace,
  });

  const DeletePaymentState.initial() : this();

  const DeletePaymentState.loading()
    : this(status: InteractorStateStatus.loading);

  const DeletePaymentState.success(String paymentId)
    : this(status: InteractorStateStatus.success, deletedPaymentId: paymentId);

  const DeletePaymentState.failure(
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
  final String? deletedPaymentId;
  final AppFailure? failure;
  final Object? cause;
  final StackTrace? stackTrace;

  bool get isSuccess => status == InteractorStateStatus.success;
  bool get isFailure => status == InteractorStateStatus.failure;
}
