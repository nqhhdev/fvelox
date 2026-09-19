import 'package:flutter/material.dart';

import 'package:fvelox/core/design_system/fvelox_design_system.dart';
import 'package:fvelox/core/design_system/fvelox_toast.dart';
import 'package:fvelox/core/design_system/fvelox_toast_controller.dart';
import 'package:fvelox/core/design_system/fvelox_toast_message.dart';

class FveloxToastHost extends StatelessWidget {
  const FveloxToastHost({
    required this.controller,
    required this.child,
    super.key,
  });

  final FveloxToastController controller;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = FveloxDesignSystem.of(context).colors;
    final top = MediaQuery.paddingOf(context).top + 12;
    return Stack(
      fit: StackFit.expand,
      children: [
        child,
        Positioned(
          top: top,
          left: 16,
          right: 16,
          child: IgnorePointer(
            child: AnimatedBuilder(
              animation: controller,
              builder: (context, _) {
                final message = controller.message;
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 240),
                  reverseDuration: const Duration(milliseconds: 180),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, -0.18),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  ),
                  child: message == null
                      ? const SizedBox.shrink(key: ValueKey('toast-empty'))
                      : Align(
                          key: ValueKey(message.id),
                          alignment: Alignment.topCenter,
                          child: FveloxToast(
                            icon: message.type == FveloxToastType.success
                                ? Icons.check_circle_rounded
                                : Icons.error_rounded,
                            message: message.message,
                            backgroundColor:
                                message.type == FveloxToastType.success
                                ? colors.greenDark
                                : colors.red,
                            foregroundColor: colors.white,
                          ),
                        ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
