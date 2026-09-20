import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

import '../robots/payment_acceptance_robot.dart';

final class PaymentAcceptanceScenario {
  PaymentAcceptanceScenario(this.$);

  final PatrolIntegrationTester $;

  Future<void> run() async {
    final app = PaymentAcceptanceRobot($);
    await $.pumpAndSettle();
    await app.verifyEmptyHome();

    await app.dragFabToRememberedPosition();
    final draggedFabCenter = $.tester.getCenter(app.fab);
    await app.openRequest();
    expect(find.byTooltip('Create incoming payment request'), findsOneWidget);
    await app.approveWithOtp();

    final summaryAfterApproval = await app.readHomeSummaryAmount();
    expect(summaryAfterApproval, isNot('AED 0.00'));

    final fabAfterApproval = $.tester.getCenter(app.fab);
    expect(fabAfterApproval.dx, closeTo(draggedFabCenter.dx, 2));
    expect(fabAfterApproval.dy, closeTo(draggedFabCenter.dy, 2));
    await app.openHomePaymentDetails();

    await app.rejectFromHome();
    final summaryAfterReject = await app.readHomeSummaryAmount();
    expect(summaryAfterReject, summaryAfterApproval);

    await app.verifyPaymentsListAndDetails();
    await app.verifyPendingPaymentCannotOpenDetails();
    await app.deleteDecidedPaymentsAndVerifySummaryRefresh(
      summaryAfterApproval,
    );
  }
}
