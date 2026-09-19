import 'package:drift/drift.dart';

import 'package:fvelox/core/local_database/fvelox_database.dart';
import 'package:fvelox/core/local_database/tables/payment_feature_table.dart';
import 'package:fvelox/core/local_database/tables/payment_table.dart';
import 'package:fvelox/core/local_database/tables/payment_summary_table.dart';

part 'payment_dao.g.dart';

@DriftAccessor(tables: [PaymentTable, PaymentFeatureTable, PaymentSummaryTable])
class PaymentDao extends DatabaseAccessor<FveloxDatabase>
    with _$PaymentDaoMixin {
  PaymentDao(super.attachedDatabase);

  Future<List<PaymentTableData>> selectDecidedPayments() =>
      (select(paymentTable)
            ..where((row) => row.status.isNotValue(0))
            ..orderBy([(row) => OrderingTerm.desc(row.cachedAt)]))
          .get();

  Future<PaymentTableData?> selectPayment(String id) => (select(
    paymentTable,
  )..where((row) => row.id.equals(id))).getSingleOrNull();

  Future<void> replaceDecidedPayments(List<PaymentTableCompanion> rows) async {
    await transaction(() async {
      if (rows.isEmpty) {
        await delete(paymentTable).go();
        return;
      }
      final ids = rows.map((row) => row.id.value).toList(growable: false);
      await (delete(paymentTable)..where((row) => row.id.isNotIn(ids))).go();
      await batch((batch) {
        batch.insertAll(paymentTable, rows, mode: InsertMode.insertOrReplace);
      });
    });
  }

  Future<void> saveDecidedPayment(PaymentTableCompanion row) =>
      into(paymentTable).insert(row, mode: InsertMode.insertOrReplace);

  Future<void> deletePayment(String id) =>
      (delete(paymentTable)..where((row) => row.id.equals(id))).go();

  Future<void> deletePayments(List<String> ids) =>
      (delete(paymentTable)..where((row) => row.id.isIn(ids))).go();

  Future<PaymentFeatureTableData?> selectFeature(String key) => (select(
    paymentFeatureTable,
  )..where((row) => row.featureKey.equals(key))).getSingleOrNull();

  Future<void> saveFeature(PaymentFeatureTableCompanion row) =>
      into(paymentFeatureTable).insert(row, mode: InsertMode.insertOrReplace);

  Future<PaymentSummaryTableData?> selectSummary(String month) => (select(
    paymentSummaryTable,
  )..where((row) => row.month.equals(month))).getSingleOrNull();

  Future<void> saveSummary(PaymentSummaryTableCompanion row) =>
      into(paymentSummaryTable).insert(row, mode: InsertMode.insertOrReplace);
}
