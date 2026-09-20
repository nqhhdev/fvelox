import 'package:flutter/material.dart';

import 'package:fvelox/features/payment_approval/presentation/widgets/payment_row_skeleton.dart';
import 'package:fvelox/features/payment_approval/presentation/widgets/skeleton_box.dart';
import 'package:fvelox/features/payment_approval/presentation/widgets/top_bar.dart';
import 'package:fvelox/l10n/fvelox_localizations_extensions.dart';

class HomeLoadingSkeleton extends StatelessWidget {
  const HomeLoadingSkeleton({required this.hasExistingPayments, super.key});

  final bool hasExistingPayments;

  @override
  Widget build(BuildContext context) => Semantics(
    label: context.l10n.loading,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TopBar(),
          const SizedBox(height: 16),
          const SkeletonBox(width: 210, height: 16),
          const SizedBox(height: 12),
          const SkeletonBox(width: 260, height: 48),
          const SizedBox(height: 12),
          const SkeletonBox(width: 220, height: 18),
          const SizedBox(height: 20),
          const SkeletonBox(height: 186, borderRadius: 26),
          const SizedBox(height: 24),
          const SkeletonBox(width: 180, height: 28),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 110),
              itemCount: hasExistingPayments ? 3 : 4,
              itemBuilder: (context, index) => const PaymentRowSkeleton(),
            ),
          ),
        ],
      ),
    ),
  );
}
