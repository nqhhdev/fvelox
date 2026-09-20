import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fvelox/app/providers/payment_approval_providers.dart';
import 'package:fvelox/app/theme/fvelox_material.dart';
import 'package:fvelox/features/payment_approval/data/repositories/demo_payment_repository.dart';

const _patrolTestMode = bool.fromEnvironment('FVELOX_PATROL_TEST');

void main() {
  runApp(
    ProviderScope(
      overrides: _patrolTestMode
          ? [
              paymentRepositoryProvider.overrideWithValue(
                DemoPaymentRepository(initialPayments: const []),
              ),
            ]
          : const [],
      child: const FveloxMaterial(),
    ),
  );
}
