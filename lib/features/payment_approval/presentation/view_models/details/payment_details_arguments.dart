import 'package:fvelox/features/payment_approval/domain/entities/payment.dart';

final class PaymentDetailsArguments {
  const PaymentDetailsArguments({required this.paymentId, this.cachedPayment});

  final String paymentId;
  final Payment? cachedPayment;

  @override
  bool operator ==(Object other) =>
      other is PaymentDetailsArguments && other.paymentId == paymentId;

  @override
  int get hashCode => paymentId.hashCode;
}
