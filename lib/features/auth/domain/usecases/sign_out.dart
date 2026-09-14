import 'package:hg_flutter/domain/secure_store/secure_store.dart';
import 'package:hg_flutter/domain/session/session_port.dart';

final class SignOut {
  const SignOut({
    required SecureStore secureStore,
    required SessionPort session,
  }) : _secureStore = secureStore,
       _session = session;

  final SecureStore _secureStore;
  final SessionPort _session;

  Future<void> call() async {
    await _secureStore.delete(kSessionUserIdKey);
    await _secureStore.delete(kSessionEmailKey);
    await _secureStore.delete(kSessionAccessTokenKey);
    await _secureStore.delete(kSessionRefreshTokenKey);
    await _session.clear();
  }
}
