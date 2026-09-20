import 'package:flutter/widgets.dart';
import 'package:fvelox/l10n/generated/fvelox_localizations.dart';

extension FveloxLocalizationsContext on BuildContext {
  FveloxLocalizations get l10n => FveloxLocalizations.of(this)!;
}
