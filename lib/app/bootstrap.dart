import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hg_flutter/app/app.dart';
import 'package:hg_flutter/app/di/providers.dart';
import 'package:hg_flutter/core/env/env.dart';
import 'package:hg_flutter/core/env/env_file.dart';
import 'package:hg_flutter/data/native/in_memory_secure_store.dart';
import 'package:hg_flutter/data/native/plugin_secure_store.dart';
import 'package:hg_flutter/data/session/in_memory_session_port.dart';
import 'package:hg_flutter/data/session/session_restore.dart';
import 'package:hg_flutter/domain/secure_store/secure_store.dart';
import 'package:hg_native/hg_native.dart';

Future<Env> resolveEnv() async {
  var env = Env.fromDefines();
  final local = await readLocalEnvFile();
  if (local != null) {
    env = env.overlay(Env.parseDotEnv(local));
  }
  return env;
}

SecureStore createSecureStore() {
  if (HgNative.isPlatformSupported) {
    return PluginSecureStore();
  }
  return InMemorySecureStore();
}

Future<void> bootstrap({Env? env}) async {
  WidgetsFlutterBinding.ensureInitialized();
  final resolved = env ?? await resolveEnv();
  final store = createSecureStore();
  final session = InMemorySessionPort();
  await SessionRestore(secureStore: store, session: session).call();

  runApp(
    ProviderScope(
      overrides: [
        envProvider.overrideWith((ref) => resolved),
        secureStoreProvider.overrideWith((ref) => store),
        sessionPortProvider.overrideWith((ref) => session),
      ],
      child: const HgApp(),
    ),
  );
}
