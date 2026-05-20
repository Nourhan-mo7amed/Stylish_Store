import 'package:equatable/equatable.dart';
import 'package:stylish_store/core/failures/failure.dart';
import 'package:stylish_store/features/auth/data/models/register_response.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object?> get props => [];
}

class RegisterInitial extends RegisterState {
  const RegisterInitial();
}

class RegisterLoading extends RegisterState {
  const RegisterLoading();
}

class RegisterSuccess extends RegisterState {
  final RegisterResponse user;

  const RegisterSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}

class RegisterFailure extends RegisterState {
  final Failure failure;

  const RegisterFailure({required this.failure});

  @override
  List<Object?> get props => [failure];
}
