import 'package:equatable/equatable.dart';

class RegisterRequest extends Equatable {
  final String email;
  final String password;
  final String name;

  const RegisterRequest({
    required this.email,
    required this.password,
    required this.name,
  });

  // Convert to JSON for API request
  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password, 'name': name};
  }

  @override
  List<Object?> get props => [email, password, name];
}
