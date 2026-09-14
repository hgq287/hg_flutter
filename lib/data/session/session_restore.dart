import 'package:hg_flutter/domain/secure_store/secure_store.dart';
import 'package:hg_flutter/domain/session/session.dart';
import 'package:hg_flutter/domain/session/session_port.dart';

final class SessionRestore {
  const SessionRestore({
    required SecureStore secureStore,
    required SessionPort session,
  }) : _secureStore = secureStore,
       _session = session;

  final SecureStore _secureStore;
  final SessionPort _session;

  Future<void> call() async {
    final email = await _secureStore.read(kSessionEmailKey);
    final userId = await _secureStore.read(kSessionUserIdKey);
    final accessToken = await _secureStore.read(kSessionAccessTokenKey);
    if (email == null || userId == null || accessToken == null) {
      return;
    }
    final refreshToken = await _secureStore.read(kSessionRefreshTokenKey);
    await _session.set(
      Session(
        userId: userId,
        email: email,
        accessToken: accessToken,
        refreshToken: refreshToken,
      ),
    );
  }
}
