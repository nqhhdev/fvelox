import 'package:fvelox/core/errors/app_failure.dart';
import 'package:fvelox/features/payment_approval/domain/app_state/approval/create_demo_request_state.dart';
import 'package:fvelox/features/payment_approval/domain/repositories/payment_repository.dart';

final class CreateDemoRequestInteractor {
  const CreateDemoRequestInteractor(this._repository);

  final PaymentRepository _repository;

  Stream<CreateDemoRequestState> execute() async* {
    yield const CreateDemoRequestState.loading();
    try {
      final payment = await _repository.createDemoRequest();
      yield CreateDemoRequestState.success(payment);
    } catch (error, stackTrace) {
      yield CreateDemoRequestState.failure(
        _toFailure(error),
        cause: error,
        stackTrace: stackTrace,
      );
    }
  }

  AppFailure _toFailure(Object error) =>
      error is AppFailure ? error : const NetworkFailure();
}
