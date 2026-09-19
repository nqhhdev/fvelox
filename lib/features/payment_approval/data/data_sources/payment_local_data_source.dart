import 'package:fvelox/features/payment_approval/domain/entities/payment.dart';
import 'package:fvelox/features/payment_approval/domain/entities/payment_feature.dart';
import 'package:fvelox/features/payment_approval/domain/entities/payment_summary.dart';

abstract interface class PaymentLocalDataSource {
  Future<PaymentFeature?> readFeature();
  Future<void> saveFeature(PaymentFeature feature);
  Future<PaymentSummary?> readSummary(String month);
  Future<void> saveSummary(PaymentSummary summary);
  Future<List<Payment>> readDecidedPayments();
  Future<Payment?> readPayment(String id);
  Future<void> replaceDecidedPayments(List<Payment> payments);
  Future<void> saveDecidedPayment(Payment payment);
  Future<void> deletePayment(String id);
  Future<void> deletePayments(Iterable<String> ids);
}
