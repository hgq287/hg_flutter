import 'dart:io';

Future<String?> readLocalEnvFile({String path = '.env.local'}) async {
  final file = File(path);
  if (!file.existsSync()) {
    return null;
  }
  return file.readAsString();
}
