import 'package:fvelox/core/errors/app_failure_base.dart';

final class LocalStorageFailure extends AppFailure {
  const LocalStorageFailure({
    String code = 'local_storage_error',
    String message = '',
  }) : super(code, message: message);
}
