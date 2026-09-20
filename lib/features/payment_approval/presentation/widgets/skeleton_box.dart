import 'package:flutter/material.dart';

import 'package:fvelox/core/design_system/fvelox_design_system.dart';

class SkeletonBox extends StatelessWidget {
  const SkeletonBox({
    required this.height,
    this.width = double.infinity,
    this.borderRadius = 12,
    super.key,
  });

  final double height;
  final double width;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final colors = FveloxDesignSystem.of(context).colors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.border.withValues(alpha: .72),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: SizedBox(width: width, height: height),
    );
  }
}
