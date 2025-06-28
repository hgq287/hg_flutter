import 'package:hg_flutter/app/app.dart';
import 'package:hg_flutter/app/app_config.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  /// Init configs

  await dotenv.load(fileName: '.env.local');
  AppConfig(env: Env.dev());

  /// Launch app

  await bootstrap();
}
