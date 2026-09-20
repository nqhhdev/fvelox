import 'package:flutter/material.dart';

import 'package:fvelox/features/payment_approval/presentation/shell/payment_global_overlay_content.dart';

class PaymentAppOverlay extends StatelessWidget {
  const PaymentAppOverlay({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => Overlay(
    initialEntries: [
      OverlayEntry(
        builder: (context) => PaymentGlobalOverlayContent(child: child),
      ),
    ],
  );
}
