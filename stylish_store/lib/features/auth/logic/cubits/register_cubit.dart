import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylish_store/core/failures/failure.dart';
import 'package:stylish_store/core/failures/result.dart';
import 'package:stylish_store/features/auth/data/models/register_request.dart';
import 'package:stylish_store/features/auth/data/repositories/auth_repository.dart';
import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthRepository _authRepository;

  RegisterCubit({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const RegisterInitial());

  /// Register user with email, password, and name
  /// Validates input before calling API
  Future<void> register({
    required String email,
    required String password,
    required String name,
  }) async {
    // Input validation
    final validationError = _validateInput(email, password, name);
    if (validationError != null) {
      emit(RegisterFailure(failure: validationError));
      return;
    }

    emit(const RegisterLoading());

    final request = RegisterRequest(
      email: email.trim(),
      password: password,
      name: name.trim(),
    );

    final result = await _authRepository.register(request);

    if (result is Success<dynamic>) {
      final successResult = result as Success;
      emit(RegisterSuccess(user: successResult.data));
    } else if (result is Error<dynamic>) {
      final errorResult = result as Error;
      emit(RegisterFailure(failure: errorResult.failure));
    }
  }

  /// Validate user input before API call
  /// Returns ValidationFailure if validation fails, null otherwise
  ValidationFailure? _validateInput(
    String email,
    String password,
    String name,
  ) {
    // Validate email
    if (email.isEmpty) {
      return ValidationFailure(message: 'Please enter your email address');
    }

    if (!_isValidEmail(email)) {
      return ValidationFailure(message: 'Please enter a valid email address');
    }

    // Validate name
    if (name.isEmpty) {
      return ValidationFailure(message: 'Please enter your name');
    }

    if (name.length < 2) {
      return ValidationFailure(message: 'Name must be at least 2 characters');
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
    emit(const RegisterInitial());
  }
}
