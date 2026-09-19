import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:fvelox/core/design_system/fvelox_toast_message.dart';

final class FveloxToastController extends ChangeNotifier {
  FveloxToastController({this.duration = const Duration(seconds: 3)});

  final Duration duration;
  Timer? _dismissTimer;
  FveloxToastMessage? _message;
  int _nextId = 0;

  FveloxToastMessage? get message => _message;

  void showSuccess(String message) =>
      show(message: message, type: FveloxToastType.success);

  void showError(String message) =>
      show(message: message, type: FveloxToastType.error);

  void show({required String message, required FveloxToastType type}) {
    _dismissTimer?.cancel();
    _message = FveloxToastMessage(id: _nextId++, message: message, type: type);
    notifyListeners();
    _dismissTimer = Timer(duration, _dismiss);
  }

  void dismiss() => _dismiss();

  void _dismiss() {
    _dismissTimer?.cancel();
    _dismissTimer = null;
    if (_message == null) return;
    _message = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    super.dispose();
  }
}
