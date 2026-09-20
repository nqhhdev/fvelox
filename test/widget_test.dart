import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fvelox/app/providers/app_providers.dart';
import 'package:fvelox/app/theme/fvelox_material.dart';
import 'package:fvelox/features/payment_approval/data/repositories/demo_payment_repository.dart';
import 'package:fvelox/features/payment_approval/presentation/providers/payment_providers.dart';
import 'package:fvelox/features/payment_approval/presentation/widgets/payment_row.dart';
import 'package:fvelox/features/payment_approval/presentation/widgets/payment_navigation_bar.dart';
import 'package:fvelox/features/payment_approval/presentation/widgets/approval_sheet.dart';
import 'package:fvelox/features/payment_approval/presentation/widgets/top_bar.dart';

void main() {
  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          paymentRepositoryProvider.overrideWithValue(DemoPaymentRepository()),
        ],
        child: const FveloxMaterial(),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('renders the payment approval home screen', (tester) async {
    await pumpApp(tester);

    expect(find.text('fvelox'), findsOneWidget);
    expect(find.textContaining('Boss.'), findsOneWidget);
    expect(find.text('Recent activity'), findsOneWidget);
  });

  testWidgets('switches between Home and Payments inside the shell', (
    tester,
  ) async {
    await pumpApp(tester);

    await tester.tap(find.text('Payments'));
    await tester.pumpAndSettle();

    expect(find.text('All decided payments'), findsOneWidget);
    expect(find.text('Payments'), findsWidgets);
  });

  testWidgets('drags the payment FAB and snaps it to the nearest edge', (
    tester,
  ) async {
    await pumpApp(tester);

    final fab = find.byTooltip('Create incoming payment request');
    final initialCenter = tester.getCenter(fab);

    await tester.drag(fab, const Offset(-620, -140));
    await tester.pumpAndSettle();

    final draggedCenter = tester.getCenter(fab);
    expect(draggedCenter.dx, lessThan(100));
    expect(draggedCenter.dy, lessThan(initialCenter.dy - 80));

    await tester.tap(find.text('Payments'));
    await tester.pumpAndSettle();

    final positionAfterTabChange = tester.getCenter(
      find.byTooltip('Create incoming payment request'),
    );
    expect(positionAfterTabChange.dx, closeTo(draggedCenter.dx, 1));
    expect(positionAfterTabChange.dy, closeTo(draggedCenter.dy, 1));
  });

  testWidgets('opens payment details from recent activity', (tester) async {
    await pumpApp(tester);

    final firstPayment = find.byType(PaymentRow).first;
    await tester.ensureVisible(firstPayment);
    await tester.tap(firstPayment);
    await tester.pumpAndSettle();

    expect(find.text('PAYMENT DETAILS'), findsOneWidget);
    expect(find.text('Back to Home'), findsOneWidget);
    expect(find.text('MAMO-240919-01'), findsOneWidget);
    expect(find.byTooltip('Create incoming payment request'), findsOneWidget);
    expect(find.byType(PaymentNavigationBar), findsNothing);
    expect(find.byType(TopBar), findsNothing);
  });

  testWidgets('swipes a payment card right to left to delete it', (
    tester,
  ) async {
    await pumpApp(tester);

    final firstPayment = find.byType(PaymentRow).first;
    await tester.drag(firstPayment, const Offset(-500, 0));
    await tester.pumpAndSettle();

    expect(find.text('Mamo Technologies'), findsNothing);
    expect(find.text('Payment removed.'), findsOneWidget);
  });

  testWidgets(
    'returns a payment card when the swipe is below the delete threshold',
    (tester) async {
      await pumpApp(tester);

      final firstPayment = find.byType(PaymentRow).first;
      await tester.timedDrag(
        firstPayment,
        const Offset(-60, 0),
        const Duration(milliseconds: 500),
      );
      await tester.pumpAndSettle();

      expect(find.text('Mamo Technologies'), findsOneWidget);
      expect(find.text('Payment removed.'), findsNothing);
    },
  );

  testWidgets('creates and approves a request from the payment FAB', (
    tester,
  ) async {
    await pumpApp(tester);

    await tester.tap(find.byTooltip('Create incoming payment request'));
    await tester.pumpAndSettle();
    expect(find.text('Review before you decide.'), findsOneWidget);

    await tester.tap(find.text('Approve'));
    await tester.pumpAndSettle();
    expect(find.text('Approve payment'), findsOneWidget);

    await tester.enterText(find.byType(EditableText), '8888');
    await tester.pumpAndSettle();

    expect(find.text('Payments'), findsWidgets);
    expect(find.text('Payment approved successfully.'), findsOneWidget);
    expect(find.byType(ApprovalSheet), findsNothing);
    expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
    expect(
      tester.getTopLeft(find.text('Payment approved successfully.')).dy,
      lessThan(160),
    );
    expect(find.text('Kite Supplies'), findsOneWidget);
  });

  testWidgets('shows inline OTP feedback and rejects a request', (
    tester,
  ) async {
    await pumpApp(tester);

    await tester.tap(find.byTooltip('Create incoming payment request'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reject'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(EditableText), '1234');
    await tester.pump();
    expect(
      find.text('That code is not valid. Please try again.'),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.error_rounded), findsNothing);

    await tester.enterText(find.byType(EditableText), '8888');
    await tester.pumpAndSettle();

    expect(find.text('Payment rejected successfully.'), findsOneWidget);
    expect(find.byType(ApprovalSheet), findsNothing);
    expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
    expect(find.text('Kite Supplies'), findsOneWidget);
  });

  testWidgets('shows the cached-data banner while offline', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          paymentRepositoryProvider.overrideWithValue(DemoPaymentRepository()),
          connectivityStatusProvider.overrideWith(
            (ref) => Stream<bool>.value(false),
          ),
        ],
        child: const FveloxMaterial(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Offline — showing cached payments'), findsOneWidget);
  });
}
