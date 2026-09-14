import 'package:dio/dio.dart';
import 'package:hg_flutter/core/env/env.dart';
import 'package:hg_flutter/core/error/app_error.dart';
import 'package:hg_flutter/domain/session/session.dart';

final class AuthTokens {
  const AuthTokens({required this.accessToken, this.refreshToken, this.userId});

  final String accessToken;
  final String? refreshToken;
  final String? userId;

  factory AuthTokens.fromJson(dynamic data) {
    if (data is! Map) {
      throw const AuthError('Unexpected sign-in payload');
    }
    final access =
        data['access_token']?.toString() ?? data['accessToken']?.toString();
    if (access == null || access.isEmpty) {
      throw const AuthError('Sign-in response missing access token');
    }
    return AuthTokens(
      accessToken: access,
      refreshToken:
          data['refresh_token']?.toString() ?? data['refreshToken']?.toString(),
      userId: data['user_id']?.toString() ?? data['userId']?.toString(),
    );
  }

  Session toSession(String email) {
    return Session(
      userId: userId ?? email,
      email: email,
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }
}

final class AuthApi {
  AuthApi({required this.dio, required this.env});

  final Dio dio;
  final Env env;

  Future<AuthTokens> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dio.post<dynamic>(
        '/${env.apiSignIn}',
        data: <String, String>{
          'username': email,
          'password': password,
          'grant_type': 'password',
          if (env.clientId.isNotEmpty) 'client_id': env.clientId,
        },
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      return AuthTokens.fromJson(response.data);
    } on DioException catch (error) {
      final status = error.response?.statusCode;
      if (status == 401 || status == 403) {
        throw const AuthError('Invalid credentials');
      }
      throw NetworkError(error.message ?? 'Network error', statusCode: status);
    }
  }
}
