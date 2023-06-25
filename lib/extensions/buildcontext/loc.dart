import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'
    show AppLocalizations;

extension LocaLoca on BuildContext {
  AppLocalizations get loc => AppLocalizations.of(this)!;
}
