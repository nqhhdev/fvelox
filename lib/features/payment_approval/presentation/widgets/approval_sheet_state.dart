import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fvelox/core/design_system/fvelox_design_system.dart';
import 'package:fvelox/core/errors/app_failure.dart';
import 'package:fvelox/core/errors/app_failure_localization.dart';
import 'package:fvelox/features/payment_approval/presentation/providers/payment_providers.dart';
import 'package:fvelox/features/payment_approval/presentation/widgets/approval_otp_content.dart';
import 'package:fvelox/features/payment_approval/presentation/widgets/approval_review_content.dart';
import 'package:fvelox/features/payment_approval/presentation/widgets/approval_sheet.dart';
import 'package:fvelox/l10n/fvelox_localizations_extensions.dart';

final class ApprovalSheetState extends ConsumerState<ApprovalSheet> {
  Future<void> _submit() async {
    final l10n = context.l10n;
    final uiState = ref.read(paymentApprovalUiControllerProvider);
    final decision = uiState.decision;
    if (decision == null) return;
    if (uiState.isSubmitting) return;
    final uiController = ref.read(paymentApprovalUiControllerProvider.notifier);
    uiController.beginSubmit();
    try {
      await ref
          .read(paymentApprovalFlowControllerProvider.notifier)
          .decide(widget.request, decision, uiState.otp);
      if (!mounted) return;
      Navigator.of(context).pop(decision);
    } on AppFailure catch (failure) {
      uiController.endSubmit();
      final message = failure.toLocalizedMessage(l10n);
      uiController.setError(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = FveloxDesignSystem.of(context).colors;
    final decision = ref.watch(
      paymentApprovalUiControllerProvider.select((state) => state.decision),
    );
    final error = ref.watch(
      paymentApprovalUiControllerProvider.select((state) => state.error),
    );
    final otpFieldVersion = ref.watch(
      paymentApprovalUiControllerProvider.select(
        (state) => state.otpFieldVersion,
      ),
    );
    final isSubmitting = ref.watch(
      paymentApprovalUiControllerProvider.select((state) => state.isSubmitting),
    );
    final child = decision == null
        ? ApprovalReviewContent(
            request: widget.request,
            onDecision: ref
                .read(paymentApprovalUiControllerProvider.notifier)
                .selectDecision,
            onCancel: () => Navigator.of(context).pop(),
          )
        : ApprovalOtpContent(
            decision: decision,
            otpFieldVersion: otpFieldVersion,
            error: error,
            isLoading: isSubmitting,
            onBack: isSubmitting
                ? null
                : ref
                      .read(paymentApprovalUiControllerProvider.notifier)
                      .backToReview,
            onCancel: isSubmitting ? null : () => Navigator.of(context).pop(),
            onOtpChanged: ref
                .read(paymentApprovalUiControllerProvider.notifier)
                .changeOtp,
            onSubmit: _submit,
          );
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 30),
        decoration: BoxDecoration(
          color: colors.paper,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: child,
      ),
    );
  }
}
