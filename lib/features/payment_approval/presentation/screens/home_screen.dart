import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:fvelox/core/design_system/fvelox_design_system.dart';
import 'package:fvelox/core/errors/app_failure.dart';
import 'package:fvelox/core/errors/app_failure_localization.dart';
import 'package:fvelox/app/providers/app_providers.dart';
import 'package:fvelox/features/payment_approval/domain/entities/payment.dart';
import 'package:fvelox/features/payment_approval/presentation/providers/payment_providers.dart';
import 'package:fvelox/features/payment_approval/presentation/widgets/empty_state.dart';
import 'package:fvelox/features/payment_approval/presentation/widgets/eyebrow.dart';
import 'package:fvelox/features/payment_approval/presentation/widgets/home_loading_skeleton.dart';
import 'package:fvelox/features/payment_approval/presentation/widgets/payment_row.dart';
import 'package:fvelox/features/payment_approval/presentation/widgets/payment_load_error.dart';
import 'package:fvelox/features/payment_approval/presentation/widgets/summary_card.dart';
import 'package:fvelox/features/payment_approval/presentation/widgets/top_bar.dart';
import 'package:fvelox/l10n/fvelox_localizations_extensions.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({
    required this.onPaymentTap,
    required this.onSeeAll,
    super.key,
  });
  final ValueChanged<Payment> onPaymentTap;
  final VoidCallback onSeeAll;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final design = FveloxDesignSystem.of(context);
    final l10n = context.l10n;
    final now = DateTime.now();
    final greeting = switch (now.hour) {
      < 12 => l10n.greetingMorning,
      < 18 => l10n.greetingAfternoon,
      _ => l10n.greetingEvening,
    };
    final dateLabel = DateFormat('EEEE, MMMM d', l10n.localeName).format(now);
    final payments = ref.watch(
      homeControllerProvider.select((state) => state.recentPayments),
    );
    final summary = ref.watch(
      homeControllerProvider.select((state) => state.summary),
    );
    final isLoading = ref.watch(
      homeControllerProvider.select((state) => state.isLoading),
    );
    final failure = ref.watch(
      homeControllerProvider.select((state) => state.failure),
    );
    final isOffline =
        ref.watch(connectivityStatusProvider).valueOrNull == false;
    Future<bool> deletePayment(Payment payment) async {
      try {
        await ref
            .read(homeControllerProvider.notifier)
            .deletePayment(payment.id);
        ref
            .read(fveloxToastControllerProvider)
            .showSuccess(l10n.paymentDeletedSuccess);
        return true;
      } on AppFailure catch (error) {
        if (error.code == 'delete_in_progress') return false;
        ref
            .read(fveloxToastControllerProvider)
            .showError(error.toLocalizedMessage(l10n));
        return false;
      }
    }

    if (isLoading) {
      return HomeLoadingSkeleton(hasExistingPayments: payments.isNotEmpty);
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TopBar(),
          const SizedBox(height: 16),
          Eyebrow(dateLabel),
          const SizedBox(height: 8),
          Text(
            l10n.greeting(greeting, l10n.profileName),
            style: design.typography.rowTitle.copyWith(
              color: design.colors.ink,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            l10n.paymentSubtitle,
            style: design.typography.bodyMuted.copyWith(
              color: design.colors.muted,
            ),
          ),
          const SizedBox(height: 20),
          if (failure != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: PaymentLoadError(
                message: failure.toLocalizedMessage(l10n),
                onRetry: () => ref.read(homeControllerProvider.notifier).load(),
              ),
            ),
          SummaryCard(
            total: summary?.totalAmount ?? 0,
            count: summary?.paymentCount ?? 0,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.recentActivity,
                style: design.typography.sectionTitle.copyWith(
                  color: design.colors.ink,
                ),
              ),
              TextButton(
                onPressed: onSeeAll,
                child: Text(
                  l10n.seeAll,
                  style: design.typography.button.copyWith(
                    color: design.colors.green,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
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
                                  .read(homeControllerProvider.notifier)
                                  .load()
                            : null,
                      ),
                    ],
                  )
                : ListView.separated(
                    padding: const EdgeInsets.only(bottom: 110),
                    itemCount: payments.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 1),
                    itemBuilder: (context, index) {
                      final payment = payments[index];
                      return PaymentRow(
                        payment: payment,
                        onTap: () => onPaymentTap(payment),
                        onDelete: deletePayment,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
