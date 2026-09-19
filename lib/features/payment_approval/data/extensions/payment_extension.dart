import 'package:fvelox/core/local_database/fvelox_database.dart';
import 'package:fvelox/features/payment_approval/domain/entities/payment.dart';

extension PaymentX on Payment {
  PaymentTableCompanion toCompanion({DateTime? cachedAt}) =>
      PaymentTableCompanion.insert(
        id: id,
        party: party,
        amount: amount,
        status: status.index,
        dateLabel: dateLabel,
        reference: reference,
        note: note,
        cachedAt: cachedAt ?? DateTime.now(),
      );
}

extension PaymentTableDataX on PaymentTableData {
  Payment toEntity() => Payment(
    id: id,
    party: party,
    amount: amount,
    status: PaymentStatus.values[status],
    dateLabel: dateLabel,
    reference: reference,
    note: note,
  );
}
