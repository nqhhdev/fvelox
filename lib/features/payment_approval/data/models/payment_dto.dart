import 'package:fvelox/features/payment_approval/domain/entities/payment.dart';

final class PaymentDto {
  const PaymentDto({
    required this.id,
    required this.recipientName,
    required this.amount,
    required this.amountMinor,
    required this.currency,
    required this.status,
    required this.reference,
    required this.note,
    required this.createdAt,
    required this.decidedAt,
  });
  final String id;
  final String recipientName;
  final double amount;
  final int amountMinor;
  final String currency;
  final PaymentStatus status;
  final String reference;
  final String note;
  final DateTime createdAt;
  final DateTime? decidedAt;

  factory PaymentDto.fromJson(Map<String, dynamic> json) {
    final currency = json['currency'] as String;
    if (currency != 'AED') {
      throw FormatException('Unsupported payment currency: $currency');
    }

    return PaymentDto(
      id: json['id'] as String,
      recipientName: json['recipient_name'] as String,
      amount: (json['amount'] as num).toDouble(),
      amountMinor: (json['amount_minor'] as num).toInt(),
      currency: currency,
      status: _parseStatus(json['status']),
      reference: json['reference'] as String,
      note: (json['note'] as String?) ?? '',
      createdAt: _parseDateTime(json['created_at'], field: 'created_at'),
      decidedAt: json['decided_at'] == null
          ? null
          : _parseDateTime(json['decided_at'], field: 'decided_at'),
    );
  }
}

PaymentStatus _parseStatus(Object? value) {
  if (value is! String) {
    throw FormatException('Expected payment status string, got $value');
  }
  for (final status in PaymentStatus.values) {
    if (status.name.toUpperCase() == value.toUpperCase()) return status;
  }
  throw FormatException('Unknown payment status: $value');
}

DateTime _parseDateTime(Object? value, {required String field}) {
  if (value is String) return DateTime.parse(value);
  if (value is num) {
    final rawValue = value.toDouble();
    final milliseconds = rawValue.abs() < 100000000000
        ? (rawValue * 1000).round()
        : rawValue.round();
    return DateTime.fromMillisecondsSinceEpoch(milliseconds, isUtc: true);
  }
  throw FormatException(
    'Expected ISO-8601 string or Unix timestamp for $field, got $value',
  );
}
