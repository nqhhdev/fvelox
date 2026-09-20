import 'package:flutter/material.dart';

import 'package:fvelox/features/payment_approval/presentation/widgets/page_frame.dart';
import 'package:fvelox/features/payment_approval/presentation/widgets/skeleton_box.dart';
import 'package:fvelox/l10n/fvelox_localizations_extensions.dart';

class PaymentDetailsLoadingSkeleton extends StatelessWidget {
  const PaymentDetailsLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) => Semantics(
    label: context.l10n.loading,
    child: PageFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SizedBox(height: 8),
          SkeletonBox(width: 140, height: 20),
          SizedBox(height: 20),
          SkeletonBox(width: 180, height: 16),
          SizedBox(height: 8),
          SkeletonBox(width: 245, height: 42),
          SizedBox(height: 20),
          SkeletonBox(height: 290, borderRadius: 25),
        ],
      ),
    ),
  );
}
