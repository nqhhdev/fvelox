import 'package:flutter/material.dart';

import 'package:fvelox/core/design_system/fvelox_design_system.dart';
import 'package:fvelox/l10n/fvelox_localizations_extensions.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({this.onRetry, super.key});

  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final design = FveloxDesignSystem.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: design.colors.paper,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              context.l10n.noDecidedPayments,
              style: design.typography.bodyMuted.copyWith(
                color: design.colors.muted,
              ),
            ),
          ),
          if (onRetry != null)
            TextButton(onPressed: onRetry, child: Text(context.l10n.retry)),
        ],
      ),
    );
  }
}
