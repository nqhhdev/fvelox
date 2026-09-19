import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:fvelox/core/connectivity/connectivity_service_base.dart';

final class DeviceConnectivityService implements ConnectivityService {
  DeviceConnectivityService(this._connectivity);

  final Connectivity _connectivity;

  @override
  Future<bool> get isOnline async =>
      _hasConnection(await _connectivity.checkConnectivity());

  @override
  Stream<bool> get statusChanges =>
      _connectivity.onConnectivityChanged.map(_hasConnection).distinct();

  bool _hasConnection(List<ConnectivityResult> results) =>
      results.any((result) => result != ConnectivityResult.none);
}
