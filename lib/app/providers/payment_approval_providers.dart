import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fvelox/app/providers/app_providers.dart';
import 'package:fvelox/core/local_database/fvelox_database.dart';
import 'package:fvelox/core/network/dio_client.dart';
import 'package:fvelox/features/payment_approval/data/data_sources/dio_payment_remote_data_source.dart';
import 'package:fvelox/features/payment_approval/data/data_sources/drift_payment_local_data_source.dart';
import 'package:fvelox/features/payment_approval/data/data_sources/payment_local_data_source.dart';
import 'package:fvelox/features/payment_approval/data/data_sources/payment_remote_data_source.dart';
import 'package:fvelox/features/payment_approval/data/repositories/dio_payment_repository.dart';
import 'package:fvelox/features/payment_approval/domain/repositories/payment_repository.dart';
import 'package:fvelox/features/payment_approval/domain/interactors/approval/create_demo_request_interactor.dart';
import 'package:fvelox/features/payment_approval/domain/interactors/approval/decide_payment_interactor.dart';
import 'package:fvelox/features/payment_approval/domain/interactors/approval/validate_payment_otp_interactor.dart';
import 'package:fvelox/features/payment_approval/domain/interactors/feature/get_payment_feature_interactor.dart';
import 'package:fvelox/features/payment_approval/domain/interactors/home/get_payment_summary_interactor.dart';
import 'package:fvelox/features/payment_approval/domain/interactors/payments/delete_payment_interactor.dart';
import 'package:fvelox/features/payment_approval/domain/interactors/payments/delete_payments_interactor.dart';
import 'package:fvelox/features/payment_approval/domain/interactors/payments/get_decided_payments_interactor.dart';
import 'package:fvelox/features/payment_approval/domain/interactors/payments/get_payment_details_interactor.dart';
import 'package:fvelox/features/payment_approval/presentation/view_models/approval/payment_approval_flow_controller.dart';
import 'package:fvelox/features/payment_approval/presentation/view_models/approval/payment_approval_flow_state.dart';
import 'package:fvelox/features/payment_approval/presentation/view_models/approval/payment_approval_ui_controller.dart';
import 'package:fvelox/features/payment_approval/presentation/view_models/approval/payment_approval_ui_state.dart';
import 'package:fvelox/features/payment_approval/presentation/view_models/details/payment_details_arguments.dart';
import 'package:fvelox/features/payment_approval/presentation/view_models/details/payment_details_controller.dart';
import 'package:fvelox/features/payment_approval/presentation/view_models/details/payment_details_screen_state.dart';
import 'package:fvelox/features/payment_approval/presentation/view_models/feature/payment_feature_controller.dart';
import 'package:fvelox/features/payment_approval/presentation/view_models/feature/payment_feature_screen_state.dart';
import 'package:fvelox/features/payment_approval/presentation/view_models/home/home_controller.dart';
import 'package:fvelox/features/payment_approval/presentation/view_models/home/home_screen_state.dart';
import 'package:fvelox/features/payment_approval/presentation/view_models/payments/payments_controller.dart';
import 'package:fvelox/features/payment_approval/presentation/view_models/payments/payments_screen_state.dart';
import 'package:fvelox/features/payment_approval/presentation/view_models/refresh/payment_screen_refresh_controller.dart';
import 'package:fvelox/features/payment_approval/presentation/view_models/shell/payment_shell_ui_controller.dart';
import 'package:fvelox/features/payment_approval/presentation/view_models/shell/payment_shell_ui_state.dart';

final paymentDatabaseProvider = Provider<FveloxDatabase>((ref) {
  final database = FveloxDatabase();
  ref.onDispose(database.close);
  return database;
});

final paymentLocalDataSourceProvider = Provider<PaymentLocalDataSource>(
  (ref) => DriftPaymentLocalDataSource(
    ref.watch(paymentDatabaseProvider).paymentDao,
  ),
);

final paymentRemoteDataSourceProvider = Provider<PaymentRemoteDataSource>(
  (ref) => DioPaymentRemoteDataSource(
    FveloxDioClient(
      authTokenProvider: ref.watch(authTokenProvider),
      logger: ref.watch(appLoggerProvider),
    ),
    ref.watch(appLoggerProvider),
  ),
);

final paymentRepositoryProvider = Provider<PaymentRepository>(
  (ref) => DioPaymentRepository(
    ref.watch(paymentRemoteDataSourceProvider),
    ref.watch(paymentLocalDataSourceProvider),
    ref.watch(connectivityServiceProvider),
    ref.watch(appLoggerProvider),
  ),
);

final getDecidedPaymentsInteractorProvider =
    Provider<GetDecidedPaymentsInteractor>(
      (ref) =>
          GetDecidedPaymentsInteractor(ref.watch(paymentRepositoryProvider)),
    );

final getPaymentFeatureInteractorProvider =
    Provider<GetPaymentFeatureInteractor>(
      (ref) =>
          GetPaymentFeatureInteractor(ref.watch(paymentRepositoryProvider)),
    );

final getPaymentSummaryInteractorProvider =
    Provider<GetPaymentSummaryInteractor>(
      (ref) =>
          GetPaymentSummaryInteractor(ref.watch(paymentRepositoryProvider)),
    );

final getPaymentDetailsInteractorProvider =
    Provider<GetPaymentDetailsInteractor>(
      (ref) =>
          GetPaymentDetailsInteractor(ref.watch(paymentRepositoryProvider)),
    );

final createDemoRequestInteractorProvider =
    Provider<CreateDemoRequestInteractor>(
      (ref) =>
          CreateDemoRequestInteractor(ref.watch(paymentRepositoryProvider)),
    );

final decidePaymentInteractorProvider = Provider<DecidePaymentInteractor>(
  (ref) => DecidePaymentInteractor(ref.watch(paymentRepositoryProvider)),
);

final deletePaymentInteractorProvider = Provider<DeletePaymentInteractor>(
  (ref) => DeletePaymentInteractor(ref.watch(paymentRepositoryProvider)),
);

final deletePaymentsInteractorProvider = Provider<DeletePaymentsInteractor>(
  (ref) => DeletePaymentsInteractor(ref.watch(paymentRepositoryProvider)),
);

final validatePaymentOtpInteractorProvider =
    Provider<ValidatePaymentOtpInteractor>(
      (ref) => const ValidatePaymentOtpInteractor(),
    );

final paymentScreenRefreshControllerProvider =
    StateNotifierProvider<PaymentScreenRefreshController, int>(
      (ref) => PaymentScreenRefreshController(),
    );

final paymentFeatureControllerProvider =
    StateNotifierProvider<PaymentFeatureController, PaymentFeatureScreenState>((
      ref,
    ) {
      final controller = PaymentFeatureController(
        getFeature: ref.watch(getPaymentFeatureInteractorProvider),
      );
      Future.microtask(controller.load);
      return controller;
    });

final homeControllerProvider =
    StateNotifierProvider<HomeController, HomeScreenState>((ref) {
      final controller = HomeController(
        getPaymentSummary: ref.watch(getPaymentSummaryInteractorProvider),
        getDecidedPayments: ref.watch(getDecidedPaymentsInteractorProvider),
        deletePayment: ref.watch(deletePaymentInteractorProvider),
        requestScreenRefresh: () => ref
            .read(paymentScreenRefreshControllerProvider.notifier)
            .requestRefresh(),
      );
      ref.listen<int>(paymentScreenRefreshControllerProvider, (previous, next) {
        controller.load();
      });
      Future.microtask(controller.load);
      return controller;
    });

final paymentsControllerProvider =
    StateNotifierProvider<PaymentsController, PaymentsScreenState>((ref) {
      final controller = PaymentsController(
        getDecidedPayments: ref.watch(getDecidedPaymentsInteractorProvider),
        deletePayment: ref.watch(deletePaymentInteractorProvider),
        deletePayments: ref.watch(deletePaymentsInteractorProvider),
        requestScreenRefresh: () => ref
            .read(paymentScreenRefreshControllerProvider.notifier)
            .requestRefresh(),
      );
      ref.listen<int>(paymentScreenRefreshControllerProvider, (previous, next) {
        controller.load();
      });
      Future.microtask(controller.load);
      return controller;
    });

final paymentApprovalFlowControllerProvider =
    StateNotifierProvider<
      PaymentApprovalFlowController,
      PaymentApprovalFlowState
    >((ref) {
      return PaymentApprovalFlowController(
        createDemoRequest: ref.watch(createDemoRequestInteractorProvider),
        decidePayment: ref.watch(decidePaymentInteractorProvider),
        validatePaymentOtp: ref.watch(validatePaymentOtpInteractorProvider),
        requestScreenRefresh: () => ref
            .read(paymentScreenRefreshControllerProvider.notifier)
            .requestRefresh(),
      );
    });

final paymentShellUiControllerProvider =
    StateNotifierProvider<PaymentShellUiController, PaymentShellUiState>(
      (ref) => PaymentShellUiController(),
    );

final paymentApprovalUiControllerProvider =
    StateNotifierProvider<PaymentApprovalUiController, PaymentApprovalUiState>(
      (ref) => PaymentApprovalUiController(),
    );

final paymentDetailsControllerProvider =
    StateNotifierProvider.family<
      PaymentDetailsController,
      PaymentDetailsScreenState,
      PaymentDetailsArguments
    >((ref, arguments) {
      final controller = PaymentDetailsController(
        getPaymentDetails: ref.watch(getPaymentDetailsInteractorProvider),
      );
      Future.microtask(
        () => controller.load(
          cachedPayment: arguments.cachedPayment,
          paymentId: arguments.paymentId,
        ),
      );
      return controller;
    });
