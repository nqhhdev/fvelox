import 'package:fvelox/core/errors/app_failure.dart';
import 'package:fvelox/features/payment_approval/domain/app_state/home/get_payment_summary_state.dart';
import 'package:fvelox/features/payment_approval/domain/repositories/payment_repository.dart';

final class GetPaymentSummaryInteractor {
  const GetPaymentSummaryInteractor(this._repository);

  final PaymentRepository _repository;

  Stream<GetPaymentSummaryState> execute(String month) async* {
    yield const GetPaymentSummaryState.loading();
    try {
      final summary = await _repository.getSummary(month);
      yield GetPaymentSummaryState.success(summary);
    } catch (error, stackTrace) {
      yield GetPaymentSummaryState.failure(
        _toFailure(error),
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }

  AppFailure _toFailure(Object error) =>
      error is AppFailure ? error : const NetworkFailure();
}
