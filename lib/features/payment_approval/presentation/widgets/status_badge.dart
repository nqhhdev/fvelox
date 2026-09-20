import 'package:flutter/material.dart';

import 'package:fvelox/core/design_system/fvelox_design_system.dart';
import 'package:fvelox/features/payment_approval/domain/entities/payment.dart';
import 'package:fvelox/l10n/fvelox_localizations_extensions.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({required this.status, super.key});
  final PaymentStatus status;
  @override
  Widget build(BuildContext context) {
    final design = FveloxDesignSystem.of(context);
    final l10n = context.l10n;
    final approved = status == PaymentStatus.approved;
    final color = approved ? design.colors.green : design.colors.red;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: approved ? design.colors.softGreen : design.colors.softRed,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(approved ? Icons.check : Icons.close, size: 13, color: color),
          const SizedBox(width: 4),
          Text(
            approved ? l10n.approved : l10n.rejected,
            style: design.typography.badge.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
