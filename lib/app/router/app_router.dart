import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:fvelox/app/router/fvelox_route_page.dart';
import 'package:fvelox/features/payment_approval/domain/entities/payment.dart';
import 'package:fvelox/features/payment_approval/presentation/screens/payment_details_route.dart';
import 'package:fvelox/features/payment_approval/presentation/shell/payment_shell.dart';

final appNavigatorKeyProvider = Provider<GlobalKey<NavigatorState>>(
  (ref) => GlobalKey<NavigatorState>(),
);

final appRouterProvider = Provider<GoRouter>(
  (ref) => GoRouter(
    navigatorKey: ref.watch(appNavigatorKeyProvider),
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) => PaymentShell(child: child),
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const SizedBox.shrink(),
          ),
          GoRoute(
            path: '/payments/:paymentId',
            pageBuilder: (context, state) => FveloxRoutePage.slideFade(
              key: state.pageKey,
              child: PaymentDetailsRoute(
                paymentId: state.pathParameters['paymentId']!,
                fromHome: state.uri.queryParameters['from'] == 'home',
                cachedPayment: state.extra as Payment?,
              ),
            ),
          ),
        ],
      ),
    ],
  ),
);
