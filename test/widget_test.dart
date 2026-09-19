import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hg_flutter/generated/app_localizations.dart';

import 'helpers/test_app.dart';

void main() {
  testWidgets('app boots to auth', (tester) async {
    await tester.pumpWidget(testApp());
    await tester.pumpAndSettle();
    expect(
      find.text(lookupAppLocalizations(const Locale('en')).authSubtitle),
      findsOneWidget,
    );
  });
}
