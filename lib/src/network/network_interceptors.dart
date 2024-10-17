import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class LogNetworkCalls extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('Request [${options.method}] -> Path name: ${options.path}');
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(
      Response<dynamic> response, ResponseInterceptorHandler handler) {
    debugPrint(
        'Response [${response.statusCode}] -> Path name: ${response.requestOptions.path}');
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint(
        'Error [${err.response?.statusCode}] -> Path name: ${err.requestOptions.path}');
    return super.onError(err, handler);
  }
}
