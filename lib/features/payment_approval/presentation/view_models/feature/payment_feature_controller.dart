import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fvelox/core/errors/app_failure.dart';
import 'package:fvelox/features/payment_approval/domain/entities/payment_feature.dart';
import 'package:fvelox/features/payment_approval/domain/interactors/feature/get_payment_feature_interactor.dart';
import 'package:fvelox/features/payment_approval/presentation/view_models/feature/payment_feature_screen_state.dart';

final class PaymentFeatureController
    extends StateNotifier<PaymentFeatureScreenState> {
  PaymentFeatureController({required GetPaymentFeatureInteractor getFeature})
    : _getFeature = getFeature,
      super(const PaymentFeatureScreenState());

  final GetPaymentFeatureInteractor _getFeature;
  int _loadRevision = 0;

  Future<void> load() async {
    final revision = ++_loadRevision;
    state = state.copyWith(isLoading: true, clearFailure: true);
    try {
      final feature = await _readFeature();
      if (revision != _loadRevision) return;
      state = state.copyWith(feature: feature, isLoading: false);
    } catch (error) {
      if (revision != _loadRevision) return;
      state = state.copyWith(isLoading: false, failure: _toFailure(error));
    }
  }

  Future<PaymentFeature> _readFeature() async {
    final result = await _getFeature.execute().last;
    if (result.isSuccess && result.feature != null) return result.feature!;
    throw result.failure ?? const NetworkFailure();
  }

  AppFailure _toFailure(Object error) =>
      error is AppFailure ? error : const NetworkFailure();
}
