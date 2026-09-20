import 'package:flutter/material.dart';

import 'package:fvelox/features/payment_approval/presentation/widgets/eyebrow.dart';
import 'package:fvelox/features/payment_approval/presentation/widgets/payment_row_skeleton.dart';
import 'package:fvelox/features/payment_approval/presentation/widgets/skeleton_box.dart';
import 'package:fvelox/features/payment_approval/presentation/widgets/top_bar.dart';
import 'package:fvelox/l10n/fvelox_localizations_extensions.dart';

class PaymentsLoadingSkeleton extends StatelessWidget {
  const PaymentsLoadingSkeleton({required this.hasExistingPayments, super.key});

  final bool hasExistingPayments;

  @override
  Widget build(BuildContext context) => Semantics(
    label: context.l10n.loading,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TopBar(),
          const SizedBox(height: 24),
          Eyebrow(context.l10n.brandName),
          const SizedBox(height: 8),
          const SkeletonBox(width: 150, height: 40),
          const SizedBox(height: 30),
          const SkeletonBox(width: 210, height: 28),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 110),
              itemCount: hasExistingPayments ? 4 : 6,
              itemBuilder: (context, index) => const PaymentRowSkeleton(),
            ),
          ),
        ],
      ),
    ),
  );
}
