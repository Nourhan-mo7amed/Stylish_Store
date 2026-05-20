import 'dart:io';

import 'package:dio/dio.dart';
import 'package:stylish_store/core/failures/failure.dart';
import 'package:stylish_store/core/networking/api_consumer.dart';
import 'package:stylish_store/core/networking/api_endpoints.dart';

class DioConsumer implements ApiConsumer {
  final Dio _dio;

  DioConsumer({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: ApiEndpoints.baseUrl,
              connectTimeout: const Duration(seconds: 30),
              receiveTimeout: const Duration(seconds: 30),
              sendTimeout: const Duration(seconds: 30),
            ),
          );

  @override
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return response.data;
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

  @override
  Future<dynamic> post(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: body,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

  @override
  Future<dynamic> put(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: body,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

  @override
  Future<dynamic> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (e) {
      _handleDioException(e);
    }
  }

  /// Handle DioException and throw appropriate Failure
  void _handleDioException(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
        throw NetworkFailure(
          message: 'Connection timeout. Please check your internet connection.',
        );
      case DioExceptionType.sendTimeout:
        throw NetworkFailure(message: 'Request timeout. Please try again.');
      case DioExceptionType.receiveTimeout:
        throw NetworkFailure(message: 'Response timeout. Please try again.');
      case DioExceptionType.badResponse:
        _handleServerException(exception);
        break;
      case DioExceptionType.badCertificate:
        throw NetworkFailure(
          message: 'Security certificate error. Please try again later.',
        );
      case DioExceptionType.connectionError:
        throw NetworkFailure(
          message: 'No internet connection. Please check your connection.',
        );
      case DioExceptionType.unknown:
        if (exception.error is SocketException) {
          throw NetworkFailure(
            message: 'Network error. Please check your internet connection.',
          );
        }
        throw UnknownFailure(
          message: exception.message ?? 'An unexpected error occurred',
        );
      case DioExceptionType.cancel:
        throw UnknownFailure(message: 'Request was cancelled');
    }
  }

  /// Handle server error responses
  void _handleServerException(DioException exception) {
    final statusCode = exception.response?.statusCode;
    final responseData = exception.response?.data;

    String message = 'Server error occurred';

    if (responseData is Map<String, dynamic>) {
      message = responseData['message'] ?? responseData['error'] ?? message;
    }

    switch (statusCode) {
      case 400:
        throw ValidationFailure(
          message: message.isNotEmpty
              ? message
              : 'Invalid input. Please check your details.',
        );
      case 401:
        throw ServerFailure(
          message: 'Unauthorized. Please try again.',
          statusCode: statusCode,
        );
      case 409:
        throw ValidationFailure(
          message: 'Email already exists. Please use a different email.',
        );
      case 500:
        throw ServerFailure(
          message: 'Server error. Please try again later.',
          statusCode: statusCode,
        );
      case 503:
        throw ServerFailure(
          message: 'Service temporarily unavailable. Please try again later.',
          statusCode: statusCode,
        );
      default:
        throw ServerFailure(
          message: message.isNotEmpty
              ? message
              : 'An error occurred. Please try again.',
          statusCode: statusCode,
        );
    }
  }
}
