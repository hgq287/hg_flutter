import 'package:flutter_test/flutter_test.dart';
import 'package:hg_flutter/core/error/app_error.dart';
import 'package:hg_flutter/core/error/result.dart';
import 'package:hg_flutter/data/native/in_memory_secure_store.dart';
import 'package:hg_flutter/data/session/in_memory_session_port.dart';
import 'package:hg_flutter/domain/secure_store/secure_store.dart';
import 'package:hg_flutter/domain/session/session.dart';
import 'package:hg_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:hg_flutter/features/auth/domain/usecases/sign_in.dart';

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository(this._result);
  final Result<Session> _result;

  @override
  Future<Result<Session>> signIn({
    required String email,
    required String password,
  }) async => _result;
}

void main() {
  late InMemorySecureStore store;
  late InMemorySessionPort session;

  setUp(() {
    store = InMemorySecureStore();
    session = InMemorySessionPort();
  });

  test('rejects empty credentials', () async {
    final useCase = SignIn(
      authRepository: _FakeAuthRepository(
        Result.ok(const Session(userId: '1', email: 'a@b.c', accessToken: 't')),
      ),
      secureStore: store,
      session: session,
    );

    final result = await useCase.call(email: '  ', password: '');
    expect(result.isError, isTrue);
    expect(result.error, isA<ValidationError>());
    expect(session.current(), isNull);
  });

  test('persists tokens and publishes session', () async {
    final useCase = SignIn(
      authRepository: _FakeAuthRepository(
        Result.ok(
          const Session(
            userId: 'u1',
            email: 'ada@example.com',
            accessToken: 'access',
            refreshToken: 'refresh',
          ),
        ),
      ),
      secureStore: store,
      session: session,
    );

    final result = await useCase.call(
      email: ' ada@example.com ',
      password: 'secret',
    );

    expect(result.isSuccess, isTrue);
    expect(session.current()?.email, 'ada@example.com');
    expect(await store.read(kSessionAccessTokenKey), 'access');
    expect(await store.read(kSessionRefreshTokenKey), 'refresh');
  });

  test('does not persist when repository fails', () async {
    final useCase = SignIn(
      authRepository: _FakeAuthRepository(Result.err(const AuthError('nope'))),
      secureStore: store,
      session: session,
    );

    final result = await useCase.call(
      email: 'ada@example.com',
      password: 'secret',
    );
    expect(result.isError, isTrue);
    expect(session.current(), isNull);
    expect(await store.read(kSessionAccessTokenKey), isNull);
  });
}
