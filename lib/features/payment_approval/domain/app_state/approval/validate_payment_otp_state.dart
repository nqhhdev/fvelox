import 'package:fvelox/core/errors/app_failure.dart';
import 'package:fvelox/features/payment_approval/domain/app_state/shared/interactor_state_status.dart';

final class ValidatePaymentOtpState {
  const ValidatePaymentOtpState({
    this.status = InteractorStateStatus.initial,
    this.isValid = false,
    this.failure,
    this.cause,
    this.stackTrace,
  });

  const ValidatePaymentOtpState.initial() : this();

  const ValidatePaymentOtpState.loading()
    : this(status: InteractorStateStatus.loading);

  const ValidatePaymentOtpState.success()
    : this(status: InteractorStateStatus.success, isValid: true);

  const ValidatePaymentOtpState.failure(
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
  final bool isValid;
  final AppFailure? failure;
  final Object? cause;
  final StackTrace? stackTrace;

  bool get isSuccess => status == InteractorStateStatus.success;
  bool get isFailure => status == InteractorStateStatus.failure;
}
