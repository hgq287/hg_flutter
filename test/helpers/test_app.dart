import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hg_flutter/app/app.dart';
import 'package:hg_flutter/app/di/providers.dart';
import 'package:hg_flutter/core/env/env.dart';
import 'package:hg_flutter/data/native/in_memory_secure_store.dart';
import 'package:hg_flutter/data/session/in_memory_session_port.dart';
import 'package:hg_flutter/domain/session/session.dart';
import 'package:hg_flutter/domain/session/session_port.dart';

Widget testApp({SessionPort? session, Session? initialSession}) {
  final port = session ?? InMemorySessionPort(initial: initialSession);
  return ProviderScope(
    overrides: [
      envProvider.overrideWith((ref) => Env.fromDefines()),
      sessionPortProvider.overrideWith((ref) => port),
      secureStoreProvider.overrideWith((ref) => InMemorySecureStore()),
    ],
    child: const HgApp(),
  );
}
