import 'package:drift/drift.dart';

class PaymentSummaryTable extends Table {
  TextColumn get month => text()();
  TextColumn get currency => text()();
  RealColumn get totalAmount => real()();
  IntColumn get totalAmountMinor => integer()();
  IntColumn get paymentCount => integer()();
  DateTimeColumn get cachedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {month};
}
