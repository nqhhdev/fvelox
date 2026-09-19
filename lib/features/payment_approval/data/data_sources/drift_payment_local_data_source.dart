import 'package:fvelox/core/errors/app_failure.dart';
import 'package:fvelox/core/local_database/daos/payment_dao.dart';
import 'package:fvelox/features/payment_approval/domain/entities/payment.dart';
import 'package:fvelox/features/payment_approval/domain/entities/payment_feature.dart';
import 'package:fvelox/features/payment_approval/domain/entities/payment_summary.dart';
import 'package:fvelox/features/payment_approval/data/extensions/payment_extension.dart';
import 'package:fvelox/features/payment_approval/data/extensions/payment_feature_extension.dart';
import 'package:fvelox/features/payment_approval/data/extensions/payment_summary_extension.dart';
import 'package:fvelox/features/payment_approval/data/data_sources/payment_local_data_source.dart';

final class DriftPaymentLocalDataSource implements PaymentLocalDataSource {
  DriftPaymentLocalDataSource(this._dao);

  final PaymentDao _dao;

  @override
  Future<PaymentFeature?> readFeature() async {
    try {
      final row = await _dao.selectFeature(paymentFeatureCacheKey);
      return row?.toEntity();
    } catch (error) {
      throw const LocalStorageFailure();
    }
  }

  @override
  Future<void> saveFeature(PaymentFeature feature) async {
    try {
      await _dao.saveFeature(feature.toCompanion());
    } catch (error) {
      throw const LocalStorageFailure();
    }
  }

  @override
  Future<PaymentSummary?> readSummary(String month) async {
    try {
      final row = await _dao.selectSummary(month);
      return row?.toEntity();
    } catch (error) {
      throw const LocalStorageFailure();
    }
  }

  @override
  Future<void> saveSummary(PaymentSummary summary) async {
    try {
      await _dao.saveSummary(summary.toCompanion());
    } catch (error) {
      throw const LocalStorageFailure();
    }
  }

  @override
  Future<List<Payment>> readDecidedPayments() async {
    try {
      final rows = await _dao.selectDecidedPayments();
      return rows.map((row) => row.toEntity()).toList(growable: false);
    } catch (error) {
      throw const LocalStorageFailure();
    }
  }

  @override
  Future<Payment?> readPayment(String id) async {
    try {
      final row = await _dao.selectPayment(id);
      return row?.toEntity();
    } catch (error) {
      throw const LocalStorageFailure();
    }
  }

  @override
  Future<void> replaceDecidedPayments(List<Payment> payments) async {
    try {
      final cacheTime = DateTime.now();
      await _dao.replaceDecidedPayments(
        payments
            .asMap()
            .entries
            .map((entry) {
              final cacheAt = cacheTime.subtract(
                Duration(microseconds: entry.key),
              );
              return entry.value.toCompanion(cachedAt: cacheAt);
            })
            .toList(growable: false),
      );
    } catch (error) {
      throw const LocalStorageFailure();
    }
  }

  @override
  Future<void> saveDecidedPayment(Payment payment) async {
    try {
      await _dao.saveDecidedPayment(payment.toCompanion());
    } catch (error) {
      throw const LocalStorageFailure();
    }
  }

  @override
  Future<void> deletePayment(String id) async {
    try {
      await _dao.deletePayment(id);
    } catch (error) {
      throw const LocalStorageFailure();
    }
  }

  @override
  Future<void> deletePayments(Iterable<String> ids) async {
    try {
      await _dao.deletePayments(ids.toList(growable: false));
    } catch (error) {
      throw const LocalStorageFailure();
    }
  }
}
