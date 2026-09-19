import 'package:dio/dio.dart';

import 'package:fvelox/core/network/exceptions/api_dio_exception.dart';

class ApiErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final code = _apiCode(err.response?.data);
    if (code == null || err is ApiDioException) {
      handler.next(err);
      return;
    }
    handler.reject(ApiDioException(apiCode: code, source: err));
  }

  String? _apiCode(Object? data) {
    if (data is Map<String, dynamic> && data['error'] is String) {
      return data['error'] as String;
    }
    return null;
  }
}
