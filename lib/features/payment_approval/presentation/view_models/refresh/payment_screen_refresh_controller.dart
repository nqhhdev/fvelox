import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Emits a revision after a backend-confirmed mutation so each screen reloads
/// its own data through its own controller.
final class PaymentScreenRefreshController extends StateNotifier<int> {
  PaymentScreenRefreshController() : super(0);

  void requestRefresh() => state++;
}
