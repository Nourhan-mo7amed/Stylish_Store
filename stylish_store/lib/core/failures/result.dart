import 'package:equatable/equatable.dart';
import 'failure.dart';

abstract class Result<T> extends Equatable {
  const Result();
}

class Success<T> extends Result<T> {
  final T data;

  const Success({required this.data});

  @override
  List<Object?> get props => [data];
}

class Error<T> extends Result<T> {
  final Failure failure;

  const Error({required this.failure});

  @override
  List<Object?> get props => [failure];
}
