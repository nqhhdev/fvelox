import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final class FveloxRoutePage {
  const FveloxRoutePage._();

  static Page<void> slideFade({required LocalKey key, required Widget child}) =>
      CustomTransitionPage<void>(
        key: key,
        child: child,
        transitionDuration: const Duration(milliseconds: 320),
        reverseTransitionDuration: const Duration(milliseconds: 240),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          );
          final position = Tween<Offset>(
            begin: const Offset(0.08, 0),
            end: Offset.zero,
          ).animate(curvedAnimation);
          final opacity = Tween<double>(begin: 0, end: 1).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
              reverseCurve: Curves.easeIn,
            ),
          );

          return FadeTransition(
            opacity: opacity,
            child: SlideTransition(position: position, child: child),
          );
        },
      );
}
