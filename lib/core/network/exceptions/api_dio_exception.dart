import 'package:dio/dio.dart';

class ApiDioException extends DioException {
  ApiDioException({required this.apiCode, required DioException source})
    : super(
        requestOptions: source.requestOptions,
        response: source.response,
        type: source.type,
        error: source.error,
        stackTrace: source.stackTrace,
        message: source.message,
      );

  final String apiCode;
}
