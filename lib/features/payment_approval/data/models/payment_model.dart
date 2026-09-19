import 'package:fvelox/features/payment_approval/domain/entities/payment.dart';

final class PaymentModel {
  const PaymentModel({
    required this.id,
    required this.party,
    required this.amount,
    required this.status,
    required this.dateLabel,
    required this.reference,
    required this.note,
  });

  final String id;
  final String party;
  final double amount;
  final PaymentStatus status;
  final String dateLabel;
  final String reference;
  final String note;
}
