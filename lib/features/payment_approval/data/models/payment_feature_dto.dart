final class PaymentFeatureDto {
  const PaymentFeatureDto({required this.enabled, required this.authRequired});
  final bool enabled;
  final bool authRequired;
  factory PaymentFeatureDto.fromJson(Map<String, dynamic> json) =>
      PaymentFeatureDto(
        enabled: json['enabled'] as bool,
        authRequired: json['auth_required'] as bool,
      );
}
