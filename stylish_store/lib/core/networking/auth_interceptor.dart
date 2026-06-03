import 'package:dio/dio.dart';
import 'package:stylish_store/core/networking/api_endpoints.dart';
import 'package:stylish_store/core/services/secure_storage_service.dart';

/// Interceptor to handle authentication - adds tokens and handles token refresh
class AuthInterceptor extends Interceptor {
  final SecureStorageService tokenStorage;
  final Dio dioInstance;

  // Endpoints that don't require authentication
  static const List<String> _publicEndpoints = [
    ApiEndpoints.login,
    ApiEndpoints.register,
  ];

  // Track if we're already refreshing to avoid multiple refresh calls
  bool _isRefreshing = false;
  late Future<bool> _refreshFuture;

  AuthInterceptor({required this.tokenStorage, required this.dioInstance});

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip adding token for public endpoints
    if (_isPublicEndpoint(options.path)) {
      return handler.next(options);
    }

    // Get and attach the access token
    final accessToken = await tokenStorage.getAccessToken();
    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    return handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Only handle 401 errors (Unauthorized)
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    // Skip refresh for public endpoints
    if (_isPublicEndpoint(err.requestOptions.path)) {
      return handler.next(err);
    }

    try {
      // If already refreshing, wait for the refresh to complete
      if (_isRefreshing) {
        final success = await _refreshFuture;
        if (success) {
          return _retry(err.requestOptions, handler);
        } else {
          return handler.next(err);
        }
      }

      // Start refreshing
      _isRefreshing = true;
      _refreshFuture = _refreshToken();

      final success = await _refreshFuture;

      if (success) {
        // Refresh successful, retry the original request
        return _retry(err.requestOptions, handler);
      } else {
        // Refresh failed, pass the error
        return handler.next(err);
      }
    } finally {
      _isRefreshing = false;
    }
  }

  /// Refresh the access token using the refresh token
  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await tokenStorage.getRefreshToken();

      if (refreshToken == null || refreshToken.isEmpty) {
        // No refresh token available, clear tokens and return false
        await tokenStorage.clearTokens();
        return false;
      }

      // Call refresh token endpoint
      // Using a fresh Dio instance without interceptors to avoid recursion
      final freshDio = Dio(
        BaseOptions(
          baseUrl: ApiEndpoints.baseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
        ),
      );

      final response = await freshDio.post(
        ApiEndpoints.refreshToken,
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200) {
        final newAccessToken =
            response.data['access_token'] ?? response.data['accessToken'];
        final newRefreshToken =
            response.data['refresh_token'] ?? response.data['refreshToken'];

        if (newAccessToken != null) {
          // Save the new tokens
          await tokenStorage.saveTokens(
            accessToken: newAccessToken,
            refreshToken: newRefreshToken ?? refreshToken,
          );
          return true;
        }
      }

      // Refresh failed, clear tokens
      await tokenStorage.clearTokens();
      return false;
    } catch (e) {
      // Error during refresh, clear tokens
      await tokenStorage.clearTokens();
      return false;
    }
  }

  /// Retry the original request with the new token
  Future<void> _retry(
    RequestOptions requestOptions,
    ErrorInterceptorHandler handler,
  ) async {
    try {
      final accessToken = await tokenStorage.getAccessToken();
      if (accessToken != null && accessToken.isNotEmpty) {
        requestOptions.headers['Authorization'] = 'Bearer $accessToken';
      }

      final response = await dioInstance.request<dynamic>(
        requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: Options(
          method: requestOptions.method,
          headers: requestOptions.headers,
        ),
      );

      return handler.resolve(response);
    } on DioException catch (e) {
      return handler.next(e);
    }
  }

  /// Check if endpoint is public (doesn't require authentication)
  bool _isPublicEndpoint(String path) {
    for (final endpoint in _publicEndpoints) {
      if (path.contains(endpoint)) {
        return true;
      }
    }
    return false;
  }
}
