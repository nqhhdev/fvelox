import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fvelox/core/design_system/fvelox_toast_controller.dart';
import 'package:fvelox/core/errors/app_failure.dart';
import 'package:fvelox/core/errors/app_failure_localization.dart';
import 'package:fvelox/features/payment_approval/domain/entities/payment.dart';
import 'package:fvelox/features/payment_approval/domain/entities/payment_summary.dart';
import 'package:fvelox/features/payment_approval/domain/interactors/home/get_payment_summary_interactor.dart';
import 'package:fvelox/features/payment_approval/domain/interactors/payments/delete_payment_interactor.dart';
import 'package:fvelox/features/payment_approval/domain/interactors/payments/get_decided_payments_interactor.dart';
import 'package:fvelox/l10n/generated/fvelox_localizations.dart';
import 'package:fvelox/features/payment_approval/presentation/view_models/home/home_screen_state.dart';

final class HomeController extends StateNotifier<HomeScreenState> {
  HomeController({
    required GetPaymentSummaryInteractor getPaymentSummary,
    required GetDecidedPaymentsInteractor getDecidedPayments,
    required DeletePaymentInteractor deletePayment,
    required void Function() requestScreenRefresh,
    required FveloxToastController toast,
  }) : _getPaymentSummary = getPaymentSummary,
       _getDecidedPayments = getDecidedPayments,
       _deletePayment = deletePayment,
       _requestScreenRefresh = requestScreenRefresh,
       _toast = toast,
       super(HomeScreenState(dateTime: DateTime.now()));

  final GetPaymentSummaryInteractor _getPaymentSummary;
  final GetDecidedPaymentsInteractor _getDecidedPayments;
  final DeletePaymentInteractor _deletePayment;
  final void Function() _requestScreenRefresh;
  final FveloxToastController _toast;
  int _loadRevision = 0;
  final Set<String> _deletingIds = <String>{};

  Future<void> load() async {
    final revision = ++_loadRevision;
    final isInitialLoad = !state.hasStartedLoading;
    state = state.copyWith(
      isLoading: isInitialLoad,
      isRefreshing: !isInitialLoad,
      hasStartedLoading: true,
      clearFailure: true,
    );
    try {
      final values = await Future.wait<Object>([
        _readSummary(_currentMonth()),
        _readRecentPayments(),
      ]);
      if (revision != _loadRevision) return;
      state = state.copyWith(
        summary: values[0] as PaymentSummary,
        recentPayments: values[1] as List<Payment>,
        isLoading: false,
        isRefreshing: false,
      );
    } catch (error) {
      if (revision != _loadRevision) return;
      state = state.copyWith(
        isLoading: false,
        isRefreshing: false,
        failure: _toFailure(error),
      );
    }
  }

  Future<void> deletePayment(String id) async {
    if (_deletingIds.contains(id)) {
      throw const NetworkFailure(code: 'delete_in_progress');
    }
    _deletingIds.add(id);
    state = state.copyWith(isDeleting: true);
    try {
      final result = await _deletePayment.execute(id).last;
      if (!result.isSuccess) {
        throw result.failure ?? const NetworkFailure();
      }
      // Drop the row before confirmDismiss returns so Dismissible leaves the tree
      // immediately; screen refresh then reconciles summary/other tabs.
      state = state.copyWith(
        recentPayments: state.recentPayments
            .where((payment) => payment.id != id)
            .toList(),
        isDeleting: _deletingIds.length > 1,
      );
      _requestScreenRefresh();
    } catch (error) {
      final failure = _toFailure(error);
      throw failure;
    } finally {
      _deletingIds.remove(id);
      state = state.copyWith(isDeleting: _deletingIds.isNotEmpty);
    }
  }

  /// Deletes [payment] and reports the outcome through the toast controller.
  /// Returns whether the row may be dismissed.
  Future<bool> deletePaymentWithFeedback(
    Payment payment,
    FveloxLocalizations l10n,
  ) async {
    try {
      await deletePayment(payment.id);
      _toast.showSuccess(l10n.paymentDeletedSuccess);
      return true;
    } on AppFailure catch (error) {
      if (error.code == 'delete_in_progress') return false;
      _toast.showError(error.toLocalizedMessage(l10n));
      return false;
    }
  }

  Future<PaymentSummary> _readSummary(String month) async {
    final result = await _getPaymentSummary.execute(month).last;
    if (result.isSuccess && result.summary != null) return result.summary!;
    throw result.failure ?? const NetworkFailure();
  }

  Future<List<Payment>> _readRecentPayments() async {
    final result = await _getDecidedPayments.execute().last;
    if (result.isSuccess) return result.payments;
    throw result.failure ?? const NetworkFailure();
  }

  String _currentMonth() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}';
  }

  AppFailure _toFailure(Object error) =>
      error is AppFailure ? error : const NetworkFailure();
}
