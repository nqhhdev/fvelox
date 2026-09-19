import 'package:drift/drift.dart';

class PaymentTable extends Table {
  TextColumn get id => text()();
  TextColumn get party => text()();
  RealColumn get amount => real()();
  IntColumn get status => integer()();
  TextColumn get dateLabel => text()();
  TextColumn get reference => text()();
  TextColumn get note => text()();
  DateTimeColumn get cachedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
