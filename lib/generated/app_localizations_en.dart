// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Hg Flutter';

  @override
  String get authTitle => 'Sign in';

  @override
  String get authSubtitle => 'Use your account to continue';

  @override
  String get authEmail => 'Email';

  @override
  String get authPassword => 'Password';

  @override
  String get authSubmit => 'Sign in';

  @override
  String get authValidation => 'Enter an email and password';

  @override
  String get authError => 'Sign in failed';

  @override
  String get homeTitle => 'Home';

  @override
  String homeSignedIn(String email) {
    return 'Signed in as $email';
  }

  @override
  String get homeAssistant => 'Assistant';

  @override
  String get homeSignOut => 'Sign out';

  @override
  String get assistantTitle => 'Assistant';

  @override
  String get assistantHint => 'Ask a question';

  @override
  String get assistantSend => 'Send';

  @override
  String get assistantEmpty =>
      'Ask about help articles or your sample balance. Transfers are refused.';
}
