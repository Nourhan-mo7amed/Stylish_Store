import 'package:stylish_store/core/networking/api_consumer.dart';
import 'package:stylish_store/core/networking/api_endpoints.dart';
import 'package:stylish_store/features/auth/data/models/register_request.dart';
import 'package:stylish_store/features/auth/data/models/register_response.dart';
import 'package:stylish_store/features/auth/data/models/login_request.dart';
import 'package:stylish_store/features/auth/data/models/login_response.dart';
import 'package:stylish_store/features/auth/data/models/forgot_password_request.dart';
import 'package:stylish_store/features/auth/data/models/forgot_password_response.dart';

class AuthApiClient {
  final ApiConsumer _apiConsumer;

  AuthApiClient({required ApiConsumer apiConsumer})
    : _apiConsumer = apiConsumer;

  /// Register a new user
  /// Throws [Failure] on network errors or API errors
  /// Returns [RegisterResponse] on success
  Future<RegisterResponse> register(RegisterRequest request) async {
    final response = await _apiConsumer.post(
      ApiEndpoints.register,
      body: request.toJson(),
    );
    return RegisterResponse.fromJson(response);
  }

  /// Login user with email and password
  /// Throws [Failure] on network errors or API errors
  /// Returns [LoginResponse] on success
  Future<LoginResponse> login(LoginRequest request) async {
    final response = await _apiConsumer.post(
      ApiEndpoints.login,
      body: request.toJson(),
    );
    return LoginResponse.fromJson(response);
  }

  /// Send password reset email
  /// Throws [Failure] on network errors or API errors
  /// Returns [ForgotPasswordResponse] on success
  Future<ForgotPasswordResponse> forgotPassword(
    ForgotPasswordRequest request,
  ) async {
    final response = await _apiConsumer.post(
      '/auth/send-recovery-email',
      body: request.toJson(),
    );
    return ForgotPasswordResponse.fromJson(response);
  }
}
