import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import 'package:fvelox/core/design_system/fvelox_design_system.dart';
import 'package:fvelox/features/payment_approval/domain/entities/payment.dart';
import 'package:fvelox/features/payment_approval/presentation/widgets/eyebrow.dart';
import 'package:fvelox/features/payment_approval/presentation/widgets/pin_wave_loading.dart';
import 'package:fvelox/l10n/fvelox_localizations_extensions.dart';

/// OTP step for the approval bottom sheet.
/// Called from `approval_sheet_state.dart` when a decision is selected.
class ApprovalOtpContent extends StatelessWidget {
  const ApprovalOtpContent({
    required this.decision,
    required this.otpFieldVersion,
    required this.error,
    required this.isLoading,
    required this.onBack,
    required this.onCancel,
    required this.onOtpChanged,
    required this.onSubmit,
    super.key,
  });
  final PaymentStatus decision;
  final int otpFieldVersion;
  final String? error;
  final bool isLoading;
  final VoidCallback? onBack;
  final VoidCallback? onCancel;
  final ValueChanged<String> onOtpChanged;
  final VoidCallback onSubmit;
  @override
  Widget build(BuildContext context) {
    final design = FveloxDesignSystem.of(context);
    final l10n = context.l10n;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            TextButton.icon(
              onPressed: onBack,
              icon: const Icon(Icons.chevron_left),
              label: Text(l10n.changeDecision),
              style: TextButton.styleFrom(
                foregroundColor: design.colors.muted,
                padding: EdgeInsets.zero,
              ),
            ),
            const Spacer(),
            TextButton(onPressed: onCancel, child: Text(l10n.cancelRequest)),
          ],
        ),
        const SizedBox(height: 12),
        Eyebrow(l10n.confirmAction),
        const SizedBox(height: 8),
        Text(
          decision == PaymentStatus.approved
              ? l10n.approvePayment
              : l10n.rejectPayment,
          style: design.typography.sheetTitle,
        ),
        const SizedBox(height: 8),
        Text(
          l10n.verificationCodePrompt,
          style: design.typography.bodyMuted.copyWith(
            color: design.colors.muted,
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Pinput(
            key: ValueKey('approval-otp-$otpFieldVersion'),
            length: 4,
            onChanged: onOtpChanged,
            onCompleted: (_) => onSubmit(),
            autofocus: true,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            obscureText: true,
            isCursorAnimationEnabled: false,
            closeKeyboardWhenCompleted: false,
            enabled: !isLoading,
            forceErrorState: error != null,
            errorText: error,
            errorTextStyle: design.typography.caption.copyWith(
              color: design.colors.red,
            ),
            defaultPinTheme: PinTheme(
              width: 58,
              height: 62,
              textStyle: design.typography.sheetTitle.copyWith(
                color: design.colors.ink,
                fontSize: 26,
              ),
              decoration: BoxDecoration(
                color: design.colors.paper,
                border: Border.all(color: design.colors.borderStrong),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            focusedPinTheme: PinTheme(
              width: 58,
              height: 62,
              textStyle: design.typography.sheetTitle.copyWith(
                color: design.colors.greenDark,
                fontSize: 26,
              ),
              decoration: BoxDecoration(
                color: design.colors.softGreen,
                border: Border.all(color: design.colors.green, width: 2),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            submittedPinTheme: PinTheme(
              width: 58,
              height: 62,
              textStyle: design.typography.sheetTitle.copyWith(
                color: design.colors.greenDark,
                fontSize: 26,
              ),
              decoration: BoxDecoration(
                color: design.colors.softGreen,
                border: Border.all(color: design.colors.green),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            followingPinTheme: PinTheme(
              width: 58,
              height: 62,
              textStyle: design.typography.sheetTitle.copyWith(
                color: design.colors.ink,
                fontSize: 26,
              ),
              decoration: BoxDecoration(
                color: design.colors.paper,
                border: Border.all(color: design.colors.borderStrong),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            errorPinTheme: PinTheme(
              width: 58,
              height: 62,
              textStyle: design.typography.sheetTitle.copyWith(
                color: design.colors.red,
                fontSize: 26,
              ),
              decoration: BoxDecoration(
                color: design.colors.softRed,
                border: Border.all(color: design.colors.red, width: 2),
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: isLoading
              ? PinWaveLoading(
                  key: const ValueKey('approval-otp-loading'),
                  label: l10n.loading,
                )
              : const SizedBox(
                  key: ValueKey('approval-otp-auto-submit'),
                  height: 24,
                ),
        ),
      ],
    );
  }
}
