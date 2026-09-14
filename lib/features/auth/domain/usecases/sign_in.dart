import 'package:hg_flutter/core/error/app_error.dart';
import 'package:hg_flutter/core/error/result.dart';
import 'package:hg_flutter/domain/secure_store/secure_store.dart';
import 'package:hg_flutter/domain/session/session.dart';
import 'package:hg_flutter/domain/session/session_port.dart';
import 'package:hg_flutter/features/auth/domain/repositories/auth_repository.dart';

final class SignIn {
  const SignIn({
    required AuthRepository authRepository,
    required SecureStore secureStore,
    required SessionPort session,
  }) : _authRepository = authRepository,
       _secureStore = secureStore,
       _session = session;

  final AuthRepository _authRepository;
  final SecureStore _secureStore;
  final SessionPort _session;

  Future<Result<Session>> call({
    required String email,
    required String password,
  }) async {
    final trimmedEmail = email.trim();
    if (trimmedEmail.isEmpty || password.isEmpty) {
      return Result.err(
        const ValidationError('Email and password are required'),
      );
    }

    final result = await _authRepository.signIn(
      email: trimmedEmail,
      password: password,
    );
    if (result.isError) {
      return result;
    }

    final session = result.value;
    await _secureStore.write(kSessionUserIdKey, session.userId);
    await _secureStore.write(kSessionEmailKey, session.email);
    await _secureStore.write(kSessionAccessTokenKey, session.accessToken);
    if (session.refreshToken != null) {
      await _secureStore.write(kSessionRefreshTokenKey, session.refreshToken!);
    }
    await _session.set(session);
    return Result.ok(session);
  }
}
