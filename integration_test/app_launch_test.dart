import 'base/test_base.dart';
import 'scenarios/app_launch_scenario.dart';
import 'scenarios/payment_acceptance_scenario.dart';

void main() {
  TestBase.run(
    description: 'app launches successfully',
    body: ($) async {
      await AppLaunchScenario($).run();
    },
  );
  TestBase.run(
    description: 'payment approval acceptance flow',
    body: ($) async {
      await PaymentAcceptanceScenario($).run();
    },
  );
}
