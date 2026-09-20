import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:fvelox/app/providers/app_providers.dart';
import 'package:fvelox/core/design_system/fvelox_color_tokens.dart';
import 'package:fvelox/core/design_system/fvelox_design_system.dart';
import 'package:fvelox/features/payment_approval/domain/entities/payment.dart';
import 'package:fvelox/features/payment_approval/presentation/providers/payment_providers.dart';
import 'package:fvelox/features/payment_approval/presentation/screens/home_screen.dart';
import 'package:fvelox/features/payment_approval/presentation/screens/payment_feature_disabled_screen.dart';
import 'package:fvelox/features/payment_approval/presentation/screens/payments_screen.dart';
import 'package:fvelox/features/payment_approval/presentation/view_models/shell/payment_shell_ui_state.dart';
import 'package:fvelox/features/payment_approval/presentation/widgets/offline_banner.dart';
import 'package:fvelox/features/payment_approval/presentation/widgets/payment_navigation_bar.dart';

class PaymentShell extends ConsumerWidget {
  const PaymentShell({required this.child, super.key});
  final Widget child;

  void showPayments(WidgetRef ref) {
    ref
        .read(paymentShellUiControllerProvider.notifier)
        .selectTab(PaymentTab.payments);
  }

  void openPaymentDetails(
    BuildContext context,
    Payment payment, {
    required bool fromHome,
  }) {
    context.push(
      '/payments/${payment.id}?from=${fromHome ? 'home' : 'payments'}',
      extra: payment,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = FveloxDesignSystem.of(context).colors;
    final systemUiStyle = _systemUiStyle(context, colors);
    final selectedTab = ref.watch(
      paymentShellUiControllerProvider.select((state) => state.selectedTab),
    );
    final isFeatureDisabled = ref.watch(
      paymentFeatureControllerProvider.select(
        (state) => !state.isLoading && !state.isEnabled,
      ),
    );
    final isOffline =
        ref.watch(connectivityStatusProvider).valueOrNull == false;
    final isPaymentDetails = GoRouterState.of(
      context,
    ).uri.path.startsWith('/payments/');
    final child = isFeatureDisabled
        ? const PaymentFeatureDisabledScreen()
        : isPaymentDetails
        ? this.child
        : IndexedStack(
            index: selectedTab.index,
            children: [
              HomeScreen(
                onSeeAll: () => showPayments(ref),
                onPaymentTap: (payment) =>
                    openPaymentDetails(context, payment, fromHome: true),
              ),
              PaymentsScreen(
                onPaymentTap: (payment) =>
                    openPaymentDetails(context, payment, fromHome: false),
              ),
            ],
          );
    final body = SafeArea(
      top: true,
      bottom: false,
      left: true,
      right: true,
      child: Column(
        children: [
          if (isOffline)
            OfflineBanner(
              onRetry: () {
                ref.invalidate(connectivityStatusProvider);
                ref
                    .read(paymentScreenRefreshControllerProvider.notifier)
                    .requestRefresh();
              },
            ),
          Expanded(child: child),
        ],
      ),
    );
    final scaffold = Scaffold(
      body: body,
      bottomNavigationBar: isPaymentDetails
          ? null
          : PaymentNavigationBar(
              selectedIndex: selectedTab.index,
              onDestinationSelected: (index) => ref
                  .read(paymentShellUiControllerProvider.notifier)
                  .selectTab(PaymentTab.values[index]),
            ),
    );
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemUiStyle,
      child: scaffold,
    );
  }

  SystemUiOverlayStyle _systemUiStyle(
    BuildContext context,
    FveloxColorTokens colors,
  ) {
    final platform = Theme.of(context).platform;
    if (platform == TargetPlatform.iOS || platform == TargetPlatform.macOS) {
      return const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.dark,
      );
    }
    return SystemUiOverlayStyle(
      statusBarColor: colors.cream,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: colors.cream,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarDividerColor: colors.cream,
      systemStatusBarContrastEnforced: false,
      systemNavigationBarContrastEnforced: false,
    );
  }
}
