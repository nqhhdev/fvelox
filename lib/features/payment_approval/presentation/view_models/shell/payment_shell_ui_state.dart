import 'package:flutter/material.dart';

enum PaymentTab { home, payments }

final class PaymentShellUiState {
  const PaymentShellUiState({
    this.selectedTab = PaymentTab.home,
    this.fabPosition,
    this.fabPositionRevision = 0,
    this.isFabInteracting = false,
  });

  final PaymentTab selectedTab;
  final Offset? fabPosition;
  final int fabPositionRevision;
  final bool isFabInteracting;

  PaymentShellUiState copyWith({
    PaymentTab? selectedTab,
    Offset? fabPosition,
    int? fabPositionRevision,
    bool? isFabInteracting,
  }) => PaymentShellUiState(
    selectedTab: selectedTab ?? this.selectedTab,
    fabPosition: fabPosition ?? this.fabPosition,
    fabPositionRevision: fabPositionRevision ?? this.fabPositionRevision,
    isFabInteracting: isFabInteracting ?? this.isFabInteracting,
  );
}
