import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stylish_store/core/failures/failure.dart';
import 'package:stylish_store/core/failures/result.dart';
import 'package:stylish_store/features/auth/data/models/forgot_password_request.dart';
import 'package:stylish_store/features/auth/data/repositories/auth_repository.dart';
import 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final AuthRepository _authRepository;

  ForgotPasswordCubit({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const ForgotPasswordInitial());

  /// Safely emit state only if the cubit is not closed
  /// Prevents "Cannot emit new states after calling close" error
  void _safeEmit(ForgotPasswordState state) {
    if (!isClosed) {
      emit(state);
    }
  }

  /// Send password reset email
  /// Validates input before calling API
  Future<void> sendResetEmail({required String email}) async {
    // Input validation
    final validationError = _validateEmail(email);
    if (validationError != null) {
      _safeEmit(ForgotPasswordFailure(failure: validationError));
      return;
    }

    _safeEmit(const ForgotPasswordLoading());

    final request = ForgotPasswordRequest(email: email.trim());
    final result = await _authRepository.forgotPassword(request);

    if (result is Success<dynamic>) {
      final successResult = result as Success;
      _safeEmit(ForgotPasswordSuccess(response: successResult.data));
    } else if (result is Error<dynamic>) {
      final errorResult = result as Error;
      _safeEmit(ForgotPasswordFailure(failure: errorResult.failure));
    }
  }

  /// Validate email before API call
  ValidationFailure? _validateEmail(String email) {
    if (email.isEmpty) {
      return ValidationFailure(message: 'Please enter your email address');
    }

    if (!_isValidEmail(email)) {
      return ValidationFailure(message: 'Please enter a valid email address');
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
    _safeEmit(const ForgotPasswordInitial());
  }
}
