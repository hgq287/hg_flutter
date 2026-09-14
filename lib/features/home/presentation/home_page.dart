import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hg_flutter/app/di/providers.dart';
import 'package:hg_flutter/design/tokens/spacing.dart';
import 'package:hg_flutter/generated/app_localizations.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final session = ref.watch(sessionPortProvider).current();
    final email = session?.email ?? '';

    return Scaffold(
      appBar: AppBar(title: Text(l10n.homeTitle)),
      body: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.homeSignedIn(email),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: defaultPadding),
            ElevatedButton(
              onPressed: () => context.go('/assistant'),
              child: Text(l10n.homeAssistant),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {
                unawaited(ref.read(signOutUseCaseProvider).call());
              },
              child: Text(l10n.homeSignOut),
            ),
          ],
        ),
      ),
    );
  }
}
