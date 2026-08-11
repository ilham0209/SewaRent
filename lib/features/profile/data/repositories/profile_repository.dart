import '../../../../core/network/api_client.dart';
import '../../../../shared/models/user.dart';
import '../models/update_profile_request.dart';

class ProfileRepository {
  ProfileRepository({required this.apiClient});

  final ApiClient apiClient;

  Future<User> getProfile() async {
    final data = await apiClient.get<Map<String, dynamic>>(
      '/users/me',
      dataParser: (data) => data as Map<String, dynamic>,
    );
    return User.fromJson(data!);
  }

  Future<User> updateProfile(UpdateProfileRequest request) async {
    final data = await apiClient.put<Map<String, dynamic>>(
      '/users/me',
      body: request.toJson(),
      dataParser: (data) => data as Map<String, dynamic>,
    );
    return User.fromJson(data!);
  }

  Future<User> uploadProfileImage({
    required List<int> bytes,
    required String filename,
  }) async {
    final data = await apiClient.postMultipart<Map<String, dynamic>>(
      '/users/me/profile-image',
      field: 'file',
      bytes: bytes,
      filename: filename,
      dataParser: (data) => data as Map<String, dynamic>,
    );
    return User.fromJson(data!);
  }
}
