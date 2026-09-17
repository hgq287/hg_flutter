import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hg_flutter/design/tokens/spacing.dart';
import 'package:hg_flutter/features/assistant/presentation/assistant_controller.dart';
import 'package:hg_flutter/generated/app_localizations.dart';

class AssistantPage extends ConsumerStatefulWidget {
  const AssistantPage({super.key});

  @override
  ConsumerState<AssistantPage> createState() => _AssistantPageState();
}

class _AssistantPageState extends ConsumerState<AssistantPage> {
  final _question = TextEditingController();

  @override
  void dispose() {
    _question.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(assistantControllerProvider);

    ref.listen(assistantControllerProvider, (previous, next) {
      if (next.route != null) {
        context.go(next.route!);
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text(l10n.assistantTitle)),
      body: Padding(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.assistantEmpty),
            const SizedBox(height: defaultPadding),
            TextField(
              controller: _question,
              decoration: InputDecoration(hintText: l10n.assistantHint),
              minLines: 2,
              maxLines: 4,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: state.loading
                  ? null
                  : () {
                      unawaited(
                        ref
                            .read(assistantControllerProvider.notifier)
                            .ask(_question.text),
                      );
                    },
              child: Text(l10n.assistantSend),
            ),
            const SizedBox(height: defaultPadding),
            if (state.loading) const LinearProgressIndicator(),
            if (state.message != null)
              Text(
                state.message!,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
          ],
        ),
      ),
    );
  }
}
