import 'package:fvelox/core/errors/app_failure.dart';
import 'package:fvelox/features/payment_approval/domain/app_state/payments/get_payment_details_state.dart';
import 'package:fvelox/features/payment_approval/domain/repositories/payment_repository.dart';

final class GetPaymentDetailsInteractor {
  const GetPaymentDetailsInteractor(this._repository);

  final PaymentRepository _repository;

  Stream<GetPaymentDetailsState> execute(String id) async* {
    yield const GetPaymentDetailsState.loading();
    try {
      final payment = await _repository.getPayment(id);
      yield GetPaymentDetailsState.success(payment);
    } catch (error, stackTrace) {
      yield GetPaymentDetailsState.failure(
        _toFailure(error),
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }

  AppFailure _toFailure(Object error) =>
      error is AppFailure ? error : const NetworkFailure();
}
