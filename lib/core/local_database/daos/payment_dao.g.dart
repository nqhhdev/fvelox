// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_dao.dart';

// ignore_for_file: type=lint
mixin _$PaymentDaoMixin on DatabaseAccessor<FveloxDatabase> {
  $PaymentTableTable get paymentTable => attachedDatabase.paymentTable;
  $PaymentFeatureTableTable get paymentFeatureTable =>
      attachedDatabase.paymentFeatureTable;
  $PaymentSummaryTableTable get paymentSummaryTable =>
      attachedDatabase.paymentSummaryTable;
  PaymentDaoManager get managers => PaymentDaoManager(this);
}

class PaymentDaoManager {
  final _$PaymentDaoMixin _db;
  PaymentDaoManager(this._db);
  $$PaymentTableTableTableManager get paymentTable =>
      $$PaymentTableTableTableManager(_db.attachedDatabase, _db.paymentTable);
  $$PaymentFeatureTableTableTableManager get paymentFeatureTable =>
      $$PaymentFeatureTableTableTableManager(
        _db.attachedDatabase,
        _db.paymentFeatureTable,
      );
  $$PaymentSummaryTableTableTableManager get paymentSummaryTable =>
      $$PaymentSummaryTableTableTableManager(
        _db.attachedDatabase,
        _db.paymentSummaryTable,
      );
}
