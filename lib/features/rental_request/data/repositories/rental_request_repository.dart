import '../../../../core/network/api_client.dart';
import '../models/create_rental_request_request.dart';
import '../models/rental_request_model.dart';

class RentalRequestRepository {
  RentalRequestRepository({required this.apiClient});

  final ApiClient apiClient;

  Future<RentalRequestModel> createRentalRequest(
    CreateRentalRequestRequest request,
  ) async {
    final data = await apiClient.post<Map<String, dynamic>>(
      '/rental-requests',
      body: request.toJson(),
      dataParser: (data) => data as Map<String, dynamic>,
    );
    return RentalRequestModel.fromJson(data!);
  }

  Future<List<RentalRequestModel>> getTenantRequests() async {
    final data = await apiClient.get<Map<String, dynamic>>(
      '/rental-requests/my',
      dataParser: (data) => data as Map<String, dynamic>,
    );
    return _parsePaginated(data);
  }

  Future<RentalRequestModel> getRentalRequest(String id) async {
    final data = await apiClient.get<Map<String, dynamic>>(
      '/rental-requests/$id',
      dataParser: (data) => data as Map<String, dynamic>,
    );
    return RentalRequestModel.fromJson(data!);
  }

  Future<void> cancelRentalRequest(String id) async {
    await apiClient.post<void>(
      '/rental-requests/$id/cancel',
      dataParser: (_) {},
    );
  }

  Future<List<RentalRequestModel>> getLandlordRequests() async {
    final data = await apiClient.get<Map<String, dynamic>>(
      '/landlord/rental-requests',
      dataParser: (data) => data as Map<String, dynamic>,
    );
    return _parsePaginated(data);
  }

  Future<void> approveRentalRequest(String id) async {
    await apiClient.post<void>(
      '/rental-requests/$id/approve',
      dataParser: (_) {},
    );
  }

  Future<void> rejectRentalRequest(String id) async {
    await apiClient.post<void>(
      '/rental-requests/$id/reject',
      dataParser: (_) {},
    );
  }

  List<RentalRequestModel> _parsePaginated(Map<String, dynamic>? data) {
    final requests = <RentalRequestModel>[];
    final rawItems = data?['items'];
    if (rawItems is List) {
      for (final item in rawItems) {
        if (item is Map<String, dynamic>) {
          requests.add(RentalRequestModel.fromJson(item));
        }
      }
    }
    return requests;
  }
}
