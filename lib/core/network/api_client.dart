abstract interface class ApiClient {
  Future<Object?> get(String path);
  Future<Object?> post(String path, {Object? body});
}

final class UnconfiguredApiClient implements ApiClient {
  const UnconfiguredApiClient();
  @override
  Future<Object?> get(String path) async => null;
  @override
  Future<Object?> post(String path, {Object? body}) async => null;
}
