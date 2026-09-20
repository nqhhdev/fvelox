import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fvelox/core/errors/app_failure.dart';
import 'package:fvelox/features/payment_approval/domain/entities/payment.dart';
import 'package:fvelox/features/payment_approval/domain/interactors/payments/get_payment_details_interactor.dart';
import 'package:fvelox/features/payment_approval/presentation/view_models/details/payment_details_screen_state.dart';

/// Details screen controller. Wired via `paymentDetailsControllerProvider`.
final class PaymentDetailsController
    extends StateNotifier<PaymentDetailsScreenState> {
  PaymentDetailsController({
    required GetPaymentDetailsInteractor getPaymentDetails,
  }) : _getPaymentDetails = getPaymentDetails,
       super(const PaymentDetailsScreenState());

  final GetPaymentDetailsInteractor _getPaymentDetails;
  int _loadRevision = 0;

  Future<void> load({Payment? cachedPayment, required String paymentId}) async {
    final revision = ++_loadRevision;
    if (cachedPayment != null) {
      if (cachedPayment.status == PaymentStatus.pending) {
        state = const PaymentDetailsScreenState(
          failure: PaymentApiFailure(code: 'payment_not_decided'),
        );
        return;
      }
      state = PaymentDetailsScreenState(payment: cachedPayment);
      return;
    }

    state = state.copyWith(isLoading: true, clearFailure: true);
    try {
      final payment = await _readPayment(paymentId);
      if (revision != _loadRevision) return;
      state = state.copyWith(payment: payment, isLoading: false);
    } catch (error) {
      if (revision != _loadRevision) return;
      state = state.copyWith(isLoading: false, failure: _toFailure(error));
    }
  }

  Future<Payment> _readPayment(String id) async {
    final result = await _getPaymentDetails.execute(id).last;
    if (result.isSuccess && result.payment != null) return result.payment!;
    throw result.failure ?? const NetworkFailure();
  }

  AppFailure _toFailure(Object error) =>
      error is AppFailure ? error : const NetworkFailure();
}
