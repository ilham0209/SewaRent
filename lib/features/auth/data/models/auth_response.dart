import '../../../../shared/models/user.dart';

class AuthResponse {
  const AuthResponse({required this.accessToken, this.expiresAt, this.user});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['accessToken']?.toString() ?? '',
      expiresAt: json['expiresAt']?.toString(),
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  final String accessToken;
  final String? expiresAt;
  final User? user;
}
