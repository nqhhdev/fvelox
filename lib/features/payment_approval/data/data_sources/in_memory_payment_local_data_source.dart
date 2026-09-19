import 'package:fvelox/features/payment_approval/domain/entities/payment.dart';
import 'package:fvelox/features/payment_approval/domain/entities/payment_feature.dart';
import 'package:fvelox/features/payment_approval/domain/entities/payment_summary.dart';
import 'package:fvelox/features/payment_approval/data/data_sources/payment_local_data_source.dart';

final class InMemoryPaymentLocalDataSource implements PaymentLocalDataSource {
  List<Payment> _payments = const [];
  PaymentFeature? _feature;
  final Map<String, PaymentSummary> _summaries = {};

  @override
  Future<PaymentFeature?> readFeature() async => _feature;

  @override
  Future<void> saveFeature(PaymentFeature feature) async => _feature = feature;

  @override
  Future<PaymentSummary?> readSummary(String month) async => _summaries[month];

  @override
  Future<void> saveSummary(PaymentSummary summary) async =>
      _summaries[summary.month] = summary;

  @override
  Future<List<Payment>> readDecidedPayments() async => List.unmodifiable(
    _payments.where((payment) => payment.status != PaymentStatus.pending),
  );

  @override
  Future<Payment?> readPayment(String id) async {
    for (final payment in _payments) {
      if (payment.id == id) return payment;
    }
    return null;
  }

  @override
  Future<void> replaceDecidedPayments(List<Payment> payments) async {
    _payments = List.unmodifiable(payments);
  }

  @override
  Future<void> saveDecidedPayment(Payment payment) async {
    _payments = List.unmodifiable([
      ..._payments.where((item) => item.id != payment.id),
      payment,
    ]);
  }

  @override
  Future<void> deletePayment(String id) async {
    _payments = List.unmodifiable(
      _payments.where((payment) => payment.id != id),
    );
  }

  @override
  Future<void> deletePayments(Iterable<String> ids) async {
    final idSet = ids.toSet();
    _payments = List.unmodifiable(
      _payments.where((payment) => !idSet.contains(payment.id)),
    );
  }
}
