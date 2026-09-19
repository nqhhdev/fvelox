import 'package:fvelox/core/errors/app_failure.dart';
import 'package:fvelox/features/payment_approval/domain/app_state/approval/decide_payment_state.dart';
import 'package:fvelox/features/payment_approval/domain/entities/payment.dart';
import 'package:fvelox/features/payment_approval/domain/repositories/payment_repository.dart';

final class DecidePaymentInteractor {
  const DecidePaymentInteractor(this._repository);

  final PaymentRepository _repository;

  Stream<DecidePaymentState> execute({
    required Payment payment,
    required PaymentStatus status,
    required String otp,
  }) async* {
    yield const DecidePaymentState.loading();
    try {
      final decidedPayment = await _repository.decidePayment(
        payment,
        status,
        otp,
      );
      yield DecidePaymentState.success(decidedPayment);
    } catch (error, stackTrace) {
      yield DecidePaymentState.failure(
        _toFailure(error),
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }

  AppFailure _toFailure(Object error) =>
      error is AppFailure ? error : const NetworkFailure();
}
