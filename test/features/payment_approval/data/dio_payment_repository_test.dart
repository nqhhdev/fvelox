import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

import 'package:fvelox/core/connectivity/connectivity_service.dart';
import 'package:fvelox/core/errors/app_failure.dart';
import 'package:fvelox/core/logging/app_logger.dart';
import 'package:fvelox/features/payment_approval/data/data_sources/in_memory_payment_local_data_source.dart';
import 'package:fvelox/features/payment_approval/data/data_sources/payment_remote_data_source.dart';
import 'package:fvelox/features/payment_approval/data/models/payment_dto.dart';
import 'package:fvelox/features/payment_approval/data/models/payment_feature_dto.dart';
import 'package:fvelox/features/payment_approval/data/models/payment_summary_dto.dart';
import 'package:fvelox/features/payment_approval/data/repositories/dio_payment_repository.dart';
import 'package:fvelox/features/payment_approval/domain/entities/payment.dart';
import 'package:fvelox/features/payment_approval/domain/entities/payment_summary.dart';

void main() {
  late InMemoryPaymentLocalDataSource local;
  late DioPaymentRepository repository;

  setUp(() {
    local = InMemoryPaymentLocalDataSource();
    repository = DioPaymentRepository(
      _FailingRemoteDataSource(),
      local,
      const _OfflineConnectivityService(),
      const _NoopLogger(),
    );
  });

  test('reads cached payments and summary while offline', () async {
    const payment = Payment(
      id: 'cached-1',
      party: 'Cached partner',
      amount: 100,
      status: PaymentStatus.approved,
      dateLabel: '20 Sep 2026',
      reference: 'CACHE-01',
      note: 'Cached payment',
    );
    await local.saveDecidedPayment(payment);
    await local.saveSummary(
      const PaymentSummary(
        month: '2026-09',
        currency: 'AED',
        totalAmount: 100,
        totalAmountMinor: 10000,
        paymentCount: 1,
      ),
    );

    final payments = await repository.getDecidedPayments();
    final summary = await repository.getSummary('2026-09');

    expect(payments, [payment]);
    expect(summary.totalAmount, 100);
    expect(summary.paymentCount, 1);
  });

  test('blocks financial mutations while offline', () async {
    await expectLater(
      repository.createDemoRequest(),
      throwsA(isA<NetworkFailure>()),
    );
    await expectLater(
      repository.decidePayment(
        const Payment(
          id: 'pending-1',
          party: 'Partner',
          amount: 100,
          status: PaymentStatus.pending,
          dateLabel: '20 Sep 2026',
          reference: 'PENDING-01',
          note: 'Pending',
        ),
        PaymentStatus.approved,
        '8888',
      ),
      throwsA(isA<NetworkFailure>()),
    );
  });

  test('sorts remote decided payments by decision time', () async {
    final onlineRepository = DioPaymentRepository(
      _UnsortedRemoteDataSource(),
      InMemoryPaymentLocalDataSource(),
      const _OnlineConnectivityService(),
      const _NoopLogger(),
    );

    final payments = await onlineRepository.getDecidedPayments();

    expect(payments.map((payment) => payment.id), ['newer', 'older']);
  });

  test(
    'deletes locally only after the single remote delete succeeds',
    () async {
      final remote = _DeletingRemoteDataSource();
      final cache = InMemoryPaymentLocalDataSource();
      final onlineRepository = DioPaymentRepository(
        remote,
        cache,
        const _OnlineConnectivityService(),
        const _NoopLogger(),
      );
      const payment = Payment(
        id: 'payment-1',
        party: 'Partner',
        amount: 100,
        status: PaymentStatus.approved,
        dateLabel: '20 Sep 2026',
        reference: 'PAY-01',
        note: 'Payment',
      );
      await cache.saveDecidedPayment(payment);

      await onlineRepository.deletePayment(payment.id);

      expect(remote.singleDeleteIds, [payment.id]);
      expect(await cache.readPayment(payment.id), isNull);
    },
  );

  test(
    'deletes every locally cached id after bulk remote delete succeeds',
    () async {
      final remote = _DeletingRemoteDataSource();
      final cache = InMemoryPaymentLocalDataSource();
      final onlineRepository = DioPaymentRepository(
        remote,
        cache,
        const _OnlineConnectivityService(),
        const _NoopLogger(),
      );
      const payments = [
        Payment(
          id: 'payment-1',
          party: 'Partner 1',
          amount: 100,
          status: PaymentStatus.approved,
          dateLabel: '20 Sep 2026',
          reference: 'PAY-01',
          note: 'Payment',
        ),
        Payment(
          id: 'payment-2',
          party: 'Partner 2',
          amount: 200,
          status: PaymentStatus.rejected,
          dateLabel: '20 Sep 2026',
          reference: 'PAY-02',
          note: 'Payment',
        ),
      ];
      for (final payment in payments) {
        await cache.saveDecidedPayment(payment);
      }

      final deleted = await onlineRepository.deletePayments(
        payments.map((payment) => payment.id).toList(),
      );

      expect(deleted, 2);
      expect(remote.bulkDeleteIds, [
        ['payment-1', 'payment-2'],
      ]);
      expect(await cache.readPayment('payment-1'), isNull);
      expect(await cache.readPayment('payment-2'), isNull);
    },
  );

  test(
    'derives the summary from the decided cache after delete when summary refresh fails',
    () async {
      final remote = _SummaryFailingRemoteDataSource();
      final cache = InMemoryPaymentLocalDataSource();
      final onlineRepository = DioPaymentRepository(
        remote,
        cache,
        const _OnlineConnectivityService(),
        const _NoopLogger(),
      );
      const payments = [
        Payment(
          id: 'approved-delete',
          party: 'Deleted approved payment',
          amount: 100,
          status: PaymentStatus.approved,
          dateLabel: '20 Sep 2026',
          reference: 'PAY-DELETE',
          note: 'Payment',
        ),
        Payment(
          id: 'approved-keep',
          party: 'Approved payment',
          amount: 50,
          status: PaymentStatus.approved,
          dateLabel: '20 Sep 2026',
          reference: 'PAY-KEEP',
          note: 'Payment',
        ),
        Payment(
          id: 'rejected',
          party: 'Rejected payment',
          amount: 1000,
          status: PaymentStatus.rejected,
          dateLabel: '20 Sep 2026',
          reference: 'PAY-REJECTED',
          note: 'Payment',
        ),
      ];
      for (final payment in payments) {
        await cache.saveDecidedPayment(payment);
      }
      await cache.saveSummary(
        const PaymentSummary(
          month: '2026-09',
          currency: 'AED',
          totalAmount: 1150,
          totalAmountMinor: 115000,
          paymentCount: 3,
        ),
      );

      await onlineRepository.deletePayment('approved-delete');

      final summary = await onlineRepository.getSummary('2026-09');

      expect(summary.totalAmount, 50);
      expect(summary.totalAmountMinor, 5000);
      expect(summary.paymentCount, 1);
    },
  );

  test(
    'derives the summary from the decided cache after decide when summary refresh fails',
    () async {
      final remote = _DecisionRemoteDataSource();
      final cache = InMemoryPaymentLocalDataSource();
      final onlineRepository = DioPaymentRepository(
        remote,
        cache,
        const _OnlineConnectivityService(),
        const _NoopLogger(),
      );
      const pending = Payment(
        id: 'pending-1',
        party: 'Pending partner',
        amount: 75,
        status: PaymentStatus.pending,
        dateLabel: '20 Sep 2026',
        reference: 'PAY-PENDING',
        note: 'Payment',
      );
      await cache.saveDecidedPayment(pending);

      await onlineRepository.decidePayment(
        pending,
        PaymentStatus.approved,
        '8888',
      );

      final summary = await onlineRepository.getSummary('2026-09');

      expect(summary.totalAmount, 75);
      expect(summary.paymentCount, 1);
    },
  );

  test(
    'coalesces concurrent decided-payment reads into one remote call',
    () async {
      final remote = _CountingPaymentsRemoteDataSource();
      final onlineRepository = DioPaymentRepository(
        remote,
        InMemoryPaymentLocalDataSource(),
        const _OnlineConnectivityService(),
        const _NoopLogger(),
      );

      final results = await Future.wait([
        onlineRepository.getDecidedPayments(),
        onlineRepository.getDecidedPayments(),
      ]);

      expect(remote.getPaymentsCalls, 1);
      expect(results[0].map((payment) => payment.id), ['coalesced']);
      expect(results[1].map((payment) => payment.id), ['coalesced']);
    },
  );

  test('discards a stale decided-payments response after delete', () async {
    final remote = _DelayedDeleteAwareRemoteDataSource();
    final cache = InMemoryPaymentLocalDataSource();
    final onlineRepository = DioPaymentRepository(
      remote,
      cache,
      const _OnlineConnectivityService(),
      const _NoopLogger(),
    );

    final staleRead = onlineRepository.getDecidedPayments();
    await remote.waitUntilGetPaymentsStarted();
    await onlineRepository.deletePayment('stale-delete');
    final stalePayments = await staleRead;
    final refreshed = await onlineRepository.getDecidedPayments();

    expect(stalePayments.map((payment) => payment.id), isEmpty);
    expect(refreshed.map((payment) => payment.id), isEmpty);
    expect(await cache.readDecidedPayments(), isEmpty);
  });
}

final class _OfflineConnectivityService implements ConnectivityService {
  const _OfflineConnectivityService();

  @override
  Future<bool> get isOnline async => false;

  @override
  Stream<bool> get statusChanges => const Stream<bool>.empty();
}

final class _NoopLogger implements AppLogger {
  const _NoopLogger();

  @override
  void info(String message) {}

  @override
  void warning(String message) {}

  @override
  void error(String message, [Object? exception]) {}
}

class _FailingRemoteDataSource implements PaymentRemoteDataSource {
  const _FailingRemoteDataSource();

  Never _unexpected() => throw StateError('Remote must not be called offline');

  @override
  Future<PaymentFeatureDto> getFeature() async => _unexpected();

  @override
  Future<PaymentSummaryDto> getSummary(String month) async => _unexpected();

  @override
  Future<List<PaymentDto>> getPayments() async => _unexpected();

  @override
  Future<PaymentDto> getPayment(String id) async => _unexpected();

  @override
  Future<List<PaymentDto>> getRequests() async => _unexpected();

  @override
  Future<PaymentDto> createRequest() async => _unexpected();

  @override
  Future<PaymentDto> decide(String id, bool approve, String otp) async =>
      _unexpected();

  @override
  Future<void> deletePayment(String id) async => _unexpected();

  @override
  Future<int> deletePayments(List<String> ids) async => _unexpected();
}

final class _OnlineConnectivityService implements ConnectivityService {
  const _OnlineConnectivityService();

  @override
  Future<bool> get isOnline async => true;

  @override
  Stream<bool> get statusChanges => const Stream<bool>.empty();
}

class _DeletingRemoteDataSource extends _FailingRemoteDataSource {
  final singleDeleteIds = <String>[];
  final bulkDeleteIds = <List<String>>[];

  @override
  Future<void> deletePayment(String id) async {
    singleDeleteIds.add(id);
  }

  @override
  Future<int> deletePayments(List<String> ids) async {
    bulkDeleteIds.add(List<String>.from(ids));
    return ids.length;
  }
}

final class _UnsortedRemoteDataSource extends _FailingRemoteDataSource {
  const _UnsortedRemoteDataSource();

  @override
  Future<List<PaymentDto>> getPayments() async => [
    _dto('older', DateTime(2026, 9, 19)),
    _dto('newer', DateTime(2026, 9, 20)),
  ];

  static PaymentDto _dto(String id, DateTime decidedAt) => PaymentDto(
    id: id,
    recipientName: id,
    amount: 100,
    amountMinor: 10000,
    currency: 'AED',
    status: PaymentStatus.approved,
    reference: id,
    note: '',
    createdAt: decidedAt,
    decidedAt: decidedAt,
  );
}

class _SummaryFailingRemoteDataSource extends _DeletingRemoteDataSource {
  @override
  Future<PaymentSummaryDto> getSummary(String month) async {
    throw const NetworkFailure();
  }
}

final class _DecisionRemoteDataSource extends _SummaryFailingRemoteDataSource {
  @override
  Future<PaymentDto> decide(String id, bool approve, String otp) async {
    final decidedAt = DateTime(2026, 9, 20);
    return PaymentDto(
      id: id,
      recipientName: 'Approved partner',
      amount: 75,
      amountMinor: 7500,
      currency: 'AED',
      status: PaymentStatus.approved,
      reference: 'PAY-DECIDED',
      note: 'Payment',
      createdAt: decidedAt,
      decidedAt: decidedAt,
    );
  }
}

final class _CountingPaymentsRemoteDataSource extends _FailingRemoteDataSource {
  int getPaymentsCalls = 0;

  @override
  Future<List<PaymentDto>> getPayments() async {
    getPaymentsCalls++;
    await Future<void>.delayed(const Duration(milliseconds: 10));
    final decidedAt = DateTime(2026, 9, 20);
    return [
      PaymentDto(
        id: 'coalesced',
        recipientName: 'Partner',
        amount: 10,
        amountMinor: 1000,
        currency: 'AED',
        status: PaymentStatus.approved,
        reference: 'PAY-COALESCED',
        note: 'Payment',
        createdAt: decidedAt,
        decidedAt: decidedAt,
      ),
    ];
  }
}

final class _DelayedDeleteAwareRemoteDataSource extends _FailingRemoteDataSource {
  final _getPaymentsStarted = Completer<void>();
  final _releaseGetPayments = Completer<void>();
  var _getPaymentsCalls = 0;

  Future<void> waitUntilGetPaymentsStarted() => _getPaymentsStarted.future;

  @override
  Future<List<PaymentDto>> getPayments() async {
    _getPaymentsCalls++;
    if (!_getPaymentsStarted.isCompleted) {
      _getPaymentsStarted.complete();
    }
    await _releaseGetPayments.future;
    // First response simulates a stale in-flight snapshot that still includes
    // the deleted payment. Later calls reflect the post-delete server state.
    if (_getPaymentsCalls > 1) return const [];
    final decidedAt = DateTime(2026, 9, 20);
    return [
      PaymentDto(
        id: 'stale-delete',
        recipientName: 'Partner',
        amount: 10,
        amountMinor: 1000,
        currency: 'AED',
        status: PaymentStatus.approved,
        reference: 'PAY-STALE',
        note: 'Payment',
        createdAt: decidedAt,
        decidedAt: decidedAt,
      ),
    ];
  }

  @override
  Future<void> deletePayment(String id) async {
    if (!_releaseGetPayments.isCompleted) {
      _releaseGetPayments.complete();
    }
  }

  @override
  Future<int> deletePayments(List<String> ids) async {
    if (!_releaseGetPayments.isCompleted) {
      _releaseGetPayments.complete();
    }
    return ids.length;
  }
}
