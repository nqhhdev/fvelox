import 'package:fvelox/core/errors/app_failure.dart';
import 'package:fvelox/features/payment_approval/domain/entities/payment.dart';
import 'package:fvelox/features/payment_approval/domain/app_state/shared/interactor_state_status.dart';

final class GetDecidedPaymentsState {
  const GetDecidedPaymentsState({
    this.status = InteractorStateStatus.initial,
    this.payments = const [],
    this.failure,
    this.cause,
    this.stackTrace,
  });

  const GetDecidedPaymentsState.initial() : this();

  const GetDecidedPaymentsState.loading()
    : this(status: InteractorStateStatus.loading);

  const GetDecidedPaymentsState.success(List<Payment> payments)
    : this(status: InteractorStateStatus.success, payments: payments);

  const GetDecidedPaymentsState.failure(
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
  final List<Payment> payments;
  final AppFailure? failure;
  final Object? cause;
  final StackTrace? stackTrace;

  bool get isSuccess => status == InteractorStateStatus.success;
  bool get isFailure => status == InteractorStateStatus.failure;
}
