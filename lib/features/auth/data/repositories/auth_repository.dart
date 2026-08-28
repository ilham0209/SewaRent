import '../../../../core/network/api_client.dart';
import '../../../../shared/models/user.dart';
import '../models/auth_response.dart';
import '../models/change_password_request.dart';
import '../models/login_request.dart';
import '../models/register_request.dart';

class AuthRepository {
  AuthRepository({required this.apiClient});

  final ApiClient apiClient;

  Future<AuthResponse> login(LoginRequest request) async {
    final data = await apiClient.post<Map<String, dynamic>>(
      '/auth/login',
      body: request.toJson(),
      authRequired: false,
      dataParser: (data) => data as Map<String, dynamic>,
    );
    return AuthResponse.fromJson(data!);
  }

  Future<AuthResponse> register(RegisterRequest request) async {
    final data = await apiClient.post<Map<String, dynamic>>(
      '/auth/register',
      body: request.toJson(),
      authRequired: false,
      dataParser: (data) => data as Map<String, dynamic>,
    );
    return AuthResponse.fromJson(data!);
  }

  Future<void> changePassword(ChangePasswordRequest request) async {
    await apiClient.post<void>(
      '/auth/change-password',
      body: request.toJson(),
      dataParser: (_) {},
    );
  }

  Future<User> getCurrentUser() async {
    final data = await apiClient.get<Map<String, dynamic>>(
      '/auth/me',
      dataParser: (data) => data as Map<String, dynamic>,
    );
    return User.fromJson(data!);
  }

  Future<String> linkLandlord(String landlordCode) async {
    final data = await apiClient.post<Map<String, dynamic>>(
      '/auth/link-landlord',
      body: {'landlordCode': landlordCode},
      dataParser: (data) => data as Map<String, dynamic>,
    );
    return data?['landlordId']?.toString() ?? '';
  }
}
