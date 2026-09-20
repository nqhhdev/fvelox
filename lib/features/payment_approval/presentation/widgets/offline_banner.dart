import 'package:flutter/material.dart';

import 'package:fvelox/core/design_system/fvelox_design_system.dart';
import 'package:fvelox/l10n/fvelox_localizations_extensions.dart';

class OfflineBanner extends StatelessWidget {
  const OfflineBanner({required this.onRetry, super.key});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final design = FveloxDesignSystem.of(context);
    final l10n = context.l10n;
    return Material(
      color: design.colors.softRed,
      child: InkWell(
        onTap: onRetry,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 9, 14, 9),
          child: Row(
            children: [
              Icon(
                Icons.cloud_off_outlined,
                size: 16,
                color: design.colors.red,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.offlineCachedPayments,
                  style: design.typography.caption.copyWith(
                    color: design.colors.red,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              TextButton(
                onPressed: onRetry,
                style: TextButton.styleFrom(
                  foregroundColor: design.colors.red,
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(44, 32),
                ),
                child: Text(l10n.retry),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
