import 'package:stylish_store/core/failures/failure.dart';
import 'package:stylish_store/core/failures/result.dart';
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
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiClient _apiClient;

  AuthRepositoryImpl({required AuthApiClient apiClient})
    : _apiClient = apiClient;

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
}
