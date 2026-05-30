import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../errors/app_exception.dart';

/// Intercepts all Dio requests to:
/// 1. Log request/response in debug mode.
/// 2. Map [DioException] to typed [AppException] subclasses.
class ApiInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('➡️  ${options.method} ${options.uri}');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('✅  ${response.statusCode} ${response.requestOptions.uri}');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('❌  ${err.type} ${err.requestOptions.uri}: ${err.message}');
    }

    final appException = _mapDioException(err);

    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: appException,
      ),
    );
  }

  /// Converts a [DioException] into a typed [AppException].
  AppException _mapDioException(DioException err) {
    final statusCode = err.response?.statusCode;

    // 404 → NotFoundException
    if (statusCode == 404) {
      return const NotFoundException();
    }

    // Connection-level failures
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout) {
      return const NetworkException(
        message: 'Connection timed out. Please check your internet.',
      );
    }

    if (err.type == DioExceptionType.connectionError) {
      return const NetworkException(
        message: 'No internet connection.',
      );
    }

    // Server / unknown errors
    return NetworkException(
      message: err.message ?? 'An unexpected network error occurred.',
      statusCode: statusCode,
    );
  }
}
