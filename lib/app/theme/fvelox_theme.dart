import 'package:flutter/material.dart';

import 'package:fvelox/core/design_system/fvelox_color_tokens.dart';
import 'package:fvelox/core/design_system/fvelox_text_styles.dart';

abstract final class FveloxTheme {
  static ThemeData light() {
    final colors = FveloxColorTokens.light;
    final typography = FveloxTextStyles.light;
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: colors.cream,
      colorScheme: ColorScheme.fromSeed(
        seedColor: colors.green,
        surface: colors.cream,
      ),
      textTheme: TextTheme(
        bodyMedium: typography.body.copyWith(color: colors.ink),
        bodySmall: typography.caption.copyWith(color: colors.muted),
        titleLarge: typography.sectionTitle.copyWith(color: colors.ink),
      ),
    );
  }
}
