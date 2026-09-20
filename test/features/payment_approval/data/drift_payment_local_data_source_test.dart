import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fvelox/core/local_database/fvelox_database.dart';
import 'package:fvelox/features/payment_approval/data/data_sources/drift_payment_local_data_source.dart';
import 'package:fvelox/features/payment_approval/domain/entities/payment.dart';
import 'package:fvelox/features/payment_approval/domain/entities/payment_feature.dart';
import 'package:fvelox/features/payment_approval/domain/entities/payment_summary.dart';

void main() {
  late FveloxDatabase database;
  late DriftPaymentLocalDataSource dataSource;

  setUp(() {
    database = FveloxDatabase(NativeDatabase.memory());
    dataSource = DriftPaymentLocalDataSource(database.paymentDao);
  });

  tearDown(() async => database.close());

  test('stores decided payments without a pending cache', () async {
    const approved = Payment(
      id: 'approved-1',
      party: 'Mamo Technologies',
      amount: 8400,
      status: PaymentStatus.approved,
      dateLabel: '19 Sep 2026',
      reference: 'MAMO-01',
      note: 'Retainer',
    );
    await dataSource.replaceDecidedPayments([approved]);

    expect(await dataSource.readDecidedPayments(), [approved]);
    expect(await dataSource.readPayment(approved.id), approved);
  });

  test('stores feature flags and monthly summaries', () async {
    const feature = PaymentFeature(enabled: false, authRequired: true);
    const summary = PaymentSummary(
      month: '2026-09',
      currency: 'AED',
      totalAmount: 8400,
      totalAmountMinor: 840000,
      paymentCount: 1,
    );

    await dataSource.saveFeature(feature);
    await dataSource.saveSummary(summary);

    final cachedFeature = await dataSource.readFeature();
    final cachedSummary = await dataSource.readSummary('2026-09');
    expect(cachedFeature?.enabled, isFalse);
    expect(cachedFeature?.authRequired, isTrue);
    expect(cachedSummary?.totalAmountMinor, 840000);
    expect(cachedSummary?.paymentCount, 1);
  });

  test(
    'removes a decided payment from cache after a decision update',
    () async {
      const payment = Payment(
        id: 'payment-1',
        party: 'Noura Studio',
        amount: 1280,
        status: PaymentStatus.pending,
        dateLabel: '18 Sep 2026',
        reference: 'NS-01',
        note: 'Campaign production',
      );
      await dataSource.saveDecidedPayment(payment);

      await dataSource.deletePayment(payment.id);

      expect(await dataSource.readPayment(payment.id), isNull);
    },
  );
}
