import 'package:flutter/material.dart';

import 'package:fvelox/core/design_system/fvelox_design_system.dart';
import 'package:fvelox/features/payment_approval/domain/entities/payment.dart';
import 'package:fvelox/features/payment_approval/presentation/widgets/detail_line.dart';
import 'package:fvelox/features/payment_approval/presentation/widgets/eyebrow.dart';
import 'package:fvelox/features/payment_approval/presentation/widgets/status_badge.dart';
import 'package:fvelox/l10n/fvelox_localizations_extensions.dart';

class PaymentDetailsScreen extends StatelessWidget {
  const PaymentDetailsScreen({
    required this.payment,
    required this.returnLabel,
    required this.onBack,
    super.key,
  });
  final Payment payment;
  final String returnLabel;
  final VoidCallback onBack;
  @override
  Widget build(BuildContext context) {
    final design = FveloxDesignSystem.of(context);
    final l10n = context.l10n;
    return SingleChildScrollView(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: TextButton.icon(
              onPressed: onBack,
              icon: const Icon(Icons.chevron_left),
              label: Text(l10n.backTo(returnLabel)),
              style: TextButton.styleFrom(
                foregroundColor: design.colors.muted,
                padding: EdgeInsets.zero,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Eyebrow(l10n.paymentDetails),
                const SizedBox(height: 8),
                Text(
                  payment.party,
                  style: design.typography.detailTitle.copyWith(
                    color: design.colors.ink,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: design.colors.paper,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: design.colors.borderStrong,
                        blurRadius: 30,
                        offset: Offset(0, 14),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StatusBadge(status: payment.status),
                      const SizedBox(height: 14),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          l10n.amountAed(payment.amount.toStringAsFixed(2)),
                          style: design.typography.heroAmount.copyWith(
                            color: design.colors.ink,
                          ),
                        ),
                      ),
                      DetailLine(label: l10n.date, value: payment.dateLabel),
                      DetailLine(
                        label: l10n.reference,
                        value: payment.reference,
                      ),
                      DetailLine(label: l10n.note, value: payment.note),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
