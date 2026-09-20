import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fvelox/core/errors/app_failure.dart';
import 'package:fvelox/features/payment_approval/domain/entities/payment.dart';
import 'package:fvelox/features/payment_approval/domain/interactors/approval/create_demo_request_interactor.dart';
import 'package:fvelox/features/payment_approval/domain/interactors/approval/decide_payment_interactor.dart';
import 'package:fvelox/features/payment_approval/domain/interactors/approval/validate_payment_otp_interactor.dart';
import 'package:fvelox/features/payment_approval/presentation/view_models/approval/payment_approval_flow_state.dart';

final class PaymentApprovalFlowController
    extends StateNotifier<PaymentApprovalFlowState> {
  PaymentApprovalFlowController({
    required CreateDemoRequestInteractor createDemoRequest,
    required DecidePaymentInteractor decidePayment,
    required ValidatePaymentOtpInteractor validatePaymentOtp,
    required void Function() requestScreenRefresh,
  }) : _createDemoRequest = createDemoRequest,
       _decidePayment = decidePayment,
       _validatePaymentOtp = validatePaymentOtp,
       _requestScreenRefresh = requestScreenRefresh,
       super(const PaymentApprovalFlowState());

  final CreateDemoRequestInteractor _createDemoRequest;
  final DecidePaymentInteractor _decidePayment;
  final ValidatePaymentOtpInteractor _validatePaymentOtp;
  final void Function() _requestScreenRefresh;

  Future<Payment> createDemoRequest() async {
    state = state.copyWith(isCreatingRequest: true, clearFailure: true);
    try {
      final result = await _createDemoRequest.execute().last;
      if (result.isSuccess && result.payment != null) return result.payment!;
      throw result.failure ?? const NetworkFailure();
    } catch (error) {
      final failure = _toFailure(error);
      state = state.copyWith(failure: failure);
      throw failure;
    } finally {
      state = state.copyWith(isCreatingRequest: false);
    }
  }

  Future<void> decide(Payment request, PaymentStatus status, String otp) async {
    await _validateOtp(otp);
    state = state.copyWith(isDeciding: true, clearFailure: true);
    try {
      final result = await _decidePayment
          .execute(payment: request, status: status, otp: otp)
          .last;
      if (!result.isSuccess) {
        throw result.failure ?? const NetworkFailure();
      }
    } catch (error) {
      final failure = _toFailure(error);
      state = state.copyWith(failure: failure);
      throw failure;
    } finally {
      state = state.copyWith(isDeciding: false);
    }
  }

  void refreshScreensAfterDecision() {
    _requestScreenRefresh();
  }

  Future<void> _validateOtp(String otp) async {
    final result = await _validatePaymentOtp.execute(otp).last;
    if (result.isSuccess && result.isValid) return;
    throw result.failure ?? const PaymentApiFailure(code: 'invalid_otp');
  }

  AppFailure _toFailure(Object error) =>
      error is AppFailure ? error : const NetworkFailure();
}
