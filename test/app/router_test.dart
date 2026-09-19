import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hg_flutter/domain/session/session.dart';
import 'package:hg_flutter/generated/app_localizations.dart';

import '../helpers/test_app.dart';

void main() {
  testWidgets('unauthenticated user lands on auth', (tester) async {
    await tester.pumpWidget(testApp());
    await tester.pumpAndSettle();
    final l10n = lookupAppLocalizations(const Locale('en'));
    expect(find.text(l10n.authSubtitle), findsOneWidget);
  });

  testWidgets('authenticated user lands on home', (tester) async {
    await tester.pumpWidget(
      testApp(
        initialSession: const Session(
          userId: '1',
          email: 'ada@example.com',
          accessToken: 'token',
        ),
      ),
    );
    await tester.pumpAndSettle();
    final l10n = lookupAppLocalizations(const Locale('en'));
    expect(find.text(l10n.homeTitle), findsOneWidget);
    expect(find.text(l10n.homeSignedIn('ada@example.com')), findsOneWidget);
  });

  testWidgets('demo sign-in navigates home', (tester) async {
    await tester.pumpWidget(testApp());
    await tester.pumpAndSettle();
    final l10n = lookupAppLocalizations(const Locale('en'));

    await tester.enterText(find.byType(TextField).first, 'ada@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'password');
    await tester.tap(find.widgetWithText(ElevatedButton, l10n.authSubmit));
    await tester.pumpAndSettle();

    expect(find.text(l10n.homeTitle), findsOneWidget);
  });
}
