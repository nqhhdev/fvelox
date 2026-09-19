import 'package:fvelox/core/errors/app_failure_base.dart';

final class NetworkFailure extends AppFailure {
  const NetworkFailure({String code = 'network_error', String message = ''})
    : super(code, message: message);
}
