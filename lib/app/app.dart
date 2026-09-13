import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hg_flutter/app/di/providers.dart';
import 'package:hg_flutter/app/router.dart';
import 'package:hg_flutter/app/theme.dart';
import 'package:hg_flutter/generated/app_localizations.dart';

class HgApp extends ConsumerStatefulWidget {
  const HgApp({super.key});

  @override
  ConsumerState<HgApp> createState() => _HgAppState();
}

class _HgAppState extends ConsumerState<HgApp> {
  late final SessionListenable _refresh;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    final session = ref.read(sessionPortProvider);
    _refresh = SessionListenable(session);
    _router = createRouter(session: session, refresh: _refresh);
  }

  @override
  void dispose() {
    _refresh.dispose();
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Hg Flutter',
      theme: buildAppTheme(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: _router,
    );
  }
}
