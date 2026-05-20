import 'package:equatable/equatable.dart';
import 'package:stylish_store/core/failures/failure.dart';
import 'package:stylish_store/features/auth/data/models/forgot_password_response.dart';

abstract class ForgotPasswordState extends Equatable {
  const ForgotPasswordState();

  @override
  List<Object?> get props => [];
}

class ForgotPasswordInitial extends ForgotPasswordState {
  const ForgotPasswordInitial();
}

class ForgotPasswordLoading extends ForgotPasswordState {
  const ForgotPasswordLoading();
}

class ForgotPasswordSuccess extends ForgotPasswordState {
  final ForgotPasswordResponse response;

  const ForgotPasswordSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

class ForgotPasswordFailure extends ForgotPasswordState {
  final Failure failure;

  const ForgotPasswordFailure({required this.failure});

  @override
  List<Object?> get props => [failure];
}
