abstract interface class AuthTokenProvider {
  Future<String?> readAccessToken();
}
