import 'package:flutter/material.dart';

import 'package:fvelox/core/design_system/fvelox_color_tokens.dart';
import 'package:fvelox/core/design_system/fvelox_text_styles.dart';

class FveloxDesignSystem extends InheritedWidget {
  const FveloxDesignSystem({
    required super.child,
    this.colors = FveloxColorTokens.light,
    this.typography = FveloxTextStyles.light,
    super.key,
  });

  final FveloxColorTokens colors;
  final FveloxTextStyles typography;

  static FveloxDesignSystem of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<FveloxDesignSystem>()!;

  @override
  bool updateShouldNotify(FveloxDesignSystem oldWidget) =>
      colors != oldWidget.colors || typography != oldWidget.typography;
}
