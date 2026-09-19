import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

import 'package:fvelox/core/logging/app_logger.dart';
import 'package:fvelox/core/network/auth/auth_token_provider.dart';
import 'package:fvelox/core/network/auth/noop_auth_token_provider.dart';
import 'package:fvelox/core/network/interceptors/api_error_interceptor.dart';
import 'package:fvelox/core/network/interceptors/api_trace_interceptor.dart';
import 'package:fvelox/core/network/interceptors/auth_interceptor.dart';
import 'package:fvelox/core/network/interceptors/retry_interceptor.dart';

final class FveloxDioClient {
  FveloxDioClient({
    Dio? dio,
    AuthTokenProvider? authTokenProvider,
    AppLogger? logger,
    bool? enableApiLogging,
  }) : dio = dio ?? Dio(_options) {
    this.dio.interceptors.add(RetryInterceptor(this.dio));
    this.dio.interceptors.add(
      AuthInterceptor(authTokenProvider ?? const NoopAuthTokenProvider()),
    );
    this.dio.interceptors.add(
      ApiTraceInterceptor(
        logger ?? const DebugAppLogger(),
        enabled: enableApiLogging ?? kDebugMode,
      ),
    );
    this.dio.interceptors.add(ApiErrorInterceptor());
  }
  static final _options = BaseOptions(
    baseUrl: 'https://ivelox-core.fly.dev/api/v1',
    headers: {'Content-Type': 'application/json'},
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  );
  final Dio dio;
}
