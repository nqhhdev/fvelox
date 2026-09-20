import 'package:flutter/material.dart';

import 'package:fvelox/features/payment_approval/presentation/widgets/page_frame.dart';
import 'package:fvelox/features/payment_approval/presentation/widgets/top_bar.dart';
import 'package:fvelox/l10n/fvelox_localizations_extensions.dart';

class PaymentFeatureDisabledScreen extends StatelessWidget {
  const PaymentFeatureDisabledScreen({super.key});
  @override
  Widget build(BuildContext context) => PageFrame(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TopBar(),
        const SizedBox(height: 28),
        Text(context.l10n.paymentApprovalUnavailable),
      ],
    ),
  );
}
