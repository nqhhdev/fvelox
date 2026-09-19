import 'dart:async';

import 'package:dio/dio.dart';

class RetryInterceptor extends Interceptor {
  RetryInterceptor(
    this._dio, {
    this.maxAttempts = 2,
    this.delay = const Duration(milliseconds: 250),
  });
  final Dio _dio;
  final int maxAttempts;
  final Duration delay;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;
    final attempt = (options.extra['retry_attempt'] as int?) ?? 0;
    if (!_shouldRetry(err, options) || attempt >= maxAttempts) {
      handler.next(err);
      return;
    }
    options.extra['retry_attempt'] = attempt + 1;
    await Future<void>.delayed(delay * (attempt + 1));
    try {
      handler.resolve(await _dio.fetch(options));
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }

  bool _shouldRetry(DioException error, RequestOptions options) {
    if (options.method.toUpperCase() != 'GET' &&
        options.method.toUpperCase() != 'HEAD') {
      return false;
    }
    final status = error.response?.statusCode;
    return error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError ||
        status == 408 ||
        status == 429 ||
        (status != null && status >= 500);
  }
}
