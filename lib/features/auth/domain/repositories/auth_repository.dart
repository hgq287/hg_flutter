import 'package:hg_flutter/core/error/result.dart';
import 'package:hg_flutter/domain/session/session.dart';

abstract class AuthRepository {
  Future<Result<Session>> signIn({
    required String email,
    required String password,
  });
}
