import 'package:stylish_store/core/networking/api_consumer.dart';
import 'package:stylish_store/core/networking/dio_consumer.dart';
import 'package:stylish_store/core/services/secure_storage_service.dart';
import 'package:stylish_store/features/auth/data/networking/auth_api_client.dart';
import 'package:stylish_store/features/auth/data/repositories/auth_repository.dart';
import 'package:stylish_store/features/auth/logic/cubits/register_cubit.dart';
import 'package:stylish_store/features/auth/logic/cubits/login_cubit.dart';
import 'package:stylish_store/features/auth/logic/cubits/forgot_password_cubit.dart';

/// Service locator for auth dependencies
/// Provides instances of API client, repository, and cubit
class AuthServiceLocator {
  static final AuthServiceLocator _instance = AuthServiceLocator._internal();

  late final SecureStorageService _tokenStorage;
  late final ApiConsumer _apiConsumer;
  late final AuthApiClient _apiClient;
  late final AuthRepository _authRepository;
  late final RegisterCubit _registerCubit;
  late final LoginCubit _loginCubit;
  late final ForgotPasswordCubit _forgotPasswordCubit;

  AuthServiceLocator._internal();

  factory AuthServiceLocator() {
    return _instance;
  }

  /// Initialize all auth dependencies
  static void setup() {
    _instance._initialize();
  }

  void _initialize() {
    // Initialize Secure Token Storage
    _tokenStorage = SecureStorageService();

    // Initialize API Consumer with token storage for auth interceptor
    _apiConsumer = DioConsumer(tokenStorage: _tokenStorage);

    // Initialize API Client
    _apiClient = AuthApiClient(apiConsumer: _apiConsumer);

    // Initialize Repository
    _authRepository = AuthRepositoryImpl(
      apiClient: _apiClient,
      tokenStorage: _tokenStorage,
    );

    // Initialize Cubits
    _registerCubit = RegisterCubit(authRepository: _authRepository);
    _loginCubit = LoginCubit(authRepository: _authRepository);
    _forgotPasswordCubit = ForgotPasswordCubit(authRepository: _authRepository);
  }

  /// Get SecureTokenStorage instance
  SecureStorageService get tokenStorage {
    try {
      return _tokenStorage;
    } catch (e) {
      throw Exception(
        'AuthServiceLocator not initialized. Call AuthServiceLocator.setup() first.',
      );
    }
  }

  /// Get ApiConsumer instance
  ApiConsumer get apiConsumer {
    try {
      return _apiConsumer;
    } catch (e) {
      throw Exception(
        'AuthServiceLocator not initialized. Call AuthServiceLocator.setup() first.',
      );
    }
  }

  /// Get AuthApiClient instance
  AuthApiClient get apiClient {
    try {
      return _apiClient;
    } catch (e) {
      throw Exception(
        'AuthServiceLocator not initialized. Call AuthServiceLocator.setup() first.',
      );
    }
  }

  /// Get AuthRepository instance
  AuthRepository get authRepository {
    try {
      return _authRepository;
    } catch (e) {
      throw Exception(
        'AuthServiceLocator not initialized. Call AuthServiceLocator.setup() first.',
      );
    }
  }

  /// Get RegisterCubit instance
  RegisterCubit get registerCubit {
    try {
      return _registerCubit;
    } catch (e) {
      throw Exception(
        'AuthServiceLocator not initialized. Call AuthServiceLocator.setup() first.',
      );
    }
  }

  /// Get LoginCubit instance
  LoginCubit get loginCubit {
    try {
      return _loginCubit;
    } catch (e) {
      throw Exception(
        'AuthServiceLocator not initialized. Call AuthServiceLocator.setup() first.',
      );
    }
  }

  /// Get ForgotPasswordCubit instance
  ForgotPasswordCubit get forgotPasswordCubit {
    try {
      return _forgotPasswordCubit;
    } catch (e) {
      throw Exception(
        'AuthServiceLocator not initialized. Call AuthServiceLocator.setup() first.',
      );
    }
  }

  /// Dispose all resources
  void dispose() {
    _registerCubit.close();
    _loginCubit.close();
    _forgotPasswordCubit.close();
  }
}
