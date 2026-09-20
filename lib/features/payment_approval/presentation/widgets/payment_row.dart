import 'package:flutter/material.dart';

import 'package:fvelox/core/design_system/fvelox_design_system.dart';
import 'package:fvelox/features/payment_approval/domain/entities/payment.dart';
import 'package:fvelox/features/payment_approval/presentation/widgets/payment_delete_background.dart';
import 'package:fvelox/features/payment_approval/presentation/widgets/status_badge.dart';
import 'package:fvelox/l10n/fvelox_localizations_extensions.dart';

class PaymentRow extends StatelessWidget {
  const PaymentRow({
    required this.payment,
    required this.onTap,
    this.onDelete,
    super.key,
  });
  final Payment payment;
  final VoidCallback onTap;
  final Future<bool> Function(Payment payment)? onDelete;

  @override
  Widget build(BuildContext context) {
    final design = FveloxDesignSystem.of(context);
    return Dismissible(
      key: ValueKey('payment-row-${payment.id}'),
      direction: onDelete == null
          ? DismissDirection.none
          : DismissDirection.endToStart,
      dismissThresholds: const {DismissDirection.endToStart: .3},
      movementDuration: const Duration(milliseconds: 220),
      // List state removes this row as soon as delete succeeds; skip resize wait
      // so a dismissed Dismissible is not rebuilt while still in the tree.
      resizeDuration: Duration.zero,
      confirmDismiss: onDelete == null ? null : (_) => onDelete!(payment),
      onDismissed: (_) {},
      background: const SizedBox.shrink(),
      secondaryBackground: const PaymentDeleteBackground(),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 9),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(18),
            child: Container(
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: design.colors.paper.withValues(alpha: .7),
                border: Border.all(color: design.colors.border),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          payment.party,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: design.typography.rowTitle,
                        ),
                        const SizedBox(height: 6),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            context.l10n.amountAed(
                              payment.amount.toStringAsFixed(2),
                            ),
                            style: design.typography.rowAmount,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      StatusBadge(status: payment.status),
                      const SizedBox(height: 7),
                      Icon(Icons.chevron_right, color: design.colors.muted),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
