import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylish_store/core/failures/failure.dart';
import 'package:stylish_store/core/failures/result.dart';
import 'package:stylish_store/features/auth/data/models/login_request.dart';
import 'package:stylish_store/features/auth/data/repositories/auth_repository.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository;

  LoginCubit({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const LoginInitial());

  /// Safely emit state only if the cubit is not closed
  /// Prevents "Cannot emit new states after calling close" error
  void _safeEmit(LoginState state) {
    if (!isClosed) {
      emit(state);
    }
  }

  /// Login user with email and password
  /// Validates input before calling API
  Future<void> login({required String email, required String password}) async {
    // Input validation
    final validationError = _validateInput(email, password);
    if (validationError != null) {
      _safeEmit(LoginFailure(failure: validationError));
      return;
    }

    _safeEmit(const LoginLoading());

    final request = LoginRequest(email: email.trim(), password: password);

    final result = await _authRepository.login(request);

    if (result is Success<dynamic>) {
      final successResult = result as Success;
      _safeEmit(LoginSuccess(user: successResult.data));
    } else if (result is Error<dynamic>) {
      final errorResult = result as Error;
      _safeEmit(LoginFailure(failure: errorResult.failure));
    }
  }

  /// Validate user input before API call
  ValidationFailure? _validateInput(String email, String password) {
    // Validate email
    if (email.isEmpty) {
      return ValidationFailure(message: 'Please enter your email address');
    }

    if (!_isValidEmail(email)) {
      return ValidationFailure(message: 'Please enter a valid email address');
    }

    // Validate password
    if (password.isEmpty) {
      return ValidationFailure(message: 'Please enter your password');
    }

    if (password.length < 6) {
      return ValidationFailure(
        message: 'Password must be at least 6 characters',
      );
    }

    return null;
  }

  /// Simple email validation using regex
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    return emailRegex.hasMatch(email);
  }

  /// Reset cubit to initial state
  void reset() {
    _safeEmit(const LoginInitial());
  }
}
