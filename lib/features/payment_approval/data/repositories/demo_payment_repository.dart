import 'dart:math';

import 'package:fvelox/core/errors/app_failure.dart';
import 'package:fvelox/features/payment_approval/domain/entities/payment.dart';
import 'package:fvelox/features/payment_approval/domain/entities/payment_feature.dart';
import 'package:fvelox/features/payment_approval/domain/entities/payment_summary.dart';
import 'package:fvelox/features/payment_approval/domain/repositories/payment_repository.dart';

class DemoPaymentRepository implements PaymentRepository {
  static const _seedPayments = [
    Payment(
      id: '1',
      party: 'Mamo Technologies',
      amount: 8400,
      status: PaymentStatus.approved,
      dateLabel: '19 Sep 2026',
      reference: 'MAMO-240919-01',
      note: 'Quarterly design retainer',
    ),
    Payment(
      id: '2',
      party: 'Noura Studio',
      amount: 1280,
      status: PaymentStatus.rejected,
      dateLabel: '18 Sep 2026',
      reference: 'NS-0918-44',
      note: 'Campaign production',
    ),
    Payment(
      id: '3',
      party: 'Alpine Office',
      amount: 3950,
      status: PaymentStatus.approved,
      dateLabel: '16 Sep 2026',
      reference: 'AO-0916-12',
      note: 'Office lease — September',
    ),
  ];

  DemoPaymentRepository({List<Payment> initialPayments = _seedPayments})
    : _decidedPayments = {
        for (final payment in initialPayments) payment.id: payment,
      };

  final Map<String, Payment> _decidedPayments;
  final Map<String, Payment> _pendingRequests = {};

  @override
  Future<PaymentFeature> getFeature() async =>
      const PaymentFeature(enabled: true, authRequired: false);

  @override
  Future<PaymentSummary> getSummary(String month) async =>
      PaymentSummary.fromDecidedPayments(month, _decidedPayments.values);

  @override
  Future<List<Payment>> getDecidedPayments() async {
    final payments = _decidedPayments.values.toList()..sort(_compareMostRecent);
    return List.unmodifiable(payments);
  }

  @override
  Future<Payment> getPayment(String id) async {
    final payment =
        _decidedPayments[id] ??
        _pendingRequests[id] ??
        (throw const PaymentApiFailure(code: 'payment_not_found'));
    if (payment.status == PaymentStatus.pending) {
      throw const PaymentApiFailure(code: 'payment_not_decided');
    }
    return payment;
  }

  @override
  Future<void> deletePayment(String id) async {
    if (!_decidedPayments.containsKey(id)) {
      throw const PaymentApiFailure(code: 'payment_not_found');
    }
    _decidedPayments.remove(id);
  }

  @override
  Future<int> deletePayments(List<String> ids) async {
    if (ids.isEmpty) {
      throw const PaymentApiFailure(code: 'invalid_ids');
    }
    final existingIds = ids
        .where(_decidedPayments.containsKey)
        .toList(growable: false);
    if (existingIds.isEmpty) {
      throw const PaymentApiFailure(code: 'payment_not_found');
    }
    for (final id in existingIds) {
      _decidedPayments.remove(id);
    }
    return existingIds.length;
  }

  @override
  Future<Payment> createDemoRequest() async {
    final random = Random();
    final suffix = random.nextInt(90) + 10;
    final request = Payment(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      party: 'Kite Supplies',
      amount: (680 + random.nextInt(800)).toDouble(),
      status: PaymentStatus.pending,
      dateLabel: '19 Sep 2026',
      reference: 'KITE-240919-$suffix',
      note: 'Incoming payment request',
    );
    _pendingRequests[request.id] = request;
    return request;
  }

  @override
  Future<Payment> decidePayment(
    Payment payment,
    PaymentStatus status,
    String otp,
  ) async {
    final pending = _pendingRequests.remove(payment.id);
    if (pending == null) {
      throw const PaymentApiFailure(code: 'payment_not_found');
    }
    final decided = Payment(
      id: pending.id,
      party: pending.party,
      amount: pending.amount,
      status: status,
      dateLabel: pending.dateLabel,
      occurredAt: DateTime.now(),
      reference: pending.reference,
      note: pending.note,
    );
    _decidedPayments[decided.id] = decided;
    return decided;
  }

  int _compareMostRecent(Payment left, Payment right) {
    final leftDate = left.occurredAt;
    final rightDate = right.occurredAt;
    if (leftDate == null && rightDate == null) return 0;
    if (leftDate == null) return 1;
    if (rightDate == null) return -1;
    return rightDate.compareTo(leftDate);
  }
}
