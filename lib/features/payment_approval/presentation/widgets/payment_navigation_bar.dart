import 'package:flutter/material.dart';

import 'package:fvelox/core/design_system/fvelox_design_system.dart';
import 'package:fvelox/l10n/fvelox_localizations_extensions.dart';

class PaymentNavigationBar extends StatelessWidget {
  const PaymentNavigationBar({
    required this.selectedIndex,
    required this.onDestinationSelected,
    super.key,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final design = FveloxDesignSystem.of(context);
    final l10n = context.l10n;
    return NavigationBar(
      maintainBottomViewPadding: true,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      backgroundColor: design.colors.cream,
      indicatorColor: design.colors.softGreen,
      elevation: 0,
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      destinations: [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: l10n.homeTab,
        ),
        NavigationDestination(
          icon: Icon(Icons.credit_card_outlined),
          selectedIcon: Icon(Icons.credit_card),
          label: l10n.paymentsTab,
        ),
      ],
    );
  }
}
