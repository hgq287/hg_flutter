import 'package:flutter_dotenv/flutter_dotenv.dart';

enum EnvType { dev, prod }

/// Environment declare here
class Env {
  Env._({
    required this.envType,
    required this.clientId,
    required this.clientSecret,

    required this.host,
    required this.apiVersion,
    required this.apiBaseUrl,
    required this.apiSignIn,
    required this.apiSignUp,
  });

  /// Dev mode
  factory Env.dev() {
    return Env._(
      envType: EnvType.dev,

      /// Oath2
      clientId: dotenv.env['OAUTH2_CLIENT_ID'] ?? '',
      clientSecret: dotenv.env['OAUTH2_CLIENT_SECRET'] ?? '',

      /// Base access info
      host: dotenv.env['HOST'] ?? 'http://localhost:4106',
      apiVersion: dotenv.env['API_VERSION'] ?? 'v1',
      apiBaseUrl: dotenv.env['API_BASE_URL'] ?? 'http://localhost:4106/v1',

      apiSignIn: dotenv.env['API_SIGNIN'] ?? 'signin',
      apiSignUp: dotenv.env['API_SIGNUP'] ?? 'signup',
    );
  }

  final EnvType envType;
  final String clientId;
  final String clientSecret;

  final String host;
  final String apiVersion;
  final String apiBaseUrl;

  final String apiSignIn;
  final String apiSignUp;
}

/// Config env
class AppConfig {
  factory AppConfig({required Env env}) {
    I.env = env;
    return I;
  }

  AppConfig._private();

  static final AppConfig I = AppConfig._private();

  Env env = Env.dev();
}
