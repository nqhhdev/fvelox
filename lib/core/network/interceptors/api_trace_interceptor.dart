import 'dart:convert';

import 'package:dio/dio.dart';

import 'package:fvelox/core/logging/app_logger.dart';

final class ApiTraceInterceptor extends Interceptor {
  const ApiTraceInterceptor(this._logger, {this.enabled = true});

  final AppLogger _logger;
  final bool enabled;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (enabled) {
      _logger.info(
        '[API][REQUEST]\n'
        '${options.method} ${options.uri}\n'
        'headers: ${_serialize(options.headers)}\n'
        'query: ${_serialize(options.queryParameters)}\n'
        'extra: ${_serialize(options.extra)}\n'
        'body: ${_serialize(options.data)}',
      );
    }
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    if (enabled) {
      _logger.info(
        '[API][RESPONSE]\n'
        '${response.requestOptions.method} ${response.requestOptions.uri}\n'
        'status: ${response.statusCode} ${response.statusMessage ?? ''}\n'
        'headers: ${_serialize(response.headers.map)}\n'
        'body: ${_serialize(response.data)}',
      );
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (enabled) {
      final response = err.response;
      _logger.error(
        '[API][ERROR]\n'
        '${err.requestOptions.method} ${err.requestOptions.uri}\n'
        'type: ${err.type}\n'
        'message: ${err.message ?? ''}\n'
        'error: ${_serialize(err.error)}\n'
        'status: ${response?.statusCode ?? 'none'} '
        '${response?.statusMessage ?? ''}\n'
        'responseHeaders: ${_serialize(response?.headers.map)}\n'
        'responseBody: ${_serialize(response?.data)}',
        err,
      );
    }
    handler.next(err);
  }

  String _serialize(Object? value) {
    if (value == null) return 'null';
    try {
      return const JsonEncoder.withIndent('  ').convert(_redact(value));
    } catch (_) {
      return value.toString();
    }
  }

  Object? _redact(Object? value) {
    if (value is Map) {
      return value.map(
        (key, item) => MapEntry(
          key,
          _isSensitiveKey(key.toString()) ? '<redacted>' : _redact(item),
        ),
      );
    }
    if (value is Iterable) return value.map(_redact).toList(growable: false);
    return value;
  }

  bool _isSensitiveKey(String key) {
    final normalized = key.toLowerCase().replaceAll('-', '_');
    return normalized.contains('authorization') ||
        normalized.contains('cookie') ||
        normalized.contains('token') ||
        normalized.contains('secret') ||
        normalized.contains('password') ||
        normalized == 'otp' ||
        normalized == 'amount' ||
        normalized == 'amount_minor' ||
        normalized == 'recipient_name' ||
        normalized == 'recipientname' ||
        normalized == 'reference' ||
        normalized == 'note';
  }
}
