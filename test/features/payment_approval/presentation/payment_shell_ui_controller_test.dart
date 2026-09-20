import 'package:flutter_test/flutter_test.dart';

import 'package:fvelox/features/payment_approval/presentation/view_models/shell/payment_shell_ui_controller.dart';
import 'package:fvelox/features/payment_approval/presentation/view_models/shell/payment_shell_ui_state.dart';

void main() {
  late PaymentShellUiController controller;

  setUp(() => controller = PaymentShellUiController());
  tearDown(() => controller.dispose());

  test('keeps tab selection in shell UI state', () {
    controller.selectTab(PaymentTab.payments);

    expect(controller.state.selectedTab, PaymentTab.payments);
  });

  test('moves and snaps the floating action button to an edge', () {
    controller.beginFabInteraction();

    controller.snapFabToEdge(
      currentPosition: const Offset(20, 30),
      screenWidth: 400,
      leftPosition: 16,
      rightPosition: 328,
    );

    expect(controller.state.fabPosition, const Offset(16, 30));
    expect(controller.state.isFabInteracting, isFalse);
    expect(controller.state.fabPositionRevision, 1);
  });
}
