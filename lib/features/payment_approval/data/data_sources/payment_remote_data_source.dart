import 'package:fvelox/features/payment_approval/data/models/payment_dto.dart';
import 'package:fvelox/features/payment_approval/data/models/payment_feature_dto.dart';
import 'package:fvelox/features/payment_approval/data/models/payment_summary_dto.dart';

abstract interface class PaymentRemoteDataSource {
  Future<PaymentFeatureDto> getFeature();
  Future<PaymentSummaryDto> getSummary(String month);
  Future<List<PaymentDto>> getPayments();
  Future<PaymentDto> getPayment(String id);
  Future<List<PaymentDto>> getRequests();
  Future<PaymentDto> createRequest();
  Future<PaymentDto> decide(String id, bool approve, String otp);
  Future<void> deletePayment(String id);
  Future<int> deletePayments(List<String> ids);
}
