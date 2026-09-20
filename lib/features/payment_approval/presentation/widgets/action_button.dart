import 'package:flutter/material.dart';

import 'package:fvelox/core/design_system/fvelox_design_system.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({
    required this.label,
    required this.color,
    required this.foreground,
    required this.onPressed,
    this.isLoading = false,
    super.key,
  });
  final String label;
  final Color color;
  final Color foreground;
  final VoidCallback onPressed;
  final bool isLoading;
  @override
  Widget build(BuildContext context) {
    final typography = FveloxDesignSystem.of(context).typography;
    return FilledButton(
      onPressed: isLoading ? null : onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: color,
        foregroundColor: foreground,
        padding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: isLoading
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: foreground,
              ),
            )
          : Text(label, style: typography.button),
    );
  }
}
