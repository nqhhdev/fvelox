import 'package:flutter/material.dart';

import 'package:fvelox/core/design_system/fvelox_design_system.dart';
import 'package:fvelox/l10n/fvelox_localizations_extensions.dart';

final class PaymentLoadError extends StatelessWidget {
  const PaymentLoadError({
    required this.message,
    required this.onRetry,
    this.centered = false,
    super.key,
  });

  final String message;
  final VoidCallback onRetry;
  final bool centered;

  @override
  Widget build(BuildContext context) {
    final design = FveloxDesignSystem.of(context);
    final content = [
      Flexible(
        child: Text(
          message,
          textAlign: centered ? TextAlign.center : TextAlign.start,
          style: design.typography.error.copyWith(color: design.colors.red),
        ),
      ),
      TextButton(onPressed: onRetry, child: Text(context.l10n.retry)),
    ];

    return centered
        ? Column(mainAxisSize: MainAxisSize.min, children: content)
        : Row(children: content);
  }
}
