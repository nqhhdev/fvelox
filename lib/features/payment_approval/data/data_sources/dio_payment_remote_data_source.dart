import 'package:dio/dio.dart';

import 'package:fvelox/core/network/dio_client.dart';
import 'package:fvelox/core/network/extensions/dio_exception_extension.dart';
import 'package:fvelox/core/errors/app_failure.dart';
import 'package:fvelox/core/logging/app_logger.dart';
import 'package:fvelox/features/payment_approval/data/models/payment_dto.dart';
import 'package:fvelox/features/payment_approval/data/models/payment_feature_dto.dart';
import 'package:fvelox/features/payment_approval/data/models/payment_summary_dto.dart';
import 'package:fvelox/features/payment_approval/data/data_sources/payment_remote_data_source.dart';

final class DioPaymentRemoteDataSource implements PaymentRemoteDataSource {
  DioPaymentRemoteDataSource(this._client, this._logger);
  final FveloxDioClient _client;
  final AppLogger _logger;

  @override
  Future<PaymentFeatureDto> getFeature() async =>
      _execute('GET /features', () async {
        final response = await _client.dio.get('/features');
        final data = _unwrap<Map<String, dynamic>>(response);
        final feature = data['payment_approval'];
        return PaymentFeatureDto.fromJson(
          feature is Map<String, dynamic> ? feature : data,
        );
      });

  @override
  Future<PaymentSummaryDto> getSummary(String month) async =>
      _execute('GET /payment-approval/summary', () async {
        final response = await _client.dio.get(
          '/payment-approval/summary',
          queryParameters: {'month': month},
        );
        return PaymentSummaryDto.fromJson(
          _unwrap<Map<String, dynamic>>(response),
        );
      });

  @override
  Future<List<PaymentDto>> getPayments() async =>
      _execute('GET /payment-approval/payments', () async {
        final response = await _client.dio.get('/payment-approval/payments');
        return _items(response);
      });

  @override
  Future<PaymentDto> getPayment(String id) async => _execute(
    'GET /payment-approval/payments/$id',
    () async {
      final response = await _client.dio.get('/payment-approval/payments/$id');
      return PaymentDto.fromJson(_unwrap<Map<String, dynamic>>(response));
    },
  );

  @override
  Future<List<PaymentDto>> getRequests() async =>
      _execute('GET /payment-approval/requests', () async {
        final response = await _client.dio.get('/payment-approval/requests');
        return _items(response);
      });

  @override
  Future<PaymentDto> createRequest() async =>
      _execute('POST /payment-approval/requests', () async {
        final response = await _client.dio.post('/payment-approval/requests');
        return PaymentDto.fromJson(_unwrap<Map<String, dynamic>>(response));
      });

  @override
  Future<PaymentDto> decide(String id, bool approve, String otp) async =>
      _execute(
        'PUT /payment-approval/requests/$id/${approve ? 'approve' : 'reject'}',
        () async {
          final response = await _client.dio.put(
            '/payment-approval/requests/$id/${approve ? 'approve' : 'reject'}',
            data: {'otp': otp},
          );
          return PaymentDto.fromJson(_unwrap<Map<String, dynamic>>(response));
        },
      );

  @override
  Future<void> deletePayment(String id) async =>
      _execute('DELETE /payment-approval/payments/$id', () async {
        await _client.dio.delete('/payment-approval/payments/$id');
      });

  @override
  Future<int> deletePayments(List<String> ids) async =>
      _execute('DELETE /payment-approval/payments', () async {
        final response = await _client.dio.delete(
          '/payment-approval/payments',
          data: {'ids': ids},
        );
        final data = _unwrap<Map<String, dynamic>>(response);
        return (data['deleted'] as num).toInt();
      });

  Future<T> _execute<T>(String operation, Future<T> Function() request) async {
    try {
      return await request();
    } on DioException catch (error) {
      if (error.isNetworkFailure) throw const NetworkFailure();
      throw error.paymentApiFailure;
    } on AppFailure {
      rethrow;
    } catch (error, stackTrace) {
      _logger.error(
        '[API][PARSE_ERROR]\n'
        '$operation\n'
        'errorType: ${error.runtimeType}\n'
        'message: $error',
        error,
      );
      Error.throwWithStackTrace(
        PaymentApiFailure(code: 'invalid_response', message: error.toString()),
        stackTrace,
      );
    }
  }

  List<PaymentDto> _items(Response<dynamic> response) {
    final data = _unwrap<Map<String, dynamic>>(response);
    return (data['items'] as List<dynamic>)
        .map((item) => PaymentDto.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  T _unwrap<T>(Response<dynamic> response) {
    final body = response.data as Map<String, dynamic>;
    if (body['error'] != null) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: body['error'] as String,
      );
    }
    return body['data'] as T;
  }
}
