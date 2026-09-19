import 'package:fvelox/core/errors/app_failure.dart';
import 'package:fvelox/features/payment_approval/domain/entities/payment_feature.dart';
import 'package:fvelox/features/payment_approval/domain/app_state/shared/interactor_state_status.dart';

final class GetPaymentFeatureState {
  const GetPaymentFeatureState({
    this.status = InteractorStateStatus.initial,
    this.feature,
    this.failure,
    this.cause,
    this.stackTrace,
  });

  const GetPaymentFeatureState.initial() : this();

  const GetPaymentFeatureState.loading()
    : this(status: InteractorStateStatus.loading);

  const GetPaymentFeatureState.success(PaymentFeature feature)
    : this(status: InteractorStateStatus.success, feature: feature);

  const GetPaymentFeatureState.failure(
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
  final PaymentFeature? feature;
  final AppFailure? failure;
  final Object? cause;
  final StackTrace? stackTrace;

  bool get isSuccess => status == InteractorStateStatus.success;
  bool get isFailure => status == InteractorStateStatus.failure;
}
