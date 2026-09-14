import 'package:hg_flutter/core/error/app_error.dart';
import 'package:hg_flutter/core/error/result.dart';
import 'package:hg_flutter/domain/session/session.dart';
import 'package:hg_flutter/features/auth/data/auth_api.dart';
import 'package:hg_flutter/features/auth/domain/repositories/auth_repository.dart';

final class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._api);

  final AuthApi _api;

  @override
  Future<Result<Session>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final tokens = await _api.signIn(email: email, password: password);
      return Result.ok(tokens.toSession(email));
    } on AppError catch (error) {
      return Result.err(error);
    } catch (error) {
      return Result.err(UnexpectedError(error.toString()));
    }
  }
}

/// Dev-only adapter so the golden path runs without a backend.
final class DemoAuthRepository implements AuthRepository {
  const DemoAuthRepository();

  @override
  Future<Result<Session>> signIn({
    required String email,
    required String password,
  }) async {
    return Result.ok(
      Session(
        userId: email,
        email: email,
        accessToken: 'demo-access-token',
        refreshToken: 'demo-refresh-token',
      ),
    );
  }
}
