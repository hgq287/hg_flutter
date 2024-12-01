import 'package:flutter_dotenv/flutter_dotenv.dart';

enum EnvType {
  dev,
  prod,
}

/// Environment declare here
class Env {
  Env._({required this.envType, required this.host, required this.apiBaseUrl});

  /// Dev mode
  factory Env.dev() {
    return Env._(
      envType: EnvType.dev,
      host: dotenv.env['HOST'] ?? 'https://localhost:4096/v1',
      apiBaseUrl: dotenv.env['API_BASE_URL'] ?? 'https://localhost:4096/v1',
    );
  }

  final EnvType envType;
  final String host;
  final String apiBaseUrl;
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
