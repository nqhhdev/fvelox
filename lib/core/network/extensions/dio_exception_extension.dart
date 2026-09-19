import 'package:dio/dio.dart';

import 'package:fvelox/core/errors/app_failure.dart';
import 'package:fvelox/core/network/exceptions/api_dio_exception.dart';

extension DioExceptionExtension on DioException {
  bool get isNetworkFailure => switch (type) {
    DioExceptionType.connectionError ||
    DioExceptionType.connectionTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout => true,
    _ => false,
  };

  String get apiErrorCode {
    if (this is ApiDioException) {
      return (this as ApiDioException).apiCode;
    }
    final body = response?.data;
    if (body is Map<String, dynamic> && body['error'] is String) {
      return body['error'] as String;
    }
    return message ?? 'unknown_error';
  }

  PaymentApiFailure get paymentApiFailure =>
      PaymentApiFailure(code: apiErrorCode, statusCode: response?.statusCode);
}
