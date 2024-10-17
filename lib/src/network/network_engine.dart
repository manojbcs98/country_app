import 'package:country_app/barrel.dart';
import 'package:dio/dio.dart';

class NetworkEngine {
  static final NetworkEngine _instance = NetworkEngine._internal();

  NetworkEngine._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: kBaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      responseType: ResponseType.json,
    ))
      ..interceptors.addAll([LogNetworkCalls()]);
  }

  factory NetworkEngine() => _instance;

  late final Dio _dio;

  Dio getDio() => _dio;
}
