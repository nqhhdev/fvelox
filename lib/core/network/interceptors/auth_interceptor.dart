import 'package:dio/dio.dart';

import 'package:fvelox/core/network/auth/auth_token_provider.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(
    this._tokenProvider, {
    this.publicPathPrefixes = const ['/payment-approval'],
  });
  final AuthTokenProvider _tokenProvider;
  final List<String> publicPathPrefixes;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final isPublicPath = publicPathPrefixes.any(
      (prefix) => options.path.startsWith(prefix),
    );
    if (isPublicPath) {
      handler.next(options);
      return;
    }
    final token = await _tokenProvider.readAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
