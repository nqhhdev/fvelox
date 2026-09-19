import 'package:fvelox/core/local_database/fvelox_database.dart';
import 'package:fvelox/features/payment_approval/domain/entities/payment_feature.dart';
import 'package:fvelox/features/payment_approval/data/models/payment_feature_dto.dart';

const paymentFeatureCacheKey = 'payment_approval';

extension PaymentFeatureDtoX on PaymentFeatureDto {
  PaymentFeature toEntity() =>
      PaymentFeature(enabled: enabled, authRequired: authRequired);
}

extension PaymentFeatureX on PaymentFeature {
  PaymentFeatureTableCompanion toCompanion() =>
      PaymentFeatureTableCompanion.insert(
        featureKey: paymentFeatureCacheKey,
        enabled: enabled,
        authRequired: authRequired,
        cachedAt: DateTime.now(),
      );
}

extension PaymentFeatureTableDataX on PaymentFeatureTableData {
  PaymentFeature toEntity() =>
      PaymentFeature(enabled: enabled, authRequired: authRequired);
}
