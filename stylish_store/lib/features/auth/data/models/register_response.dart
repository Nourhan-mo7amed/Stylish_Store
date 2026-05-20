import 'package:equatable/equatable.dart';

class RegisterResponse extends Equatable {
  final int id;
  final String email;
  final String name;
  final String? avatar;
  final String? role;
  final String? creationAt;

  const RegisterResponse({
    required this.id,
    required this.email,
    required this.name,
    this.avatar,
    this.role,
    this.creationAt,
  });

  // Create from JSON response
  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      avatar: json['avatar'],
      role: json['role'],
      creationAt: json['creationAt'],
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'avatar': avatar,
      'role': role,
      'creationAt': creationAt,
    };
  }

  @override
  List<Object?> get props => [id, email, name, avatar, role, creationAt];
}
