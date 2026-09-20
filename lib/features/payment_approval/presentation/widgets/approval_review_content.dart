import 'package:flutter/material.dart';

import 'package:fvelox/core/design_system/fvelox_design_system.dart';
import 'package:fvelox/features/payment_approval/domain/entities/payment.dart';
import 'package:fvelox/features/payment_approval/presentation/widgets/action_button.dart';
import 'package:fvelox/features/payment_approval/presentation/widgets/eyebrow.dart';
import 'package:fvelox/l10n/fvelox_localizations_extensions.dart';

class ApprovalReviewContent extends StatelessWidget {
  const ApprovalReviewContent({
    required this.request,
    required this.onDecision,
    required this.onCancel,
    super.key,
  });
  final Payment request;
  final ValueChanged<PaymentStatus> onDecision;
  final VoidCallback onCancel;
  @override
  Widget build(BuildContext context) {
    final design = FveloxDesignSystem.of(context);
    final l10n = context.l10n;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: onCancel,
            child: Text(l10n.cancelRequest),
          ),
        ),
        Eyebrow(l10n.incomingRequest),
        const SizedBox(height: 8),
        Text(l10n.reviewBeforeDecide, style: design.typography.sheetTitle),
        const SizedBox(height: 19),
        Text(
          l10n.incomingRequestDetails(request.reference),
          style: design.typography.detailValue.copyWith(height: 1.8),
        ),
        const SizedBox(height: 22),
        Row(
          children: [
            Expanded(
              child: ActionButton(
                label: l10n.reject,
                color: design.colors.softRed,
                foreground: design.colors.red,
                onPressed: () => onDecision(PaymentStatus.rejected),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ActionButton(
                label: l10n.approve,
                color: design.colors.green,
                foreground: design.colors.white,
                onPressed: () => onDecision(PaymentStatus.approved),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
