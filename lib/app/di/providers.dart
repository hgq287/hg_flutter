import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hg_flutter/core/env/env.dart';
import 'package:hg_flutter/data/intelligence/fake_on_device_ai.dart';
import 'package:hg_flutter/data/intelligence/in_memory_retriever.dart';
import 'package:hg_flutter/data/intelligence/safety_gateway_impl.dart';
import 'package:hg_flutter/data/intelligence/stub_ledger.dart';
import 'package:hg_flutter/data/native/in_memory_secure_store.dart';
import 'package:hg_flutter/data/native/plugin_on_device_ai.dart';
import 'package:hg_flutter/data/native/plugin_secure_store.dart';
import 'package:hg_flutter/data/network/dio_client.dart';
import 'package:hg_flutter/data/session/in_memory_session_port.dart';
import 'package:hg_flutter/domain/intelligence/on_device_ai.dart';
import 'package:hg_flutter/domain/intelligence/retriever.dart';
import 'package:hg_flutter/domain/intelligence/safety_gateway.dart';
import 'package:hg_flutter/domain/ledger/ledger_port.dart';
import 'package:hg_flutter/domain/secure_store/secure_store.dart';
import 'package:hg_flutter/domain/session/session_port.dart';
import 'package:hg_flutter/features/assistant/domain/usecases/ask_grounded.dart';
import 'package:hg_flutter/features/auth/data/auth_api.dart';
import 'package:hg_flutter/features/auth/data/auth_repository_impl.dart';
import 'package:hg_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:hg_flutter/features/auth/domain/usecases/sign_in.dart';
import 'package:hg_flutter/features/auth/domain/usecases/sign_out.dart';
import 'package:hg_native/hg_native.dart';

final envProvider = Provider<Env>((ref) {
  throw UnimplementedError('Override envProvider in bootstrap');
});

final sessionPortProvider = Provider<SessionPort>((ref) {
  return InMemorySessionPort();
});

final secureStoreProvider = Provider<SecureStore>((ref) {
  if (!kIsWeb && HgNative.isPlatformSupported) {
    return PluginSecureStore();
  }
  return InMemorySecureStore();
});

final onDeviceAiProvider = Provider<OnDeviceAi>((ref) {
  if (!kIsWeb && HgNative.isPlatformSupported) {
    return PluginOnDeviceAi();
  }
  return const FakeOnDeviceAi();
});

final safetyGatewayProvider = Provider<SafetyGateway>((ref) {
  return const SafetyGatewayImpl();
});

final retrieverProvider = Provider<Retriever>((ref) {
  return InMemoryRetriever();
});

final ledgerPortProvider = Provider<LedgerPort>((ref) {
  return const StubLedger();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final env = ref.watch(envProvider);
  if (env.demoAuth) {
    return const DemoAuthRepository();
  }
  return AuthRepositoryImpl(AuthApi(dio: createDio(env), env: env));
});

final signInUseCaseProvider = Provider<SignIn>((ref) {
  return SignIn(
    authRepository: ref.watch(authRepositoryProvider),
    secureStore: ref.watch(secureStoreProvider),
    session: ref.watch(sessionPortProvider),
  );
});

final signOutUseCaseProvider = Provider<SignOut>((ref) {
  return SignOut(
    secureStore: ref.watch(secureStoreProvider),
    session: ref.watch(sessionPortProvider),
  );
});

final askGroundedProvider = Provider<AskGrounded>((ref) {
  return AskGrounded(
    safety: ref.watch(safetyGatewayProvider),
    retriever: ref.watch(retrieverProvider),
    onDeviceAi: ref.watch(onDeviceAiProvider),
    ledger: ref.watch(ledgerPortProvider),
  );
});
