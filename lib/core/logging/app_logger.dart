import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

abstract interface class AppLogger {
  void info(String message);
  void warning(String message);
  void error(String message, [Object? exception]);
}

final class DebugAppLogger implements AppLogger {
  const DebugAppLogger();

  @override
  void info(String message) => _write('fvelox.info', message);

  @override
  void warning(String message) => _write('fvelox.warning', message, level: 900);

  @override
  void error(String message, [Object? exception]) => _write(
    'fvelox.error',
    exception == null ? message : '$message\nexception: $exception',
    error: exception,
    level: 1000,
  );

  void _write(String name, String message, {int level = 0, Object? error}) {
    developer.log(message, name: name, error: error, level: level);
    if (kDebugMode) debugPrint('[$name]\n$message');
  }
}
