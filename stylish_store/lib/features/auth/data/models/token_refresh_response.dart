import 'package:equatable/equatable.dart';

class TokenRefreshResponse extends Equatable {
  final String? accessToken;
  final String? refreshToken;

  const TokenRefreshResponse({this.accessToken, this.refreshToken});

  factory TokenRefreshResponse.fromJson(Map<String, dynamic> json) {
    return TokenRefreshResponse(
      accessToken: json['access_token'] ?? json['accessToken'],
      refreshToken: json['refresh_token'] ?? json['refreshToken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'access_token': accessToken, 'refresh_token': refreshToken};
  }

  @override
  List<Object?> get props => [accessToken, refreshToken];
}
