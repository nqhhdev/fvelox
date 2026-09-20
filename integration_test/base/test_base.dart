import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:patrol/patrol.dart';

import 'package:fvelox/app/providers/payment_approval_providers.dart';
import 'package:fvelox/app/theme/fvelox_material.dart';
import 'package:fvelox/features/payment_approval/data/repositories/demo_payment_repository.dart';

/// Shared entry point for Patrol tests.
abstract final class TestBase {
  static void run({
    required String description,
    required Future<void> Function(PatrolIntegrationTester $) body,
    Object? tags,
  }) {
    patrolTest(
      description,
      config: const PatrolTesterConfig(
        printLogs: true,
        visibleTimeout: Duration(seconds: 10),
        existsTimeout: Duration(seconds: 10),
        settleTimeout: Duration(seconds: 10),
      ),
      timeout: const Timeout(Duration(minutes: 2)),
      tags: tags,
      ($) async {
        await $.pumpWidgetAndSettle(
          ProviderScope(
            overrides: [
              paymentRepositoryProvider.overrideWithValue(
                DemoPaymentRepository(initialPayments: const []),
              ),
            ],
            child: const FveloxMaterial(),
          ),
        );
        await body($);
      },
    );
  }
}
