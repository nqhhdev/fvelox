import 'package:flutter/material.dart';

import 'package:fvelox/core/design_system/fvelox_design_system.dart';
import 'package:fvelox/l10n/fvelox_localizations_extensions.dart';

final class PaymentDeleteBackground extends StatelessWidget {
  const PaymentDeleteBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final design = FveloxDesignSystem.of(context);
    return Semantics(
      button: true,
      label: context.l10n.deletePayment,
      child: Container(
        margin: const EdgeInsets.only(bottom: 9),
        padding: const EdgeInsets.symmetric(horizontal: 18),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          color: design.colors.softRed,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: design.colors.red.withValues(alpha: .18)),
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: design.colors.red,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: design.colors.red.withValues(alpha: .22),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(11),
            child: Icon(
              Icons.delete_outline_rounded,
              size: 22,
              color: design.colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
