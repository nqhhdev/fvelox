import 'package:flutter_test/flutter_test.dart';

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
import 'package:fvelox/features/payment_approval/domain/interactors/payments/get_payment_details_interactor.dart';
import 'package:fvelox/features/payment_approval/domain/app_state/shared/interactor_state_status.dart';
import 'package:fvelox/features/payment_approval/domain/repositories/payment_repository.dart';

void main() {
  test('each payment interactor emits loading then success', () async {
    final repository = _SuccessfulPaymentRepository();

    final feature = await GetPaymentFeatureInteractor(
      repository,
    ).execute().toList();
    final summary = await GetPaymentSummaryInteractor(
      repository,
    ).execute('2026-09').toList();
    final decided = await GetDecidedPaymentsInteractor(
      repository,
    ).execute().toList();
    final details = await GetPaymentDetailsInteractor(
      repository,
    ).execute(_approved.id).toList();
    final created = await CreateDemoRequestInteractor(
      repository,
    ).execute().toList();
    final decision = await DecidePaymentInteractor(repository)
        .execute(payment: _pending, status: PaymentStatus.approved, otp: '8888')
        .toList();
    final deletion = await DeletePaymentInteractor(
      repository,
    ).execute(_approved.id).toList();
    final bulkDeletion = await DeletePaymentsInteractor(
      repository,
    ).execute([_approved.id, _pending.id]).toList();
    final otp = await const ValidatePaymentOtpInteractor()
        .execute('8888')
        .toList();

    expect(feature.map((state) => state.status), [
      InteractorStateStatus.loading,
      InteractorStateStatus.success,
    ]);
    expect(summary.last.summary, isNotNull);
    expect(decided.last.payments, [_approved]);
    expect(details.last.payment, _approved);
    expect(created.last.payment, _pending);
    expect(decision.last.payment?.status, PaymentStatus.approved);
    expect(deletion.last.deletedPaymentId, _approved.id);
    expect(bulkDeletion.last.deletedCount, 2);
    expect(otp.last.isValid, isTrue);
  });

  test(
    'interactors convert local and unknown errors into failure state',
    () async {
      final repository = _FailingPaymentRepository();

      final localStates = await GetPaymentFeatureInteractor(
        repository,
      ).execute().toList();
      final unknownStates = await GetPaymentDetailsInteractor(
        repository,
      ).execute('missing').toList();

      expect(localStates.last.isFailure, isTrue);
      expect(localStates.last.failure, isA<LocalStorageFailure>());
      expect(unknownStates.last.failure, isA<NetworkFailure>());
      expect(unknownStates.last.cause, isA<StateError>());
    },
  );
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

class _SuccessfulPaymentRepository implements PaymentRepository {
  @override
  Future<PaymentFeature> getFeature() async =>
      const PaymentFeature(enabled: true, authRequired: false);

  @override
  Future<PaymentSummary> getSummary(String month) async => PaymentSummary(
    month: month,
    currency: 'AED',
    totalAmount: 100,
    totalAmountMinor: 10000,
    paymentCount: 1,
  );

  @override
  Future<List<Payment>> getDecidedPayments() async => const [_approved];

  @override
  Future<Payment> getPayment(String id) async => _approved;

  @override
  Future<Payment> createDemoRequest() async => _pending;

  @override
  Future<void> deletePayment(String id) async {}

  @override
  Future<int> deletePayments(List<String> ids) async => ids.length;

  @override
  Future<Payment> decidePayment(
    Payment payment,
    PaymentStatus status,
    String otp,
  ) async => Payment(
    id: payment.id,
    party: payment.party,
    amount: payment.amount,
    status: status,
    dateLabel: payment.dateLabel,
    reference: payment.reference,
    note: payment.note,
  );
}

class _FailingPaymentRepository implements PaymentRepository {
  @override
  Future<PaymentFeature> getFeature() async =>
      throw const LocalStorageFailure();

  @override
  Future<PaymentSummary> getSummary(String month) async =>
      throw const LocalStorageFailure();

  @override
  Future<List<Payment>> getDecidedPayments() async =>
      throw const LocalStorageFailure();

  @override
  Future<Payment> getPayment(String id) async => throw StateError('broken');

  @override
  Future<Payment> createDemoRequest() async => throw const NetworkFailure();

  @override
  Future<void> deletePayment(String id) async =>
      throw const LocalStorageFailure();

  @override
  Future<int> deletePayments(List<String> ids) async =>
      throw const LocalStorageFailure();

  @override
  Future<Payment> decidePayment(
    Payment payment,
    PaymentStatus status,
    String otp,
  ) async => throw const NetworkFailure();
}
