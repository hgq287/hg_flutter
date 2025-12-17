import 'dart:async';
import 'package:hg_flutter/app/app_config.dart';
import 'package:dio/dio.dart';

import 'package:hg_flutter/utils/app_logger.dart';

class Token {
  Token({required this.tokenType, required this.expiresIn, required this.accessToken, required this.refreshToken});

  final String tokenType;
  final int expiresIn;
  final String accessToken;
  final String refreshToken;
}

class ApiBase {
  ApiBase({required this.dio}) {
    final String baseUrl = AppConfig.I.env.apiBaseUrl;
    dio.options.baseUrl = baseUrl;
  }

  final Dio dio;
  Token? token;

  /// Get request header options
  Future<Options> getOptions({String? contentType = Headers.jsonContentType}) async {
    final Map<String, String> header = <String, String>{Headers.acceptHeader: '*/*'};
    return Options(headers: header, contentType: contentType);
  }

  /// Get auth header options
  Future<Options> getAuthOptions({String? contentType}) async {
    final Options options = await getOptions(contentType: contentType);

    if (token != null) {
      options.headers?.addAll(<String, String>{'Authorization': 'Bearer ${token?.accessToken}'});
    }

    return options;
  }

  /// Wrap Dio Exception
  Future<Response<T>> wrapE<T>(Future<Response<T>> Function() dioApi) async {
    try {
      return await dioApi();
    } catch (error) {
      if (error is DioException && error.type == DioExceptionType.badResponse) {
        final Response<dynamic>? response = error.response;

        try {
          /// By pass dio header error code to get response content
          /// Try to return response
          if (response != null) {
            final Response<T> res = Response<T>(
              data: response.data as T,
              headers: response.headers,
              requestOptions: response.requestOptions,
              isRedirect: response.isRedirect,
              statusCode: response.statusCode,
              statusMessage: response.statusMessage,
              redirects: response.redirects,
              extra: response.extra,
            );
            return res;
          }
        } catch (e) {
          logger.e('Parse error: $e');
        }

        final String errorMessage =
            'Code ${response?.statusCode} - ${response?.statusMessage} ${response?.data != null ? '\n' : ''} ${response?.data}';
        throw DioException(
          requestOptions: error.requestOptions,
          response: error.response,
          type: error.type,
          error: errorMessage,
        );
      }
      rethrow;
    }
  }
}
