import 'package:fvelox/features/payment_approval/domain/entities/payment.dart';

/// Money-moved summary for a month. Used by Home and repository offline derive.
class PaymentSummary {
  static const _monthNumbers = {
    'jan': 1,
    'feb': 2,
    'mar': 3,
    'apr': 4,
    'may': 5,
    'jun': 6,
    'jul': 7,
    'aug': 8,
    'sep': 9,
    'oct': 10,
    'nov': 11,
    'dec': 12,
  };

  const PaymentSummary({
    required this.month,
    required this.currency,
    required this.totalAmount,
    required this.totalAmountMinor,
    required this.paymentCount,
  });
  final String month;
  final String currency;
  final double totalAmount;
  final int totalAmountMinor;
  final int paymentCount;

  factory PaymentSummary.fromDecidedPayments(
    String month,
    Iterable<Payment> payments,
  ) {
    final approvedPayments = payments.where(
      (payment) =>
          payment.status == PaymentStatus.approved &&
          _belongsToMonth(payment, month),
    );
    final totalAmount = approvedPayments.fold<double>(
      0,
      (total, payment) => total + payment.amount,
    );
    return PaymentSummary(
      month: month,
      currency: 'AED',
      totalAmount: totalAmount,
      totalAmountMinor: (totalAmount * 100).round(),
      paymentCount: approvedPayments.length,
    );
  }

  PaymentSummary copyWith({
    String? month,
    String? currency,
    double? totalAmount,
    int? totalAmountMinor,
    int? paymentCount,
  }) => PaymentSummary(
    month: month ?? this.month,
    currency: currency ?? this.currency,
    totalAmount: totalAmount ?? this.totalAmount,
    totalAmountMinor: totalAmountMinor ?? this.totalAmountMinor,
    paymentCount: paymentCount ?? this.paymentCount,
  );

  static bool _belongsToMonth(Payment payment, String month) {
    final occurredAt = payment.occurredAt;
    final paymentMonth = occurredAt == null
        ? _monthFromDateLabel(payment.dateLabel)
        : '${occurredAt.year}-${occurredAt.month.toString().padLeft(2, '0')}';
    // Unparseable dates must not inflate every month's totals.
    if (paymentMonth == null) return false;
    return paymentMonth == month;
  }

  static String? _monthFromDateLabel(String dateLabel) {
    final parts = dateLabel.trim().split(RegExp(r'\s+'));
    if (parts.length != 3) return null;
    final month = _monthNumbers[parts[1].toLowerCase()];
    final year = int.tryParse(parts[2]);
    final day = int.tryParse(parts[0]);
    if (month == null || year == null || day == null) return null;
    return '$year-${month.toString().padLeft(2, '0')}';
  }
}
