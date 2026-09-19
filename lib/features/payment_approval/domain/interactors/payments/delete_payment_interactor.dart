import 'package:fvelox/core/errors/app_failure.dart';
import 'package:fvelox/features/payment_approval/domain/app_state/payments/delete_payment_state.dart';
import 'package:fvelox/features/payment_approval/domain/repositories/payment_repository.dart';

final class DeletePaymentInteractor {
  const DeletePaymentInteractor(this._repository);

  final PaymentRepository _repository;

  Stream<DeletePaymentState> execute(String paymentId) async* {
    yield const DeletePaymentState.loading();
    try {
      await _repository.deletePayment(paymentId);
      yield DeletePaymentState.success(paymentId);
    } catch (error, stackTrace) {
      yield DeletePaymentState.failure(
        _toFailure(error),
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }

  AppFailure _toFailure(Object error) =>
      error is AppFailure ? error : const NetworkFailure();
}
