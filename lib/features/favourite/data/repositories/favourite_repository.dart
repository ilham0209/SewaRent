import '../../../../core/network/api_client.dart';
import '../models/favourite_item_model.dart';

class FavouriteRepository {
  FavouriteRepository({required this.apiClient});

  final ApiClient apiClient;

  Future<List<FavouriteItemModel>> getFavourites() async {
    final data = await apiClient.get<Map<String, dynamic>>(
      '/favourites',
      dataParser: (data) => data as Map<String, dynamic>,
    );
    final items = <FavouriteItemModel>[];
    final rawItems = data?['items'];
    if (rawItems is List) {
      for (final item in rawItems) {
        if (item is Map<String, dynamic>) {
          items.add(FavouriteItemModel.fromJson(item));
        }
      }
    }
    return items;
  }

  Future<void> addFavourite(String propertyId) async {
    await apiClient.post<void>(
      '/favourites',
      body: {'propertyId': propertyId},
      dataParser: (_) {},
    );
  }

  Future<void> removeFavourite(String propertyId) async {
    await apiClient.delete<void>('/favourites/$propertyId', dataParser: (_) {});
  }
}
