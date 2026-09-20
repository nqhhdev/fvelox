import 'package:fvelox/core/errors/app_failure.dart';
import 'package:fvelox/features/payment_approval/domain/entities/payment_feature.dart';

final class PaymentFeatureScreenState {
  const PaymentFeatureScreenState({
    this.feature,
    this.isLoading = false,
    this.failure,
  });

  final PaymentFeature? feature;
  final bool isLoading;
  final AppFailure? failure;

  bool get isEnabled => feature?.enabled ?? true;

  PaymentFeatureScreenState copyWith({
    PaymentFeature? feature,
    bool? isLoading,
    AppFailure? failure,
    bool clearFailure = false,
  }) => PaymentFeatureScreenState(
    feature: feature ?? this.feature,
    isLoading: isLoading ?? this.isLoading,
    failure: clearFailure ? null : failure ?? this.failure,
  );
}
