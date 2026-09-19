import 'package:drift/drift.dart';

class PaymentFeatureTable extends Table {
  TextColumn get featureKey => text()();
  BoolColumn get enabled => boolean()();
  BoolColumn get authRequired => boolean()();
  DateTimeColumn get cachedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {featureKey};
}
