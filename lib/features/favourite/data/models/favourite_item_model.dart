import '../../../property/data/models/property_model.dart';

class FavouriteItemModel {
  const FavouriteItemModel({required this.id, required this.property});

  factory FavouriteItemModel.fromJson(Map<String, dynamic> json) {
    final property = json['property'];
    return FavouriteItemModel(
      id: (json['id'] as num).toInt(),
      property: property is Map<String, dynamic>
          ? PropertyModel.fromJson(property)
          : PropertyModel.fromJson(json),
    );
  }

  final int id;
  final PropertyModel property;
}
