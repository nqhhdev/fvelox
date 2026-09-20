import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fvelox/app/providers/app_providers.dart';
import 'package:fvelox/app/router/app_router.dart';
import 'package:fvelox/core/errors/app_failure.dart';
import 'package:fvelox/core/errors/app_failure_localization.dart';
import 'package:fvelox/features/payment_approval/domain/entities/payment.dart';
import 'package:fvelox/features/payment_approval/presentation/providers/payment_providers.dart';
import 'package:fvelox/features/payment_approval/presentation/view_models/shell/payment_shell_ui_state.dart';
import 'package:fvelox/features/payment_approval/presentation/widgets/approval_sheet.dart';
import 'package:fvelox/features/payment_approval/presentation/widgets/payment_floating_action_layer.dart';
import 'package:fvelox/features/payment_approval/presentation/widgets/payment_request_loading_overlay.dart';
import 'package:fvelox/l10n/fvelox_localizations_extensions.dart';

class PaymentGlobalOverlayContent extends ConsumerWidget {
  const PaymentGlobalOverlayContent({required this.child, super.key});

  final Widget child;

  Future<void> _openRequest(BuildContext context, WidgetRef ref) async {
    final uiController = ref.read(paymentApprovalUiControllerProvider.notifier);
    if (ref.read(paymentApprovalFlowControllerProvider).isCreatingRequest) {
      return;
    }
    final navigatorState = ref.read(appNavigatorKeyProvider).currentState;
    if (navigatorState == null) return;
    final l10n = context.l10n;

    try {
      final request = await ref
          .read(paymentApprovalFlowControllerProvider.notifier)
          .createDemoRequest();
      if (!navigatorState.mounted) return;

      uiController.beginFlow();
      try {
        final status = await showModalBottomSheet<PaymentStatus>(
          context: navigatorState.context,
          useRootNavigator: true,
          isScrollControlled: true,
          isDismissible: false,
          enableDrag: false,
          constraints: BoxConstraints.tightFor(
            width: MediaQuery.sizeOf(navigatorState.context).width,
          ),
          backgroundColor: Colors.transparent,
          builder: (_) => ApprovalSheet(request: request),
        );
        if (!navigatorState.mounted || status == null) return;
        final message = status == PaymentStatus.approved
            ? l10n.paymentApprovedSuccess
            : l10n.paymentRejectedSuccess;
        await _completeDecision(ref, status, message);
      } finally {
        uiController.endFlow();
      }
    } on AppFailure catch (failure) {
      ref
          .read(fveloxToastControllerProvider)
          .showError(failure.toLocalizedMessage(l10n));
    } catch (_) {
      ref.read(fveloxToastControllerProvider).showError(l10n.genericError);
    }
  }

  Future<void> _completeDecision(
    WidgetRef ref,
    PaymentStatus status,
    String message,
  ) async {
    if (status == PaymentStatus.approved) {
      ref
          .read(paymentShellUiControllerProvider.notifier)
          .selectTab(PaymentTab.payments);
      ref.read(appRouterProvider).go('/');
    }
    ref
        .read(paymentApprovalFlowControllerProvider.notifier)
        .refreshScreensAfterDecision();

    // Let the route and the affected screen reconcile first. Showing the toast
    // on the next frame prevents a successful decision from being emitted while
    // the modal route is still closing, which makes the one-shot feedback
    // reliable for both the UI and native acceptance tests.
    await WidgetsBinding.instance.endOfFrame;
    ref.read(fveloxToastControllerProvider).showSuccess(message);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFeatureEnabled = ref.watch(
      paymentFeatureControllerProvider.select((state) => state.isEnabled),
    );
    final isFabRequestLoading = ref.watch(
      paymentApprovalFlowControllerProvider.select(
        (state) => state.isCreatingRequest,
      ),
    );
    return Stack(
      fit: StackFit.expand,
      children: [
        child,
        if (isFeatureEnabled)
          PaymentFloatingActionLayer(
            onPressed: () => _openRequest(context, ref),
          ),
        if (isFabRequestLoading) const PaymentRequestLoadingOverlay(),
      ],
    );
  }
}
