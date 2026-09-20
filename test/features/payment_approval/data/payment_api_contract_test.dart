import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fvelox/core/errors/app_failure.dart';
import 'package:fvelox/core/logging/app_logger.dart';
import 'package:fvelox/core/network/dio_client.dart';
import 'package:fvelox/features/payment_approval/data/data_sources/dio_payment_remote_data_source.dart';

void main() {
  test('accepts backend Unix timestamps in payment responses', () async {
    final logger = _RecordingLogger();
    final source = _source(
      logger,
      '{"data":{"items":[${_paymentJson()}]},"error":null}',
    );

    final payments = await source.getRequests();

    expect(payments, hasLength(1));
    expect(payments.single.createdAt.year, 2026);
    expect(payments.single.createdAt.month, 9);
    expect(payments.single.createdAt.day, 20);
  });

  test('logs the original response parsing error', () async {
    final logger = _RecordingLogger();
    final source = _source(
      logger,
      '{"data":{"items":[${_paymentJson(createdAt: '{"bad":true}')} ]},'
      '"error":null}',
    );

    await expectLater(
      source.getRequests(),
      throwsA(
        isA<PaymentApiFailure>().having(
          (failure) => failure.code,
          'code',
          'invalid_response',
        ),
      ),
    );

    expect(logger.errors.single, contains('[API][PARSE_ERROR]'));
    expect(logger.errors.single, contains('GET /payment-approval/requests'));
    expect(logger.errors.single, contains('FormatException'));
  });

  test('rejects unknown payment status as an invalid response', () async {
    final logger = _RecordingLogger();
    final source = _source(
      logger,
      '{"data":{"items":[${_paymentJson(status: 'UNKNOWN')}]},'
      '"error":null}',
    );

    await expectLater(
      source.getRequests(),
      throwsA(
        isA<PaymentApiFailure>().having(
          (failure) => failure.code,
          'code',
          'invalid_response',
        ),
      ),
    );
    expect(logger.errors.single, contains('Unknown payment status'));
  });

  test('deletes one payment with a 204 response', () async {
    final source = _source(_RecordingLogger(), '', status: 204);

    await source.deletePayment('payment-1');
  });

  test('parses the bulk delete count', () async {
    final source = _source(
      _RecordingLogger(),
      '{"data":{"deleted":2},"error":null}',
    );

    expect(await source.deletePayments(['payment-1', 'payment-2']), 2);
  });

  test('preserves the single delete not-found code', () async {
    final source = _source(
      _RecordingLogger(),
      '{"data":null,"error":"payment_not_found"}',
      status: 404,
    );

    await expectLater(
      source.deletePayment('missing-payment'),
      throwsA(
        isA<PaymentApiFailure>().having(
          (failure) => failure.code,
          'code',
          'payment_not_found',
        ),
      ),
    );
  });

  test('preserves the bulk invalid ids code', () async {
    final source = _source(
      _RecordingLogger(),
      '{"data":null,"error":"invalid_ids"}',
      status: 400,
    );

    await expectLater(
      source.deletePayments(const []),
      throwsA(
        isA<PaymentApiFailure>().having(
          (failure) => failure.code,
          'code',
          'invalid_ids',
        ),
      ),
    );
  });
}

DioPaymentRemoteDataSource _source(
  _RecordingLogger logger,
  String body, {
  int status = 200,
}) {
  final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))
    ..httpClientAdapter = _JsonAdapter(body, status);
  return DioPaymentRemoteDataSource(
    FveloxDioClient(dio: dio, logger: logger, enableApiLogging: false),
    logger,
  );
}

String _paymentJson({
  String createdAt = '1789901141.25194',
  String status = 'PENDING',
}) =>
    '''
{
  "id": "payment-1",
  "amount": 100.0,
  "currency": "AED",
  "status": "$status",
  "reference": "PAY-0001",
  "note": "Demo incoming payment",
  "recipient_name": "Mariam S.",
  "amount_minor": 10000,
  "created_at": $createdAt,
  "decided_at": null
}
''';

final class _RecordingLogger implements AppLogger {
  final errors = <String>[];

  @override
  void info(String message) {}

  @override
  void warning(String message) {}

  @override
  void error(String message, [Object? exception]) => errors.add(message);
}

final class _JsonAdapter implements HttpClientAdapter {
  const _JsonAdapter(this.body, this.status);

  final String body;
  final int status;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async => ResponseBody.fromString(
    body,
    status,
    headers: {
      Headers.contentTypeHeader: ['application/json'],
    },
  );

  @override
  void close({bool force = false}) {}
}
