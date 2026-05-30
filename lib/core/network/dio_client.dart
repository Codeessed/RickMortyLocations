import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../constants/app_constants.dart';
import 'api_interceptor.dart';

part 'dio_client.g.dart';

/// Creates and configures the singleton [Dio] instance.
///
/// Includes sensible timeouts and the [ApiInterceptor] for logging
/// and error mapping. Injected via Riverpod throughout the app.
abstract final class DioClient {
  static Dio create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
        sendTimeout: const Duration(seconds: 60),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(ApiInterceptor());

    return dio;
  }
}

/// Riverpod provider that exposes the configured [Dio] instance.
@Riverpod(keepAlive: true)
Dio dio(Ref ref) => DioClient.create();
