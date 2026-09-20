import 'package:flutter/material.dart';

import 'package:fvelox/core/design_system/fvelox_design_system.dart';
import 'package:fvelox/features/payment_approval/presentation/widgets/skeleton_box.dart';

class PaymentRowSkeleton extends StatelessWidget {
  const PaymentRowSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = FveloxDesignSystem.of(context).colors;
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: colors.paper.withValues(alpha: .7),
        border: Border.all(color: colors.border),
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonBox(width: 154, height: 17),
                SizedBox(height: 10),
                SkeletonBox(width: 104, height: 14),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SkeletonBox(width: 64, height: 22, borderRadius: 12),
              SizedBox(height: 10),
              SkeletonBox(width: 18, height: 18, borderRadius: 9),
            ],
          ),
        ],
      ),
    );
  }
}
