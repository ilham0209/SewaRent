import '../../../../core/network/api_client.dart';
import '../models/favourite_item_model.dart';

class FavouriteRepository {
  FavouriteRepository({required this.apiClient});

  final ApiClient apiClient;

  Future<List<FavouriteItemModel>> getFavourites() async {
    final data = await apiClient.get<List<dynamic>>(
      '/favourites',
      dataParser: (data) => data as List<dynamic>,
    );
    final items = <FavouriteItemModel>[];
    for (final item in data!) {
      if (item is Map<String, dynamic>) {
        items.add(FavouriteItemModel.fromJson(item));
      }
    }
    return items;
  }

  Future<void> addFavourite(int propertyId) async {
    await apiClient.post<void>(
      '/favourites',
      body: {'propertyId': propertyId},
      dataParser: (_) {},
    );
  }

  Future<void> removeFavourite(int propertyId) async {
    await apiClient.delete<void>('/favourites/$propertyId', dataParser: (_) {});
  }
}
