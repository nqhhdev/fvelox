import 'package:fvelox/core/local_database/fvelox_database.dart';
import 'package:fvelox/features/payment_approval/domain/entities/payment_summary.dart';
import 'package:fvelox/features/payment_approval/data/models/payment_summary_dto.dart';

extension PaymentSummaryDtoX on PaymentSummaryDto {
  PaymentSummary toEntity() => PaymentSummary(
    month: month,
    currency: currency,
    totalAmount: totalAmount,
    totalAmountMinor: totalAmountMinor,
    paymentCount: paymentCount,
  );
}

extension PaymentSummaryX on PaymentSummary {
  PaymentSummaryTableCompanion toCompanion() =>
      PaymentSummaryTableCompanion.insert(
        month: month,
        currency: currency,
        totalAmount: totalAmount,
        totalAmountMinor: totalAmountMinor,
        paymentCount: paymentCount,
        cachedAt: DateTime.now(),
      );
}

extension PaymentSummaryTableDataX on PaymentSummaryTableData {
  PaymentSummary toEntity() => PaymentSummary(
    month: month,
    currency: currency,
    totalAmount: totalAmount,
    totalAmountMinor: totalAmountMinor,
    paymentCount: paymentCount,
  );
}
