import 'package:flutter/material.dart';
import 'package:flutter_floaty/flutter_floaty.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fvelox/core/design_system/fvelox_design_system.dart';
import 'package:fvelox/features/payment_approval/presentation/providers/payment_providers.dart';
import 'package:fvelox/features/payment_approval/presentation/widgets/payment_floating_action_button.dart';
import 'package:fvelox/features/payment_approval/presentation/widgets/payment_floating_action_layer.dart';
import 'package:fvelox/l10n/fvelox_localizations_extensions.dart';

final class PaymentFloatingActionLayerState
    extends ConsumerState<PaymentFloatingActionLayer> {
  late final ValueNotifier<Offset> _dragPosition;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _dragPosition = ValueNotifier(Offset.zero);
  }

  @override
  void dispose() {
    _dragPosition.dispose();
    super.dispose();
  }

  Rect _dragBoundaries(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final viewPadding = MediaQuery.paddingOf(context);
    return Rect.fromLTRB(
      PaymentFloatingActionLayer.edgeMargin,
      viewPadding.top + PaymentFloatingActionLayer.edgeMargin,
      size.width - PaymentFloatingActionLayer.edgeMargin,
      size.height -
          viewPadding.bottom -
          PaymentFloatingActionLayer.navigationBarClearance,
    );
  }

  Offset _initialPosition(BuildContext context, Offset? savedPosition) {
    final boundaries = _dragBoundaries(context);
    final maxX = boundaries.right - PaymentFloatingActionLayer.buttonSize;
    final maxY = boundaries.bottom - PaymentFloatingActionLayer.buttonSize;
    final position = savedPosition ?? Offset(maxX, maxY);
    return Offset(
      position.dx.clamp(boundaries.left, maxX),
      position.dy.clamp(boundaries.top, maxY),
    );
  }

  Offset _clampPosition(Offset position, Rect boundaries) {
    final maxX = boundaries.right - PaymentFloatingActionLayer.buttonSize;
    final maxY = boundaries.bottom - PaymentFloatingActionLayer.buttonSize;
    return Offset(
      position.dx.clamp(boundaries.left, maxX),
      position.dy.clamp(boundaries.top, maxY),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = FveloxDesignSystem.of(context).colors;
    final fabPresentation = ref.watch(
      paymentShellUiControllerProvider.select(
        (state) => (state.fabPositionRevision, state.isFabInteracting),
      ),
    );
    final isApprovalFlowOpen = ref.watch(
      paymentApprovalUiControllerProvider.select((state) => state.isFlowOpen),
    );
    final savedPosition = ref
        .read(paymentShellUiControllerProvider)
        .fabPosition;
    final initialPosition = _initialPosition(context, savedPosition);
    final boundaries = _dragBoundaries(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    if (!_isDragging) {
      _dragPosition.value = initialPosition;
    }

    return FlutterFloaty(
      key: ValueKey('payment-fab-${fabPresentation.$1}'),
      initialX: initialPosition.dx,
      initialY: initialPosition.dy,
      width: PaymentFloatingActionLayer.buttonSize,
      height: PaymentFloatingActionLayer.buttonSize,
      backgroundColor: Colors.transparent,
      onDragBackgroundColor: colors.lime.withValues(alpha: .24),
      borderRadius: PaymentFloatingActionLayer.buttonSize / 2,
      growingFactor: 1.12,
      enableAnimation: true,
      pinned: false,
      accessibilityLabel: context.l10n.createIncomingPaymentRequest,
      intrinsicBoundaries: boundaries,
      onDragStart: (_) {
        _isDragging = true;
        _dragPosition.value = initialPosition;
        ref
            .read(paymentShellUiControllerProvider.notifier)
            .beginFabInteraction();
      },
      onDragUpdate: (details) {
        _dragPosition.value = _clampPosition(
          _dragPosition.value + details.delta,
          boundaries,
        );
      },
      onDragEnd: (_) {
        _isDragging = false;
        ref
            .read(paymentShellUiControllerProvider.notifier)
            .snapFabToEdge(
              currentPosition: _dragPosition.value,
              screenWidth: screenWidth,
              leftPosition: boundaries.left,
              rightPosition:
                  boundaries.right - PaymentFloatingActionLayer.buttonSize,
            );
      },
      builder: (_) => PaymentFloatingActionButton(
        onPressed: widget.onPressed,
        isActive: fabPresentation.$2,
        isEnabled: !isApprovalFlowOpen,
      ),
    );
  }
}
