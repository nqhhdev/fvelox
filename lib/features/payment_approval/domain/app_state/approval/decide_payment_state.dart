import 'package:fvelox/core/errors/app_failure.dart';
import 'package:fvelox/features/payment_approval/domain/entities/payment.dart';
import 'package:fvelox/features/payment_approval/domain/app_state/shared/interactor_state_status.dart';

final class DecidePaymentState {
  const DecidePaymentState({
    this.status = InteractorStateStatus.initial,
    this.payment,
    this.failure,
    this.cause,
    this.stackTrace,
  });

  const DecidePaymentState.initial() : this();

  const DecidePaymentState.loading()
    : this(status: InteractorStateStatus.loading);

  const DecidePaymentState.success(Payment payment)
    : this(status: InteractorStateStatus.success, payment: payment);

  const DecidePaymentState.failure(
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
  final Payment? payment;
  final AppFailure? failure;
  final Object? cause;
  final StackTrace? stackTrace;

  bool get isSuccess => status == InteractorStateStatus.success;
  bool get isFailure => status == InteractorStateStatus.failure;
}
