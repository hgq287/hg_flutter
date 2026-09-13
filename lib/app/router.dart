import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:hg_flutter/domain/session/session_port.dart';
import 'package:hg_flutter/features/assistant/presentation/assistant_page.dart';
import 'package:hg_flutter/features/auth/presentation/auth_page.dart';
import 'package:hg_flutter/features/home/presentation/home_page.dart';

class SessionListenable extends ChangeNotifier {
  SessionListenable(this._session) {
    _subscription = _session.watch().listen((_) => notifyListeners());
  }

  final SessionPort _session;
  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    unawaited(_subscription.cancel());
    super.dispose();
  }
}

GoRouter createRouter({
  required SessionPort session,
  required SessionListenable refresh,
}) {
  return GoRouter(
    initialLocation: '/auth',
    refreshListenable: refresh,
    redirect: (context, state) {
      final loggedIn = session.current() != null;
      final atAuth = state.matchedLocation == '/auth';
      if (!loggedIn && !atAuth) {
        return '/auth';
      }
      if (loggedIn && atAuth) {
        return '/home';
      }
      return null;
    },
    routes: [
      GoRoute(path: '/auth', builder: (context, state) => const AuthPage()),
      GoRoute(path: '/home', builder: (context, state) => const HomePage()),
      GoRoute(
        path: '/assistant',
        builder: (context, state) => const AssistantPage(),
      ),
    ],
  );
}
