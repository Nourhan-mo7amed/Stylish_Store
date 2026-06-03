import 'package:equatable/equatable.dart';

class LoginResponse extends Equatable {
  final int id;
  final String email;
  final String name;
  final String? avatar;
  final String? role;
  final String? creationAt;
  final String? accessToken;
  final String? refreshToken;

  const LoginResponse({
    required this.id,
    required this.email,
    required this.name,
    this.avatar,
    this.role,
    this.creationAt,
    this.accessToken,
    this.refreshToken,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      avatar: json['avatar'],
      role: json['role'],
      creationAt: json['creationAt'],
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'avatar': avatar,
      'role': role,
      'creationAt': creationAt,
      'access_token': accessToken,
      'refresh_token': refreshToken,
    };
  }

  @override
  List<Object?> get props => [
    id,
    email,
    name,
    avatar,
    role,
    creationAt,
    accessToken,
    refreshToken,
  ];
}
