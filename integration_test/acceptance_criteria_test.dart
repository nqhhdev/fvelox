import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:integration_test/integration_test.dart';
import 'package:go_router/go_router.dart';

import 'package:fvelox/app/theme/fvelox_material.dart';
import 'package:fvelox/features/payment_approval/data/repositories/demo_payment_repository.dart';
import 'package:fvelox/features/payment_approval/presentation/providers/payment_providers.dart';
import 'package:fvelox/features/payment_approval/presentation/widgets/payment_row.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('renders an empty Home state at startup', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          paymentRepositoryProvider.overrideWithValue(
            DemoPaymentRepository(initialPayments: const []),
          ),
        ],
        child: const FveloxMaterial(),
      ),
    );
    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.text('No decided payments yet.'), findsOneWidget);
    expect(find.text('AED 0.00'), findsOneWidget);
  });

  testWidgets('runs the payment approval acceptance flow', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          paymentRepositoryProvider.overrideWithValue(DemoPaymentRepository()),
        ],
        child: const FveloxMaterial(),
      ),
    );
    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.text('fvelox'), findsOneWidget);
    final initialHomeTotal = _summaryAmount(tester);
    expect(initialHomeTotal, startsWith('AED '));
    expect(find.byType(PaymentRow), findsNWidgets(3));

    await tester.tap(find.byType(PaymentRow).first);
    await tester.pumpAndSettle();
    expect(find.text('PAYMENT DETAILS'), findsOneWidget);
    expect(find.text('MAMO-240919-01'), findsOneWidget);
    await tester.tap(find.text('Back to Home'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Payments'));
    await tester.pumpAndSettle();
    expect(find.text('All decided payments'), findsOneWidget);
    expect(find.text('Approved'), findsWidgets);
    expect(find.text('Rejected'), findsOneWidget);

    await tester.tap(find.byType(PaymentRow).first);
    await tester.pumpAndSettle();
    expect(find.text('Back to Payments'), findsOneWidget);
    await tester.tap(find.text('Back to Payments'));
    await tester.pumpAndSettle();

    final fab = find.byTooltip('Create incoming payment request');
    final initialFabCenter = tester.getCenter(fab);
    await tester.drag(fab, const Offset(-220, -100));
    await tester.pumpAndSettle();
    expect(tester.getCenter(fab).dx, lessThan(initialFabCenter.dx - 100));

    await tester.tap(find.byTooltip('Create incoming payment request'));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Create incoming payment request'), findsOneWidget);
    expect(find.text('Review before you decide.'), findsOneWidget);
    expect(find.textContaining('From: ••••••••••'), findsOneWidget);
    expect(find.textContaining('Amount: AED ••••••'), findsOneWidget);
    expect(find.textContaining('Reference: KITE-240919-'), findsOneWidget);

    await tester.tap(find.text('Approve'));
    await tester.pumpAndSettle();
    expect(find.text('Approve payment'), findsOneWidget);
    await tester.enterText(find.byType(EditableText), '8888');
    await tester.pumpAndSettle();
    expect(find.text('Payment approved successfully.'), findsOneWidget);
    expect(find.text('Kite Supplies'), findsOneWidget);

    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    final totalAfterApprove = _summaryAmount(tester);
    expect(totalAfterApprove, isNot(initialHomeTotal));
    await tester.tap(find.text('Payments'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Create incoming payment request'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reject'));
    await tester.pumpAndSettle();
    expect(find.text('Reject payment'), findsOneWidget);

    await tester.enterText(find.byType(EditableText), '1234');
    await tester.pump();
    expect(
      find.text('That code is not valid. Please try again.'),
      findsOneWidget,
    );

    await tester.enterText(find.byType(EditableText), '8888');
    // Assert the success toast while it is visible. A full settle may advance
    // past the snackbar lifecycle on slower simulator runs.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Payment rejected successfully.'), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.text('Kite Supplies'), findsNWidgets(2));

    await tester.tap(find.text('Home'));
    await tester.pumpAndSettle();
    expect(find.text('Recent activity'), findsOneWidget);
    expect(find.text('Approved this month'), findsOneWidget);
    expect(find.text('Kite Supplies'), findsNWidgets(2));
    final totalAfterReject = _summaryAmount(tester);
    expect(totalAfterReject, totalAfterApprove);

    final firstPayment = find.ancestor(
      of: find.text('Mamo Technologies'),
      matching: find.byType(PaymentRow),
    );
    await tester.drag(firstPayment, const Offset(-500, 0));
    await tester.pumpAndSettle();
    expect(find.text('Payment removed.'), findsOneWidget);
    expect(find.text('Mamo Technologies'), findsNothing);
    final totalAfterDelete = _summaryAmount(tester);
    expect(totalAfterDelete, isNot(totalAfterReject));
  });

  testWidgets('does not open details for a pending payment', (tester) async {
    final repository = DemoPaymentRepository();
    final pending = await repository.createDemoRequest();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [paymentRepositoryProvider.overrideWithValue(repository)],
        child: const FveloxMaterial(),
      ),
    );
    await tester.pumpAndSettle(const Duration(seconds: 2));

    final context = tester.element(find.text('fvelox'));
    GoRouter.of(context).push('/payments/${pending.id}');
    await tester.pumpAndSettle();

    expect(find.text('PAYMENT DETAILS'), findsNothing);
    expect(
      find.text('This payment is still waiting for approval.'),
      findsOneWidget,
    );
  });
}

String _summaryAmount(WidgetTester tester) {
  final amountText = tester.widget<Text>(find.textContaining('AED ').first);
  return amountText.data!;
}
