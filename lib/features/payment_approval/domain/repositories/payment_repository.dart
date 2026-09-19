import 'package:fvelox/features/payment_approval/domain/entities/payment.dart';
import 'package:fvelox/features/payment_approval/domain/entities/payment_feature.dart';
import 'package:fvelox/features/payment_approval/domain/entities/payment_summary.dart';

abstract interface class PaymentRepository {
  Future<PaymentFeature> getFeature();
  Future<PaymentSummary> getSummary(String month);
  Future<List<Payment>> getDecidedPayments();
  Future<Payment> getPayment(String id);
  Future<Payment> createDemoRequest();
  Future<void> deletePayment(String id);
  Future<int> deletePayments(List<String> ids);
  Future<Payment> decidePayment(
    Payment payment,
    PaymentStatus status,
    String otp,
  );
}
