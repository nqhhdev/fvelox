import 'package:flutter/material.dart';

import 'package:fvelox/core/design_system/fvelox_design_system.dart';

class Eyebrow extends StatelessWidget {
  const Eyebrow(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) {
    final design = FveloxDesignSystem.of(context);
    return Text(
      text.toUpperCase(),
      style: design.typography.eyebrow.copyWith(color: design.colors.muted),
    );
  }
}
