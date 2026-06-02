import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../utils/hive_config.dart';

class DioClient {
  final Dio _dio;

  DioClient() : _dio = Dio() {
    // 1. Add Auth Interceptor
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = HiveUser.getAuthToken();
        if (token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ));

    // 2. ADD THIS: Network Logger
    // This will print every request and response to your debug console
    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ));
    }
  }

  Future<Response> get(String url, {Map<String, dynamic>? queryParameters}) async {
    return await _dio.get(url, queryParameters: queryParameters);
  }

  Future<Response> post(String url, {dynamic data}) async {
    return await _dio.post(url, data: data);
  }
}

final dioClientProvider = Provider<DioClient>((ref) => DioClient());