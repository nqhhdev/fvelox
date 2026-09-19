import 'package:fvelox/core/errors/app_failure_base.dart';

final class PaymentApiFailure extends AppFailure {
  const PaymentApiFailure({
    required String code,
    String message = '',
    this.statusCode,
  }) : super(code, message: message);

  final int? statusCode;
}
