import 'package:fvelox/core/network/auth/auth_token_provider.dart';

final class NoopAuthTokenProvider implements AuthTokenProvider {
  const NoopAuthTokenProvider();
  @override
  Future<String?> readAccessToken() async => null;
}
