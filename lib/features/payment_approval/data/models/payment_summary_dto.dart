final class PaymentSummaryDto {
  const PaymentSummaryDto({
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
  factory PaymentSummaryDto.fromJson(Map<String, dynamic> json) {
    final currency = json['currency'] as String;
    if (currency != 'AED') {
      throw FormatException('Unsupported summary currency: $currency');
    }
    return PaymentSummaryDto(
      month: json['month'] as String,
      currency: currency,
      totalAmount: (json['total_amount'] as num).toDouble(),
      totalAmountMinor: (json['total_amount_minor'] as num).toInt(),
      paymentCount: (json['payment_count'] as num).toInt(),
    );
  }
}
