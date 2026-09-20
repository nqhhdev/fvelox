import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

/// App-level launch assertions shared by Patrol scenarios.
final class AppRobot {
  AppRobot(this.$);

  final PatrolIntegrationTester $;

  Future<void> waitForHome() async {
    await $('fvelox').waitUntilVisible();
    await $('Recent activity').waitUntilVisible();
    await $.pumpAndSettle();
    expect(find.text('fvelox'), findsOneWidget);
    expect(find.text('Recent activity'), findsOneWidget);
  }
}
