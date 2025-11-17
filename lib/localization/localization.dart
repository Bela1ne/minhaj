import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';

class AppLocalizations {
  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocDelegate();

  static const supportedLocales = [Locale('fr'), Locale('ar')];

  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  String get appTitle {
    if (locale.languageCode == 'ar') return 'منهج';
    return 'Minhaj';
  }

// Ajoute ici d'autres getters (Accueil, Paramètres, ...)
}

class _AppLocDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocDelegate();
  @override
  bool isSupported(Locale locale) => ['fr', 'ar'].contains(locale.languageCode);
  @override
  Future<AppLocalizations> load(Locale locale) => SynchronousFuture(AppLocalizations(locale));
  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) => false;
}
