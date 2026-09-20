import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fvelox/core/logging/app_logger.dart';
import 'package:fvelox/core/network/interceptors/api_trace_interceptor.dart';

void main() {
  test('logs full request and response details', () async {
    final logger = _RecordingLogger();
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))
      ..httpClientAdapter = _SuccessfulAdapter()
      ..interceptors.add(ApiTraceInterceptor(logger));

    await dio.post<void>(
      '/payment-approval/requests',
      queryParameters: {'month': '2026-09'},
      data: {'amount': 100},
    );

    expect(logger.infos.first, contains('[API][REQUEST]'));
    expect(logger.infos.first, contains('POST https://example.test'));
    expect(logger.infos.first, contains('2026-09'));
    expect(logger.infos.first, contains('amount'));
    expect(logger.infos.last, contains('[API][RESPONSE]'));
    expect(logger.infos.last, contains('payment-1'));
  });

  test('redacts credentials and payment-sensitive values', () async {
    final logger = _RecordingLogger();
    final dio = Dio(BaseOptions(baseUrl: 'https://example.test'))
      ..httpClientAdapter = _SuccessfulAdapter()
      ..interceptors.add(ApiTraceInterceptor(logger));

    await dio.post<void>(
      '/payment-approval/requests',
      options: Options(headers: {'Authorization': 'Bearer secret-token'}),
      data: {'otp': '8888', 'amount': 100, 'recipient_name': 'Ahmed K.'},
    );

    final requestLog = logger.infos.first;
    expect(requestLog, contains('"Authorization": "<redacted>"'));
    expect(requestLog, contains('"otp": "<redacted>"'));
    expect(requestLog, isNot(contains('secret-token')));
    expect(requestLog, isNot(contains('8888')));
    expect(requestLog, isNot(contains('Ahmed K.')));
  });
}

final class _RecordingLogger implements AppLogger {
  final infos = <String>[];

  @override
  void info(String message) => infos.add(message);

  @override
  void warning(String message) {}

  @override
  void error(String message, [Object? exception]) {}
}

final class _SuccessfulAdapter implements HttpClientAdapter {
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async => ResponseBody.fromString(
    '{"data":{"id":"payment-1"}}',
    200,
    headers: {
      Headers.contentTypeHeader: ['application/json'],
    },
  );

  @override
  void close({bool force = false}) {}
}
