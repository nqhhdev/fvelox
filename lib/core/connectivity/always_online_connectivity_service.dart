import 'package:fvelox/core/connectivity/connectivity_service_base.dart';

final class AlwaysOnlineConnectivityService implements ConnectivityService {
  const AlwaysOnlineConnectivityService();

  @override
  Future<bool> get isOnline async => true;

  @override
  Stream<bool> get statusChanges => const Stream<bool>.empty();
}
