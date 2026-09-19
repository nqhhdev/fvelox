import 'package:fvelox/core/errors/app_failure.dart';
import 'package:fvelox/features/payment_approval/domain/app_state/payments/delete_payments_state.dart';
import 'package:fvelox/features/payment_approval/domain/repositories/payment_repository.dart';

final class DeletePaymentsInteractor {
  const DeletePaymentsInteractor(this._repository);

  final PaymentRepository _repository;

  Stream<DeletePaymentsState> execute(List<String> paymentIds) async* {
    yield const DeletePaymentsState.loading();
    try {
      final deletedCount = await _repository.deletePayments(paymentIds);
      yield DeletePaymentsState.success(deletedCount);
    } catch (error, stackTrace) {
      yield DeletePaymentsState.failure(
        _toFailure(error),
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }

  AppFailure _toFailure(Object error) =>
      error is AppFailure ? error : const NetworkFailure();
}
