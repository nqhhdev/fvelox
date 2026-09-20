import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fvelox/core/errors/app_failure.dart';
import 'package:fvelox/core/network/exceptions/api_dio_exception.dart';
import 'package:fvelox/core/network/extensions/dio_exception_extension.dart';

void main() {
  test('recognizes Dio transport failures', () {
    final exception = DioException(
      requestOptions: RequestOptions(path: '/payments'),
      type: DioExceptionType.receiveTimeout,
    );

    expect(exception.isNetworkFailure, isTrue);
  });

  test('maps API exception extension to an application failure', () {
    final source = DioException(
      requestOptions: RequestOptions(path: '/payments'),
      response: Response<dynamic>(
        requestOptions: RequestOptions(path: '/payments'),
        statusCode: 422,
      ),
    );
    final exception = ApiDioException(apiCode: 'invalid_otp', source: source);

    final failure = exception.paymentApiFailure;

    expect(failure, isA<PaymentApiFailure>());
    expect(failure.code, 'invalid_otp');
    expect(failure.statusCode, 422);
  });
}
