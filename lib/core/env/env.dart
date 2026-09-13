enum Flavor { dev, staging, prod }

/// Immutable runtime config. Built from `--dart-define` plus optional overlays.
final class Env {
  const Env({
    required this.flavor,
    required this.host,
    required this.apiVersion,
    required this.apiBaseUrl,
    required this.apiSignIn,
    required this.apiSignUp,
    required this.clientId,
    required this.demoAuth,
  });

  final Flavor flavor;
  final String host;
  final String apiVersion;
  final String apiBaseUrl;
  final String apiSignIn;
  final String apiSignUp;
  final String clientId;
  final bool demoAuth;

  factory Env.fromDefines() {
    const flavorName = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
    const host = String.fromEnvironment(
      'API_HOST',
      defaultValue: 'http://localhost:4096',
    );
    const apiVersion = String.fromEnvironment(
      'API_VERSION',
      defaultValue: 'v1',
    );
    const apiSignIn = String.fromEnvironment(
      'API_SIGNIN',
      defaultValue: 'signin',
    );
    const apiSignUp = String.fromEnvironment(
      'API_SIGNUP',
      defaultValue: 'signup',
    );
    const clientId = String.fromEnvironment('OAUTH2_CLIENT_ID');
    const demoAuthDefine = String.fromEnvironment('DEMO_AUTH');

    final flavor = Flavor.values.firstWhere(
      (value) => value.name == flavorName,
      orElse: () => Flavor.dev,
    );

    return Env(
      flavor: flavor,
      host: host,
      apiVersion: apiVersion,
      apiBaseUrl: '$host/$apiVersion',
      apiSignIn: apiSignIn,
      apiSignUp: apiSignUp,
      clientId: clientId,
      demoAuth: demoAuthDefine.isEmpty
          ? flavor == Flavor.dev
          : demoAuthDefine.toLowerCase() == 'true',
    );
  }

  Env overlay(Map<String, String> values) {
    final flavorName = values['FLAVOR'] ?? flavor.name;
    final nextHost = values['API_HOST'] ?? host;
    final nextVersion = values['API_VERSION'] ?? apiVersion;
    return Env(
      flavor: Flavor.values.firstWhere(
        (value) => value.name == flavorName,
        orElse: () => flavor,
      ),
      host: nextHost,
      apiVersion: nextVersion,
      apiBaseUrl: '$nextHost/$nextVersion',
      apiSignIn: values['API_SIGNIN'] ?? apiSignIn,
      apiSignUp: values['API_SIGNUP'] ?? apiSignUp,
      clientId: values['OAUTH2_CLIENT_ID'] ?? clientId,
      demoAuth: values.containsKey('DEMO_AUTH')
          ? values['DEMO_AUTH']!.toLowerCase() == 'true'
          : demoAuth,
    );
  }

  static Map<String, String> parseDotEnv(String source) {
    final out = <String, String>{};
    for (final raw in source.split(RegExp(r'\r?\n'))) {
      final line = raw.trim();
      if (line.isEmpty || line.startsWith('#')) {
        continue;
      }
      final index = line.indexOf('=');
      if (index <= 0) {
        continue;
      }
      final key = line.substring(0, index).trim();
      var value = line.substring(index + 1).trim();
      if ((value.startsWith("'") && value.endsWith("'")) ||
          (value.startsWith('"') && value.endsWith('"'))) {
        value = value.substring(1, value.length - 1);
      }
      out[key] = value;
    }
    return out;
  }
}
