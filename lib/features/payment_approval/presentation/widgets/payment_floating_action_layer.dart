import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fvelox/features/payment_approval/presentation/widgets/payment_floating_action_layer_state.dart';

class PaymentFloatingActionLayer extends ConsumerStatefulWidget {
  const PaymentFloatingActionLayer({required this.onPressed, super.key});

  static const double buttonSize = 56;
  static const double edgeMargin = 16;
  static const double navigationBarClearance = 96;

  final VoidCallback onPressed;

  @override
  ConsumerState<PaymentFloatingActionLayer> createState() =>
      PaymentFloatingActionLayerState();
}
