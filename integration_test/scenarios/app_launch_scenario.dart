import 'package:patrol/patrol.dart';

import '../robots/app_robot.dart';

final class AppLaunchScenario {
  AppLaunchScenario(this.$);

  final PatrolIntegrationTester $;

  Future<void> run() async {
    final app = AppRobot($);
    await app.waitForHome();
  }
}
