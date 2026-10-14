import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fvelox/app/providers/app_providers.dart';
import 'package:fvelox/core/design_system/fvelox_design_system.dart';
import 'package:fvelox/core/errors/app_failure_localization.dart';
import 'package:fvelox/features/payment_approval/domain/entities/payment.dart';
import 'package:fvelox/features/payment_approval/presentation/providers/payment_providers.dart';
import 'package:fvelox/features/payment_approval/presentation/widgets/empty_state.dart';
import 'package:fvelox/features/payment_approval/presentation/widgets/payment_load_error.dart';
import 'package:fvelox/features/payment_approval/presentation/widgets/payment_row.dart';
import 'package:fvelox/features/payment_approval/presentation/widgets/payments_loading_skeleton.dart';
import 'package:fvelox/features/payment_approval/presentation/widgets/top_bar.dart';
import 'package:fvelox/l10n/fvelox_localizations_extensions.dart';

class PaymentsScreen extends ConsumerWidget {
  const PaymentsScreen({required this.onPaymentTap, super.key});
  final ValueChanged<Payment> onPaymentTap;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final design = FveloxDesignSystem.of(context);
    final l10n = context.l10n;
    final payments = ref.watch(
      paymentsControllerProvider.select((state) => state.payments),
    );
    final isLoading = ref.watch(
      paymentsControllerProvider.select((state) => state.isLoading),
    );
    final failure = ref.watch(
      paymentsControllerProvider.select((state) => state.failure),
    );
    final isOffline =
        ref.watch(connectivityStatusProvider).valueOrNull == false;
    final controller = ref.read(paymentsControllerProvider.notifier);

    if (isLoading) {
      return PaymentsLoadingSkeleton(hasExistingPayments: payments.isNotEmpty);
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TopBar(),
          const SizedBox(height: 16),
          Text(
            l10n.paymentsTab,
            style: design.typography.pageTitle.copyWith(
              color: design.colors.ink,
            ),
          ),
          const SizedBox(height: 26),
          Text(
            l10n.allDecidedPayments,
            style: design.typography.sectionTitle.copyWith(
              color: design.colors.ink,
            ),
          ),
          const SizedBox(height: 12),
          if (failure != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: PaymentLoadError(
                message: failure.toLocalizedMessage(l10n),
                onRetry: () =>
                    ref.read(paymentsControllerProvider.notifier).load(),
              ),
            ),
          Expanded(
            child: failure != null && payments.isEmpty
                ? const SizedBox.shrink()
                : payments.isEmpty
                ? ListView(
                    padding: const EdgeInsets.only(bottom: 110),
                    children: [
                      EmptyState(
                        onRetry: isOffline
                            ? () => ref
                                  .read(paymentsControllerProvider.notifier)
                                  .load()
                            : null,
                      ),
                    ],
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 110),
                    itemCount: payments.length,
                    itemBuilder: (context, index) {
                      final payment = payments[index];
                      return PaymentRow(
                        payment: payment,
                        onTap: () => onPaymentTap(payment),
                        onDelete: (payment) =>
                            controller.deletePaymentWithFeedback(payment, l10n),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
