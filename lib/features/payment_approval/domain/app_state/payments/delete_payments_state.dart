import 'package:fvelox/core/errors/app_failure.dart';
import 'package:fvelox/features/payment_approval/domain/app_state/shared/interactor_state_status.dart';

final class DeletePaymentsState {
  const DeletePaymentsState({
    this.status = InteractorStateStatus.initial,
    this.deletedCount = 0,
    this.failure,
    this.cause,
    this.stackTrace,
  });

  const DeletePaymentsState.initial() : this();

  const DeletePaymentsState.loading()
    : this(status: InteractorStateStatus.loading);

  const DeletePaymentsState.success(int count)
    : this(status: InteractorStateStatus.success, deletedCount: count);

  const DeletePaymentsState.failure(
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
  final int deletedCount;
  final AppFailure? failure;
  final Object? cause;
  final StackTrace? stackTrace;

  bool get isSuccess => status == InteractorStateStatus.success;
  bool get isFailure => status == InteractorStateStatus.failure;
}
