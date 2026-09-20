import 'package:flutter/material.dart';

import 'package:fvelox/core/design_system/fvelox_design_system.dart';
import 'package:fvelox/l10n/fvelox_localizations_extensions.dart';

class PaymentRequestLoadingOverlay extends StatelessWidget {
  const PaymentRequestLoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = FveloxDesignSystem.of(context).colors;
    return Stack(
      fit: StackFit.expand,
      children: [
        const ModalBarrier(dismissible: false, color: Colors.transparent),
        Center(
          child: Semantics(
            label: context.l10n.loading,
            liveRegion: true,
            child: CircularProgressIndicator(
              color: colors.green,
              strokeWidth: 3,
            ),
          ),
        ),
      ],
    );
  }
}
