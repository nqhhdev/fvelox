import 'package:fvelox/features/payment_approval/domain/entities/payment.dart';
import 'package:fvelox/features/payment_approval/data/models/payment_model.dart';

extension PaymentModelX on PaymentModel {
  Payment toEntity() => Payment(
    id: id,
    party: party,
    amount: amount,
    status: status,
    dateLabel: dateLabel,
    reference: reference,
    note: note,
  );
}
