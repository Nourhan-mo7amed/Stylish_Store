import 'package:equatable/equatable.dart';

class ForgotPasswordResponse extends Equatable {
  final bool success;
  final String message;

  const ForgotPasswordResponse({required this.success, required this.message});

  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordResponse(
      success: json['success'] ?? true,
      message: json['message'] ?? 'Password reset email sent successfully',
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message};
  }

  @override
  List<Object?> get props => [success, message];
}
