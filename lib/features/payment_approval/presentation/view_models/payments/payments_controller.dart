import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fvelox/core/errors/app_failure.dart';
import 'package:fvelox/features/payment_approval/domain/entities/payment.dart';
import 'package:fvelox/features/payment_approval/domain/interactors/payments/delete_payment_interactor.dart';
import 'package:fvelox/features/payment_approval/domain/interactors/payments/delete_payments_interactor.dart';
import 'package:fvelox/features/payment_approval/domain/interactors/payments/get_decided_payments_interactor.dart';
import 'package:fvelox/features/payment_approval/presentation/view_models/payments/payments_screen_state.dart';

final class PaymentsController extends StateNotifier<PaymentsScreenState> {
  PaymentsController({
    required GetDecidedPaymentsInteractor getDecidedPayments,
    required DeletePaymentInteractor deletePayment,
    required DeletePaymentsInteractor deletePayments,
    required void Function() requestScreenRefresh,
  }) : _getDecidedPayments = getDecidedPayments,
       _deletePayment = deletePayment,
       _deletePayments = deletePayments,
       _requestScreenRefresh = requestScreenRefresh,
       super(const PaymentsScreenState());

  final GetDecidedPaymentsInteractor _getDecidedPayments;
  final DeletePaymentInteractor _deletePayment;
  final DeletePaymentsInteractor _deletePayments;
  final void Function() _requestScreenRefresh;
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
      final payments = await _readPayments();
      if (revision != _loadRevision) return;
      state = state.copyWith(
        payments: payments,
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
      // immediately; screen refresh then reconciles Home/other tabs.
      state = state.copyWith(
        payments: state.payments.where((payment) => payment.id != id).toList(),
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

  Future<int> deletePayments(List<String> ids) async {
    if (state.isDeleting) return 0;
    state = state.copyWith(isDeleting: true);
    try {
      final result = await _deletePayments.execute(ids).last;
      if (!result.isSuccess) {
        throw result.failure ?? const NetworkFailure();
      }
      final deletedIds = ids.toSet();
      state = state.copyWith(
        payments: state.payments
            .where((payment) => !deletedIds.contains(payment.id))
            .toList(),
      );
      _requestScreenRefresh();
      return result.deletedCount;
    } catch (error) {
      final failure = _toFailure(error);
      throw failure;
    } finally {
      state = state.copyWith(isDeleting: false);
    }
  }

  Future<List<Payment>> _readPayments() async {
    final result = await _getDecidedPayments.execute().last;
    if (result.isSuccess) return result.payments;
    throw result.failure ?? const NetworkFailure();
  }

  AppFailure _toFailure(Object error) =>
      error is AppFailure ? error : const NetworkFailure();
}
