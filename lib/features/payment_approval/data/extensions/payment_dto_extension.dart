import 'package:fvelox/features/payment_approval/domain/entities/payment.dart';
import 'package:fvelox/features/payment_approval/data/models/payment_dto.dart';

extension PaymentDtoX on PaymentDto {
  Payment toEntity() => Payment(
    id: id,
    party: recipientName,
    amount: amountMinor / 100,
    status: status,
    dateLabel:
        '${(decidedAt ?? createdAt).day} ${_shortMonth((decidedAt ?? createdAt).month)} ${(decidedAt ?? createdAt).year}',
    occurredAt: decidedAt ?? createdAt,
    reference: reference,
    note: note,
  );

  String _shortMonth(int month) => const [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ][month - 1];
}
