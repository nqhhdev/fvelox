import 'package:flutter_test/flutter_test.dart';

import 'package:fvelox/core/design_system/fvelox_toast_controller.dart';
import 'package:fvelox/core/errors/app_failure.dart';
import 'package:fvelox/features/payment_approval/domain/entities/payment.dart';
import 'package:fvelox/features/payment_approval/domain/entities/payment_feature.dart';
import 'package:fvelox/features/payment_approval/domain/entities/payment_summary.dart';
import 'package:fvelox/features/payment_approval/domain/interactors/approval/create_demo_request_interactor.dart';
import 'package:fvelox/features/payment_approval/domain/interactors/approval/decide_payment_interactor.dart';
import 'package:fvelox/features/payment_approval/domain/interactors/approval/validate_payment_otp_interactor.dart';
import 'package:fvelox/features/payment_approval/domain/interactors/feature/get_payment_feature_interactor.dart';
import 'package:fvelox/features/payment_approval/domain/interactors/home/get_payment_summary_interactor.dart';
import 'package:fvelox/features/payment_approval/domain/interactors/payments/delete_payment_interactor.dart';
import 'package:fvelox/features/payment_approval/domain/interactors/payments/delete_payments_interactor.dart';
import 'package:fvelox/features/payment_approval/domain/interactors/payments/get_decided_payments_interactor.dart';
import 'package:fvelox/features/payment_approval/domain/repositories/payment_repository.dart';
import 'package:fvelox/features/payment_approval/presentation/view_models/approval/payment_approval_flow_controller.dart';
import 'package:fvelox/features/payment_approval/presentation/view_models/feature/payment_feature_controller.dart';
import 'package:fvelox/features/payment_approval/presentation/view_models/home/home_controller.dart';
import 'package:fvelox/features/payment_approval/presentation/view_models/payments/payments_controller.dart';

void main() {
  late _FakePaymentRepository repository;

  setUp(() => repository = _FakePaymentRepository());

  test('Home controller owns summary and recent activity state', () async {
    var refreshCount = 0;
    final controller = HomeController(
      getPaymentSummary: GetPaymentSummaryInteractor(repository),
      getDecidedPayments: GetDecidedPaymentsInteractor(repository),
      deletePayment: DeletePaymentInteractor(repository),
      requestScreenRefresh: () => refreshCount++,
      toast: FveloxToastController(),
    );
    addTearDown(controller.dispose);

    await controller.load();

    expect(controller.state.summary?.paymentCount, 1);
    expect(controller.state.recentPayments, [_approved]);
    expect(controller.state.isLoading, isFalse);

    final refresh = controller.load();
    expect(controller.state.isLoading, isFalse);
    expect(controller.state.isRefreshing, isTrue);
    await refresh;
    expect(controller.state.isRefreshing, isFalse);

    await controller.deletePayment(_approved.id);

    expect(refreshCount, 1);
    expect(controller.state.recentPayments, isEmpty);
    expect(controller.state.isDeleting, isFalse);
  });

  test('Payments controller owns list and deletion state', () async {
    var refreshCount = 0;
    final controller = PaymentsController(
      getDecidedPayments: GetDecidedPaymentsInteractor(repository),
      deletePayment: DeletePaymentInteractor(repository),
      deletePayments: DeletePaymentsInteractor(repository),
      requestScreenRefresh: () => refreshCount++,
      toast: FveloxToastController(),
    );
    addTearDown(controller.dispose);

    await controller.load();
    final refresh = controller.load();
    expect(controller.state.isLoading, isFalse);
    expect(controller.state.isRefreshing, isTrue);
    await refresh;
    expect(controller.state.isRefreshing, isFalse);

    await controller.deletePayments([_approved.id]);

    expect(controller.state.payments, isEmpty);
    expect(controller.state.isDeleting, isFalse);
    expect(refreshCount, 1);
  });

  test(
    'Approval controller validates OTP and refreshes screen controllers',
    () async {
      var refreshCount = 0;
      final controller = PaymentApprovalFlowController(
        createDemoRequest: CreateDemoRequestInteractor(repository),
        decidePayment: DecidePaymentInteractor(repository),
        validatePaymentOtp: const ValidatePaymentOtpInteractor(),
        requestScreenRefresh: () => refreshCount++,
      );
      addTearDown(controller.dispose);

      await expectLater(
        controller.decide(_pending, PaymentStatus.approved, '1234'),
        throwsA(isA<PaymentApiFailure>()),
      );
      expect(refreshCount, 0);

      await controller.decide(_pending, PaymentStatus.rejected, '8888');

      expect(refreshCount, 0);
      expect(controller.state.isDeciding, isFalse);

      controller.refreshScreensAfterDecision();
      expect(refreshCount, 1);
    },
  );

  test('Feature controller owns the feature-gate state', () async {
    final controller = PaymentFeatureController(
      getFeature: GetPaymentFeatureInteractor(repository),
    );
    addTearDown(controller.dispose);

    await controller.load();

    expect(controller.state.isEnabled, isTrue);
    expect(controller.state.isLoading, isFalse);
  });
}

const _approved = Payment(
  id: 'approved-1',
  party: 'Approved partner',
  amount: 100,
  status: PaymentStatus.approved,
  dateLabel: '20 Sep 2026',
  reference: 'APPROVED-01',
  note: 'Approved payment',
);

const _pending = Payment(
  id: 'pending-1',
  party: 'Pending partner',
  amount: 200,
  status: PaymentStatus.pending,
  dateLabel: '20 Sep 2026',
  reference: 'PENDING-01',
  note: 'Pending payment',
);

final class _FakePaymentRepository implements PaymentRepository {
  final List<Payment> _decidedPayments = [_approved];

  @override
  Future<PaymentFeature> getFeature() async =>
      const PaymentFeature(enabled: true, authRequired: false);

  @override
  Future<PaymentSummary> getSummary(String month) async {
    final approved = _decidedPayments.where(
      (payment) => payment.status == PaymentStatus.approved,
    );
    final total = approved.fold<double>(
      0,
      (sum, payment) => sum + payment.amount,
    );
    return PaymentSummary(
      month: month,
      currency: 'AED',
      totalAmount: total,
      totalAmountMinor: (total * 100).round(),
      paymentCount: approved.length,
    );
  }

  @override
  Future<List<Payment>> getDecidedPayments() async =>
      List.unmodifiable(_decidedPayments);

  @override
  Future<Payment> getPayment(String id) async =>
      _decidedPayments.firstWhere((payment) => payment.id == id);

  @override
  Future<Payment> createDemoRequest() async => _pending;

  @override
  Future<void> deletePayment(String id) async {
    _decidedPayments.removeWhere((payment) => payment.id == id);
  }

  @override
  Future<int> deletePayments(List<String> ids) async => ids.length;

  @override
  Future<Payment> decidePayment(
    Payment payment,
    PaymentStatus status,
    String otp,
  ) async {
    final decided = Payment(
      id: payment.id,
      party: payment.party,
      amount: payment.amount,
      status: status,
      dateLabel: payment.dateLabel,
      reference: payment.reference,
      note: payment.note,
    );
    _decidedPayments.insert(0, decided);
    return decided;
  }
}
