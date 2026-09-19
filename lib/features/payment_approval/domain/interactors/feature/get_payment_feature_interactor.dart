import 'package:fvelox/core/errors/app_failure.dart';
import 'package:fvelox/features/payment_approval/domain/app_state/feature/get_payment_feature_state.dart';
import 'package:fvelox/features/payment_approval/domain/repositories/payment_repository.dart';

final class GetPaymentFeatureInteractor {
  const GetPaymentFeatureInteractor(this._repository);

  final PaymentRepository _repository;

  Stream<GetPaymentFeatureState> execute() async* {
    yield const GetPaymentFeatureState.loading();
    try {
      final feature = await _repository.getFeature();
      yield GetPaymentFeatureState.success(feature);
    } catch (error, stackTrace) {
      yield GetPaymentFeatureState.failure(
        _toFailure(error),
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }

  AppFailure _toFailure(Object error) =>
      error is AppFailure ? error : const NetworkFailure();
}
