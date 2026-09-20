import 'package:flutter/material.dart';

import 'package:fvelox/core/design_system/fvelox_design_system.dart';
import 'package:fvelox/l10n/fvelox_localizations_extensions.dart';

class SummaryCard extends StatelessWidget {
  const SummaryCard({required this.total, required this.count, super.key});
  final double total;
  final int count;
  @override
  Widget build(BuildContext context) {
    final design = FveloxDesignSystem.of(context);
    final l10n = context.l10n;
    return Container(
      width: double.infinity,
      height: 186,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: LinearGradient(
          colors: [design.colors.summaryStart, design.colors.summaryEnd],
        ),
        boxShadow: [
          BoxShadow(
            color: design.colors.shadow,
            blurRadius: 28,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.approvedThisMonth,
            style: design.typography.summaryLabel.copyWith(
              color: design.colors.summaryLabel,
            ),
          ),
          const SizedBox(height: 24),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              l10n.amountAed(total.toStringAsFixed(2)),
              style: design.typography.summaryAmount.copyWith(
                color: design.colors.summaryAmount,
              ),
            ),
          ),
          const Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: count > 0
                ? Text(
                    l10n.paymentCount(count),
                    style: design.typography.summaryCount.copyWith(
                      color: design.colors.summaryCount,
                    ),
                  )
                : const SizedBox(height: 24),
          ),
        ],
      ),
    );
  }
}
