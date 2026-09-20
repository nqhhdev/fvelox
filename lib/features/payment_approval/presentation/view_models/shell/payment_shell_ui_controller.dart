import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fvelox/features/payment_approval/presentation/view_models/shell/payment_shell_ui_state.dart';

final class PaymentShellUiController
    extends StateNotifier<PaymentShellUiState> {
  PaymentShellUiController() : super(const PaymentShellUiState());

  void selectTab(PaymentTab tab) {
    state = state.copyWith(selectedTab: tab);
  }

  void beginFabInteraction() {
    if (state.isFabInteracting) return;
    state = state.copyWith(isFabInteracting: true);
  }

  void snapFabToEdge({
    required Offset currentPosition,
    required double screenWidth,
    required double leftPosition,
    required double rightPosition,
  }) {
    final targetX = currentPosition.dx < screenWidth / 2
        ? leftPosition
        : rightPosition;
    state = state.copyWith(
      fabPosition: Offset(targetX, currentPosition.dy),
      fabPositionRevision: state.fabPositionRevision + 1,
      isFabInteracting: false,
    );
  }
}
