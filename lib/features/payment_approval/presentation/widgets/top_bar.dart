import 'package:flutter/material.dart';

import 'package:fvelox/core/design_system/fvelox_design_system.dart';
import 'package:fvelox/l10n/fvelox_localizations_extensions.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});
  @override
  Widget build(BuildContext context) {
    final design = FveloxDesignSystem.of(context);
    final l10n = context.l10n;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          l10n.brandName,
          style: design.typography.brand.copyWith(color: design.colors.ink),
        ),
        Container(
          width: 42,
          height: 42,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: design.colors.green,
            shape: BoxShape.circle,
          ),
          child: Text(
            l10n.profileInitials,
            style: design.typography.avatar.copyWith(
              color: design.colors.summaryCount,
            ),
          ),
        ),
      ],
    );
  }
}
