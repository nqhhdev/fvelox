import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'package:fvelox/core/local_database/daos/payment_dao.dart';
import 'package:fvelox/core/local_database/tables/payment_feature_table.dart';
import 'package:fvelox/core/local_database/tables/payment_table.dart';
import 'package:fvelox/core/local_database/tables/payment_summary_table.dart';

part 'fvelox_database.g.dart';

@DriftDatabase(
  tables: [PaymentTable, PaymentFeatureTable, PaymentSummaryTable],
  daos: [PaymentDao],
)
class FveloxDatabase extends _$FveloxDatabase {
  FveloxDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'fvelox'));

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createTable(paymentFeatureTable);
        await m.createTable(paymentSummaryTable);
      }
      if (from < 3) {
        await (delete(paymentTable)..where((row) => row.status.equals(0))).go();
      }
    },
  );
}
