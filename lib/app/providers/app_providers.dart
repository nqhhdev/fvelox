import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fvelox/core/connectivity/connectivity_service.dart';
import 'package:fvelox/core/design_system/fvelox_toast_controller.dart';
import 'package:fvelox/core/logging/app_logger.dart';
import 'package:fvelox/core/network/auth/auth_token_provider.dart';
import 'package:fvelox/core/network/auth/noop_auth_token_provider.dart';

final connectivityServiceProvider = Provider<ConnectivityService>(
  (ref) => DeviceConnectivityService(Connectivity()),
);
final connectivityStatusProvider = StreamProvider<bool>((ref) async* {
  final service = ref.watch(connectivityServiceProvider);
  yield await service.isOnline;
  yield* service.statusChanges;
});
final appLoggerProvider = Provider<AppLogger>((ref) => const DebugAppLogger());
final authTokenProvider = Provider<AuthTokenProvider>(
  (ref) => const NoopAuthTokenProvider(),
);
final fveloxToastControllerProvider = Provider<FveloxToastController>((ref) {
  final controller = FveloxToastController();
  ref.onDispose(controller.dispose);
  return controller;
});
