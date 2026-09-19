import 'package:fvelox/core/errors/app_failure.dart';
import 'package:fvelox/features/payment_approval/domain/app_state/payments/get_decided_payments_state.dart';
import 'package:fvelox/features/payment_approval/domain/repositories/payment_repository.dart';

final class GetDecidedPaymentsInteractor {
  const GetDecidedPaymentsInteractor(this._repository);

  final PaymentRepository _repository;

  Stream<GetDecidedPaymentsState> execute() async* {
    yield const GetDecidedPaymentsState.loading();
    try {
      final payments = await _repository.getDecidedPayments();
      yield GetDecidedPaymentsState.success(payments);
    } catch (error, stackTrace) {
      yield GetDecidedPaymentsState.failure(
        _toFailure(error),
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }

  AppFailure _toFailure(Object error) =>
      error is AppFailure ? error : const NetworkFailure();
}
