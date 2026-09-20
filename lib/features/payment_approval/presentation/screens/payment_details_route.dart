import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:fvelox/core/errors/app_failure_localization.dart';
import 'package:fvelox/features/payment_approval/domain/entities/payment.dart';
import 'package:fvelox/features/payment_approval/presentation/providers/payment_providers.dart';
import 'package:fvelox/features/payment_approval/presentation/screens/payment_details_screen.dart';
import 'package:fvelox/features/payment_approval/presentation/view_models/details/payment_details_arguments.dart';
import 'package:fvelox/features/payment_approval/presentation/widgets/payment_details_loading_skeleton.dart';
import 'package:fvelox/features/payment_approval/presentation/widgets/payment_load_error.dart';
import 'package:fvelox/l10n/fvelox_localizations_extensions.dart';

class PaymentDetailsRoute extends ConsumerWidget {
  const PaymentDetailsRoute({
    required this.paymentId,
    required this.fromHome,
    this.cachedPayment,
    super.key,
  });
  final String paymentId;
  final bool fromHome;
  final Payment? cachedPayment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final arguments = PaymentDetailsArguments(
      paymentId: paymentId,
      cachedPayment: cachedPayment,
    );
    final state = ref.watch(paymentDetailsControllerProvider(arguments));
    final controller = ref.read(
      paymentDetailsControllerProvider(arguments).notifier,
    );
    if (state.isLoading && state.payment == null) {
      return const PaymentDetailsLoadingSkeleton();
    }
    if (state.failure != null) {
      final failure = state.failure!;
      return Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Center(
                child: PaymentLoadError(
                  centered: true,
                  message: failure.toLocalizedMessage(l10n),
                  onRetry: () => controller.load(paymentId: paymentId),
                ),
              ),
            ),
          ],
        ),
      );
    }
    final payment = state.payment;
    if (payment == null) return const SizedBox.shrink();
    return PaymentDetailsScreen(
      payment: payment,
      returnLabel: fromHome ? l10n.homeTab : l10n.paymentsTab,
      onBack: context.pop,
    );
  }
}
