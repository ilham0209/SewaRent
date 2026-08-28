import '../../../../core/network/api_client.dart';
import '../models/property_image_model.dart';
import '../models/property_model.dart';
import '../models/property_page.dart';
import '../models/property_query.dart';
import '../models/property_request.dart';

class PropertyRepository {
  PropertyRepository({required this.apiClient});

  final ApiClient apiClient;

  Future<PropertyPage> getProperties({PropertyQuery? query}) async {
    final data = await apiClient.get<Map<String, dynamic>>(
      '/properties',
      queryParameters: query?.toQueryParameters(),
      dataParser: (data) => data as Map<String, dynamic>,
    );
    return PropertyPage.fromJson(data!);
  }

  Future<PropertyModel> getProperty(String id) async {
    final data = await apiClient.get<Map<String, dynamic>>(
      '/properties/$id',
      dataParser: (data) => data as Map<String, dynamic>,
    );
    return PropertyModel.fromJson(data!);
  }

  Future<PropertyModel> createProperty(CreatePropertyRequest request) async {
    final data = await apiClient.post<Map<String, dynamic>>(
      '/properties',
      body: request.toJson(),
      dataParser: (data) => data as Map<String, dynamic>,
    );
    return PropertyModel.fromJson(data!);
  }

  Future<PropertyModel> updateProperty(
    String id,
    UpdatePropertyRequest request,
  ) async {
    final data = await apiClient.put<Map<String, dynamic>>(
      '/properties/$id',
      body: request.toJson(),
      dataParser: (data) => data as Map<String, dynamic>,
    );
    return PropertyModel.fromJson(data!);
  }

  Future<void> deleteProperty(String id) async {
    await apiClient.delete<void>('/properties/$id', dataParser: (_) {});
  }

  Future<PropertyImageModel> uploadImage(
    String propertyId, {
    required List<int> bytes,
    required String filename,
  }) async {
    final data = await apiClient.postMultipart<Map<String, dynamic>>(
      '/properties/$propertyId/images',
      field: 'file',
      bytes: bytes,
      filename: filename,
      dataParser: (data) => data as Map<String, dynamic>,
    );
    return PropertyImageModel.fromJson(data!);
  }

  Future<void> deleteImage(String propertyId, String imageId) async {
    await apiClient.delete<void>(
      '/properties/$propertyId/images/$imageId',
      dataParser: (_) {},
    );
  }
}
