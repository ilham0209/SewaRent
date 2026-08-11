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
    final data = await apiClient.get<List<dynamic>>(
      '/rental-requests/my',
      dataParser: (data) => data as List<dynamic>,
    );
    return _parseList(data);
  }

  Future<RentalRequestModel> getRentalRequest(int id) async {
    final data = await apiClient.get<Map<String, dynamic>>(
      '/rental-requests/$id',
      dataParser: (data) => data as Map<String, dynamic>,
    );
    return RentalRequestModel.fromJson(data!);
  }

  Future<void> cancelRentalRequest(int id) async {
    await apiClient.post<void>(
      '/rental-requests/$id/cancel',
      dataParser: (_) {},
    );
  }

  Future<List<RentalRequestModel>> getLandlordRequests() async {
    final data = await apiClient.get<List<dynamic>>(
      '/landlord/rental-requests',
      dataParser: (data) => data as List<dynamic>,
    );
    return _parseList(data);
  }

  Future<void> approveRentalRequest(int id) async {
    await apiClient.post<void>(
      '/rental-requests/$id/approve',
      dataParser: (_) {},
    );
  }

  Future<void> rejectRentalRequest(int id) async {
    await apiClient.post<void>(
      '/rental-requests/$id/reject',
      dataParser: (_) {},
    );
  }

  List<RentalRequestModel> _parseList(List<dynamic>? data) {
    final requests = <RentalRequestModel>[];
    for (final item in data ?? const <dynamic>[]) {
      if (item is Map<String, dynamic>) {
        requests.add(RentalRequestModel.fromJson(item));
      }
    }
    return requests;
  }
}
