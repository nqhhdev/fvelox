import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:patrol/patrol.dart';

import 'package:fvelox/app/providers/payment_approval_providers.dart';
import 'package:fvelox/features/payment_approval/presentation/widgets/approval_sheet.dart';
import 'package:fvelox/features/payment_approval/presentation/widgets/payment_row.dart';
import 'package:fvelox/features/payment_approval/presentation/widgets/summary_card.dart';

final class PaymentAcceptanceRobot {
  PaymentAcceptanceRobot(this.$);

  final PatrolIntegrationTester $;

  Finder get fab => find.byTooltip('Create incoming payment request');

  Future<void> verifyEmptyHome() async {
    await $('Recent activity').waitUntilVisible();
    await $('Approved this month').waitUntilVisible();
    expect(find.text('Recent activity'), findsOneWidget);
    expect(find.text('Approved this month'), findsOneWidget);
    expect(find.text('AED 0.00'), findsOneWidget);
    expect(find.text('No decided payments yet.'), findsOneWidget);
  }

  Future<void> dragFabToRememberedPosition() async {
    final initialCenter = $.tester.getCenter(fab);
    await $.tester.timedDrag(
      fab,
      const Offset(-180, -120),
      const Duration(milliseconds: 500),
    );
    await $.pumpAndSettle();

    final draggedCenter = $.tester.getCenter(fab);
    expect(draggedCenter.dx, lessThan(initialCenter.dx - 80));
    expect(draggedCenter.dy, lessThan(initialCenter.dy - 40));
  }

  Future<void> openRequest() async {
    await $(fab).tap();
    expect(find.byType(ApprovalSheet), findsOneWidget);
    expect(find.text('Review before you decide.'), findsOneWidget);
    expect(find.textContaining('From: ••••••••••'), findsOneWidget);
    expect(find.textContaining('Amount: AED ••••••'), findsOneWidget);
    expect(find.textContaining('Reference: KITE-240919-'), findsOneWidget);
    expect(find.text('Payment details'), findsNothing);
  }

  Future<void> approveWithOtp() async {
    await $(find.text('Approve')).tap();
    expect(find.text('Approve payment'), findsOneWidget);

    await $(find.byType(EditableText)).enterText('1234');
    await $('That code is not valid. Please try again.').waitUntilVisible();

    await $(find.byType(EditableText)).enterText('8888');
    await $('Payment approved successfully.').waitUntilExists();
    await $.pumpAndSettle();

    expect(find.byType(ApprovalSheet), findsNothing);
    expect(find.text('Approve payment'), findsNothing);
    expect(find.text('All decided payments'), findsOneWidget);
    expect(find.text('Kite Supplies'), findsOneWidget);
  }

  Future<String> readHomeSummaryAmount() async {
    await $(find.text('Home')).tap();
    final summaryAmount = find.descendant(
      of: find.byType(SummaryCard),
      matching: find.textContaining('AED '),
    );
    return $.tester.widget<Text>(summaryAmount).data!;
  }

  Future<void> openHomePaymentDetails() async {
    final paymentRow = find.ancestor(
      of: find.text('Kite Supplies'),
      matching: find.byType(PaymentRow),
    );
    await $(paymentRow).tap();
    await $('PAYMENT DETAILS').waitUntilVisible();
    expect(find.text('Back to Home'), findsOneWidget);
    expect(find.text('Approved'), findsOneWidget);
    expect(find.textContaining('KITE-240919-'), findsOneWidget);
    expect(find.byTooltip('Create incoming payment request'), findsOneWidget);
    expect(find.byType(AppBar), findsNothing);
    await $('Back to Home').tap();
  }

  Future<void> rejectFromHome() async {
    await $(fab).tap();
    expect(find.text('Review before you decide.'), findsOneWidget);
    await $(find.text('Reject')).tap();
    expect(find.text('Reject payment'), findsOneWidget);
    await $(find.byType(EditableText)).enterText('8888');
    await $('Payment rejected successfully.').waitUntilExists();
    await $.pumpAndSettle();

    expect(find.byType(ApprovalSheet), findsNothing);
    expect(find.text('Recent activity'), findsOneWidget);
    expect(find.text('Kite Supplies'), findsNWidgets(2));
  }

  Future<void> verifyPaymentsListAndDetails() async {
    await $(find.text('Payments')).tap();
    await $('All decided payments').waitUntilVisible();
    expect(find.byType(PaymentRow), findsNWidgets(2));
    expect(find.textContaining('AED '), findsNWidgets(2));
    expect(find.text('Approved'), findsOneWidget);
    expect(find.text('Rejected'), findsOneWidget);
    expect(find.byTooltip('Create incoming payment request'), findsOneWidget);

    final firstPayment = find.byType(PaymentRow).first;
    expect(
      find.descendant(of: firstPayment, matching: find.text('Rejected')),
      findsOneWidget,
    );
    await $(firstPayment).tap();
    await $('PAYMENT DETAILS').waitUntilVisible();
    expect(find.text('Back to Payments'), findsOneWidget);
    expect(find.text('Rejected'), findsOneWidget);
    expect(find.textContaining('AED '), findsOneWidget);
    await $('Back to Payments').tap();
  }

  Future<void> verifyPendingPaymentCannotOpenDetails() async {
    final context = $.tester.element(find.text('All decided payments'));
    final container = ProviderScope.containerOf(context);
    final pending = await container
        .read(paymentRepositoryProvider)
        .createDemoRequest();
    final router = GoRouter.of(context);
    router.push('/payments/${pending.id}');
    await $.pumpAndSettle();

    await $(
      find.text('This payment is still waiting for approval.'),
    ).waitUntilVisible();
    expect(find.text('PAYMENT DETAILS'), findsNothing);
    router.pop();
    await $.pumpAndSettle();
    expect(find.text('All decided payments'), findsOneWidget);
  }

  Future<void> deleteDecidedPaymentsAndVerifySummaryRefresh(
    String summaryAfterApproval,
  ) async {
    final firstPayment = find.byType(PaymentRow).first;
    await $.tester.timedDrag(
      firstPayment,
      const Offset(-500, 0),
      const Duration(milliseconds: 500),
    );
    await $('Payment removed.').waitUntilExists();
    await $.pumpAndSettle();
    expect(find.byType(PaymentRow), findsOneWidget);
    expect(find.text('Kite Supplies'), findsOneWidget);

    final remainingPayment = find.byType(PaymentRow).first;
    await $.tester.timedDrag(
      remainingPayment,
      const Offset(-500, 0),
      const Duration(milliseconds: 500),
    );
    await $('Payment removed.').waitUntilExists();
    await $.pumpAndSettle();
    expect(find.byType(PaymentRow), findsNothing);

    final summaryAfterDelete = await readHomeSummaryAmount();
    expect(summaryAfterDelete, 'AED 0.00');
    expect(summaryAfterDelete, isNot(summaryAfterApproval));
    expect(find.text('No decided payments yet.'), findsOneWidget);
  }
}
