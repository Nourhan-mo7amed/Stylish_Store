import 'package:stylish_store/core/failures/failure.dart';
import 'package:stylish_store/core/failures/result.dart';
import 'package:stylish_store/core/services/secure_storage_service.dart';
import 'package:stylish_store/features/auth/data/models/register_request.dart';
import 'package:stylish_store/features/auth/data/models/register_response.dart';
import 'package:stylish_store/features/auth/data/models/login_request.dart';
import 'package:stylish_store/features/auth/data/models/login_response.dart';
import 'package:stylish_store/features/auth/data/models/forgot_password_request.dart';
import 'package:stylish_store/features/auth/data/models/forgot_password_response.dart';
import 'package:stylish_store/features/auth/data/networking/auth_api_client.dart';

abstract class AuthRepository {
  Future<Result<RegisterResponse>> register(RegisterRequest request);
  Future<Result<LoginResponse>> login(LoginRequest request);
  Future<Result<ForgotPasswordResponse>> forgotPassword(
    ForgotPasswordRequest request,
  );
  Future<Result<void>> logout();
  Future<Result<bool>> isUserLoggedIn();
  Future<Result<String?>> getAccessToken();
  Future<void> clearAllTokens();
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiClient _apiClient;
  final SecureStorageService _tokenStorage;

  AuthRepositoryImpl({
    required AuthApiClient apiClient,
    required SecureStorageService tokenStorage,
  }) : _apiClient = apiClient,
       _tokenStorage = tokenStorage;

  @override
  Future<Result<RegisterResponse>> register(RegisterRequest request) async {
    try {
      final response = await _apiClient.register(request);
      return Success(data: response);
    } on Failure catch (e) {
      return Error(failure: e);
    } catch (e) {
      return Error(
        failure: UnknownFailure(message: 'An unexpected error occurred'),
      );
    }
  }

  @override
  Future<Result<LoginResponse>> login(LoginRequest request) async {
    try {
      final response = await _apiClient.login(request);

      // Store tokens securely after successful login
      if (response.accessToken != null) {
        await _tokenStorage.saveTokens(
          accessToken: response.accessToken!,
          refreshToken: response.refreshToken ?? '',
        );
      }

      return Success(data: response);
    } on Failure catch (e) {
      return Error(failure: e);
    } catch (e) {
      return Error(
        failure: UnknownFailure(message: 'An unexpected error occurred'),
      );
    }
  }

  @override
  Future<Result<ForgotPasswordResponse>> forgotPassword(
    ForgotPasswordRequest request,
  ) async {
    try {
      final response = await _apiClient.forgotPassword(request);
      return Success(data: response);
    } on Failure catch (e) {
      return Error(failure: e);
    } catch (e) {
      return Error(
        failure: UnknownFailure(message: 'An unexpected error occurred'),
      );
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      // Call logout endpoint
      await _apiClient.logout();

      // Clear tokens from secure storage
      await _tokenStorage.clearTokens();

      return Success(data: null);
    } on Failure catch (e) {
      // Even if logout API fails, clear tokens locally
      await _tokenStorage.clearTokens();
      return Error(failure: e);
    } catch (e) {
      // Even if logout API fails, clear tokens locally
      await _tokenStorage.clearTokens();
      return Error(
        failure: UnknownFailure(message: 'An unexpected error occurred'),
      );
    }
  }

  @override
  Future<Result<bool>> isUserLoggedIn() async {
    try {
      final hasTokens = await _tokenStorage.hasTokens();
      return Success(data: hasTokens);
    } catch (e) {
      return Error(
        failure: UnknownFailure(message: 'Failed to check login status'),
      );
    }
  }

  @override
  Future<Result<String?>> getAccessToken() async {
    try {
      final token = await _tokenStorage.getAccessToken();
      return Success(data: token);
    } catch (e) {
      return Error(
        failure: UnknownFailure(message: 'Failed to retrieve access token'),
      );
    }
  }

  @override
  Future<void> clearAllTokens() async {
    await _tokenStorage.clearTokens();
  }
}
