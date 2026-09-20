import 'package:flutter/material.dart';

import 'package:fvelox/core/design_system/fvelox_design_system.dart';
import 'package:fvelox/l10n/fvelox_localizations_extensions.dart';

class PaymentFloatingActionButton extends StatelessWidget {
  const PaymentFloatingActionButton({
    required this.onPressed,
    this.isActive = false,
    this.isEnabled = true,
    super.key,
  });

  final VoidCallback onPressed;
  final bool isActive;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final colors = FveloxDesignSystem.of(context).colors;

    return AnimatedScale(
      scale: isActive ? 1.06 : 1,
      duration: const Duration(milliseconds: 140),
      curve: Curves.easeOutCubic,
      child: AnimatedOpacity(
        opacity: isActive ? 1 : .72,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        child: FloatingActionButton(
          shape: const CircleBorder(),
          elevation: isActive ? 8 : 2,
          focusElevation: 10,
          hoverElevation: 8,
          highlightElevation: 10,
          backgroundColor: isActive
              ? colors.lime
              : colors.lime.withValues(alpha: .72),
          foregroundColor: isActive
              ? colors.greenDark
              : colors.greenDark.withValues(alpha: .84),
          onPressed: isEnabled ? onPressed : null,
          tooltip: context.l10n.createIncomingPaymentRequest,
          child: const Icon(Icons.add, size: 28),
        ),
      ),
    );
  }
}
