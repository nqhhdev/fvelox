enum PaymentStatus { pending, approved, rejected }

class Payment {
  const Payment({
    required this.id,
    required this.party,
    required this.amount,
    required this.status,
    required this.dateLabel,
    this.occurredAt,
    required this.reference,
    required this.note,
  });

  final String id;
  final String party;
  final double amount;
  final PaymentStatus status;
  final String dateLabel;
  final DateTime? occurredAt;
  final String reference;
  final String note;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Payment &&
          other.id == id &&
          other.party == party &&
          other.amount == amount &&
          other.status == status &&
          other.dateLabel == dateLabel &&
          other.occurredAt == occurredAt &&
          other.reference == reference &&
          other.note == note;

  @override
  int get hashCode => Object.hash(
    id,
    party,
    amount,
    status,
    dateLabel,
    occurredAt,
    reference,
    note,
  );
}
