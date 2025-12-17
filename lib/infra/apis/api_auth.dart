import 'dart:convert';
import 'package:dio/dio.dart';

import 'package:hg_flutter/app/app_config.dart';
import 'package:hg_flutter/infra/apis/api_base.dart';

class ApiAuth extends ApiBase {
  ApiAuth(Dio dio) : super(dio: dio);

  Future<Response<T>> signIn<T>(String email, String password) async {
    final Options options = await getOptions(contentType: Headers.formUrlEncodedContentType);
    final formUrlEncodedData =
        'username=$email&password=$password&grant_type=password&client_id=${AppConfig.I.env.clientId}&client_secret=${AppConfig.I.env.clientSecret}';

    final String endpoint = '/${AppConfig.I.env.apiSignIn}';
    return await wrapE(() => dio.post(endpoint, data: formUrlEncodedData, options: options));
  }

  Future<Response<T>> signUp<T>(String email, String password) async {
    final Options options = await getOptions();
    final data = jsonEncode({'email': email, 'password': password});
    final String endpoint = '/${AppConfig.I.env.apiSignUp}';
    return await wrapE(() => dio.post(endpoint, data: data, options: options));
  }
}
