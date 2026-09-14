import 'package:dio/dio.dart';
import 'package:hg_flutter/core/env/env.dart';

Dio createDio(Env env) {
  return Dio(
    BaseOptions(
      baseUrl: env.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 20),
      headers: const {Headers.acceptHeader: 'application/json'},
    ),
  );
}
