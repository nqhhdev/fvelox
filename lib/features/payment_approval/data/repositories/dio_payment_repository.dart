import 'package:fvelox/core/connectivity/connectivity_service.dart';
import 'package:fvelox/core/errors/app_failure.dart';
import 'package:fvelox/core/logging/app_logger.dart';
import 'package:fvelox/features/payment_approval/domain/entities/payment.dart';
import 'package:fvelox/features/payment_approval/domain/entities/payment_feature.dart';
import 'package:fvelox/features/payment_approval/domain/entities/payment_summary.dart';
import 'package:fvelox/features/payment_approval/domain/repositories/payment_repository.dart';
import 'package:fvelox/features/payment_approval/data/data_sources/payment_local_data_source.dart';
import 'package:fvelox/features/payment_approval/data/data_sources/payment_remote_data_source.dart';
import 'package:fvelox/features/payment_approval/data/extensions/payment_dto_extension.dart';
import 'package:fvelox/features/payment_approval/data/extensions/payment_feature_extension.dart';
import 'package:fvelox/features/payment_approval/data/extensions/payment_summary_extension.dart';

final class DioPaymentRepository implements PaymentRepository {
  DioPaymentRepository(
    this._remote,
    this._local,
    this._connectivity,
    this._logger,
  );

  static const _defaultFeature = PaymentFeature(
    enabled: true,
    authRequired: false,
  );

  final PaymentRemoteDataSource _remote;
  final PaymentLocalDataSource _local;
  final ConnectivityService _connectivity;
  final AppLogger _logger;
  Future<List<Payment>>? _decidedPaymentsInFlight;
  int _decidedPaymentsGeneration = 0;

  void _invalidateDecidedPaymentsInFlight() {
    _decidedPaymentsGeneration++;
    _decidedPaymentsInFlight = null;
  }

  @override
  Future<PaymentFeature> getFeature() async {
    if (!await _isOnline()) {
      _logger.warning('Feature refresh skipped because the app is offline.');
      return await _local.readFeature() ?? _defaultFeature;
    }
    try {
      final feature = (await _remote.getFeature()).toEntity();
      await _cache('feature', () => _local.saveFeature(feature));
      _logger.info('Payment feature refreshed.');
      return feature;
    } on NetworkFailure {
      _logger.warning('Feature refresh failed; using cached feature.');
      return await _local.readFeature() ?? _defaultFeature;
    }
  }

  @override
  Future<PaymentSummary> getSummary(String month) async {
    if (!await _isOnline()) {
      _logger.warning('Summary refresh skipped because the app is offline.');
      return _cachedSummaryOrDerived(month);
    }
    try {
      final summary = (await _remote.getSummary(month)).toEntity();
      await _cache('summary', () => _local.saveSummary(summary));
      _logger.info('Payment summary refreshed.');
      return summary;
    } on NetworkFailure {
      _logger.warning(
        'Summary refresh failed; deriving summary from decided cache.',
      );
      return _cachedSummaryOrDerived(month);
    }
  }

  @override
  Future<List<Payment>> getDecidedPayments() {
    final inFlight = _decidedPaymentsInFlight;
    if (inFlight != null) return inFlight;

    final generation = _decidedPaymentsGeneration;
    Future<List<Payment>>? trackedFuture;
    trackedFuture = _fetchDecidedPayments(generation).whenComplete(() {
      if (identical(_decidedPaymentsInFlight, trackedFuture)) {
        _decidedPaymentsInFlight = null;
      }
    });
    _decidedPaymentsInFlight = trackedFuture;
    return trackedFuture;
  }

  Future<List<Payment>> _fetchDecidedPayments(int generation) async {
    if (!await _isOnline()) {
      _logger.warning('Payments refresh skipped because the app is offline.');
      return _local.readDecidedPayments();
    }
    try {
      final payments =
          (await _remote.getPayments())
              .map((payment) => payment.toEntity())
              .where((payment) => payment.status != PaymentStatus.pending)
              .toList()
            ..sort(_compareMostRecent);
      if (generation != _decidedPaymentsGeneration) {
        _logger.warning(
          'Discarding stale decided-payments response after a mutation.',
        );
        return _local.readDecidedPayments();
      }
      await _cache(
        'decided payments',
        () => _local.replaceDecidedPayments(payments),
      );
      _logger.info('Decided payments refreshed.');
      return payments;
    } on NetworkFailure {
      _logger.warning('Payments refresh failed; using cached payments.');
      return _local.readDecidedPayments();
    }
  }

  @override
  Future<Payment> getPayment(String id) async {
    if (!await _isOnline()) return _cachedPayment(id);
    try {
      final payment = (await _remote.getPayment(id)).toEntity();
      _ensureDecided(payment);
      await _cache('payment detail', () => _local.saveDecidedPayment(payment));
      return payment;
    } on NetworkFailure {
      _logger.warning('Payment detail refresh failed; using cached payment.');
      return _cachedPayment(id);
    }
  }

  @override
  Future<Payment> createDemoRequest() async {
    if (!await _isOnline()) {
      _logger.warning('Create request blocked while offline.');
      throw const NetworkFailure(code: 'offline_create_request');
    }
    _logger.info('Creating a payment request.');
    try {
      final request = (await _remote.createRequest()).toEntity();
      _logger.info('Payment request created.');
      return request;
    } catch (error) {
      _logger.error('Payment request creation failed.', error);
      rethrow;
    }
  }

  @override
  Future<void> deletePayment(String id) async {
    if (!await _isOnline()) {
      _logger.warning('Delete payment blocked while offline.');
      throw const NetworkFailure(code: 'offline_delete_payment');
    }
    _logger.info('Deleting payment $id from the API.');
    try {
      _invalidateDecidedPaymentsInFlight();
      await _remote.deletePayment(id);
      await _cache('deleted payment', () => _local.deletePayment(id));
      _logger.info('Payment $id deleted.');
    } catch (error) {
      _logger.error('Payment deletion failed.', error);
      rethrow;
    }
  }

  @override
  Future<int> deletePayments(List<String> ids) async {
    if (!await _isOnline()) {
      _logger.warning('Bulk delete payments blocked while offline.');
      throw const NetworkFailure(code: 'offline_delete_payment');
    }
    _logger.info('Deleting ${ids.length} payments from the API.');
    try {
      _invalidateDecidedPaymentsInFlight();
      final deletedCount = await _remote.deletePayments(ids);
      await _cache('deleted payments', () => _local.deletePayments(ids));
      _logger.info('$deletedCount payments deleted.');
      return deletedCount;
    } catch (error) {
      _logger.error('Bulk payment deletion failed.', error);
      rethrow;
    }
  }

  @override
  Future<Payment> decidePayment(
    Payment payment,
    PaymentStatus status,
    String otp,
  ) async {
    if (!await _isOnline()) {
      _logger.warning('Decision blocked while offline.');
      throw const NetworkFailure(code: 'offline_decision');
    }
    _logger.info('Submitting a payment decision.');
    try {
      _invalidateDecidedPaymentsInFlight();
      final decided = (await _remote.decide(
        payment.id,
        status == PaymentStatus.approved,
        otp,
      )).toEntity();
      _ensureDecided(decided);
      await _cache('decided payment', () async {
        await _local.deletePayment(payment.id);
        await _local.saveDecidedPayment(decided);
      });
      _logger.info('Payment decision completed.');
      return decided;
    } catch (error) {
      _logger.error('Payment decision failed.', error);
      rethrow;
    }
  }

  Future<bool> _isOnline() => _connectivity.isOnline;

  Future<void> _cache(
    String resource,
    Future<void> Function() operation,
  ) async {
    try {
      await operation();
    } catch (error) {
      _logger.error('Unable to cache $resource.', error);
    }
  }

  Future<Payment> _cachedPayment(String id) async {
    final payment = await _local.readPayment(id);
    if (payment == null) {
      throw const PaymentApiFailure(code: 'payment_not_found');
    }
    _ensureDecided(payment);
    return payment;
  }

  Future<PaymentSummary> _cachedSummaryOrDerived(String month) async {
    PaymentSummary? cached;
    try {
      cached = await _local.readSummary(month);
    } on LocalStorageFailure {
      _logger.warning('Summary cache read failed; trying decided cache.');
    }
    try {
      final payments = await _local.readDecidedPayments();
      return PaymentSummary.fromDecidedPayments(month, payments);
    } on LocalStorageFailure {
      if (cached != null) return cached;
      rethrow;
    }
  }

  void _ensureDecided(Payment payment) {
    if (payment.status == PaymentStatus.pending) {
      throw const PaymentApiFailure(code: 'payment_not_decided');
    }
  }

  int _compareMostRecent(Payment left, Payment right) {
    final leftDate = left.occurredAt;
    final rightDate = right.occurredAt;
    if (leftDate == null && rightDate == null) return 0;
    if (leftDate == null) return 1;
    if (rightDate == null) return -1;
    return rightDate.compareTo(leftDate);
  }
}
