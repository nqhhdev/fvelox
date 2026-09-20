import 'package:fvelox/core/errors/app_failure.dart';

final class PaymentApprovalFlowState {
  const PaymentApprovalFlowState({
    this.isCreatingRequest = false,
    this.isDeciding = false,
    this.failure,
  });

  final bool isCreatingRequest;
  final bool isDeciding;
  final AppFailure? failure;

  bool get isBusy => isCreatingRequest || isDeciding;

  PaymentApprovalFlowState copyWith({
    bool? isCreatingRequest,
    bool? isDeciding,
    AppFailure? failure,
    bool clearFailure = false,
  }) => PaymentApprovalFlowState(
    isCreatingRequest: isCreatingRequest ?? this.isCreatingRequest,
    isDeciding: isDeciding ?? this.isDeciding,
    failure: clearFailure ? null : failure ?? this.failure,
  );
}
