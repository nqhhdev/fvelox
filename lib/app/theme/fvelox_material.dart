import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fvelox/app/providers/app_providers.dart';
import 'package:fvelox/core/design_system/fvelox_design_system.dart';
import 'package:fvelox/core/design_system/fvelox_toast_host.dart';
import 'package:fvelox/app/router/app_router.dart';
import 'package:fvelox/app/theme/fvelox_theme.dart';
import 'package:fvelox/features/payment_approval/presentation/shell/payment_app_overlay.dart';
import 'package:fvelox/l10n/fvelox_localizations_extensions.dart';
import 'package:fvelox/l10n/generated/fvelox_localizations.dart';

class FveloxMaterial extends ConsumerWidget {
  const FveloxMaterial({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => MaterialApp.router(
    onGenerateTitle: (context) => context.l10n.appTitle,
    debugShowCheckedModeBanner: false,
    theme: FveloxTheme.light(),
    localizationsDelegates: const [
      FveloxLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
    supportedLocales: FveloxLocalizations.supportedLocales,
    routerConfig: ref.watch(appRouterProvider),
    builder: (context, child) => FveloxDesignSystem(
      child: FveloxToastHost(
        controller: ref.read(fveloxToastControllerProvider),
        child: PaymentAppOverlay(child: child ?? const SizedBox.shrink()),
      ),
    ),
  );
}
