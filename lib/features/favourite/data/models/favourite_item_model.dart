import '../../../property/data/models/property_image_model.dart';
import '../../../property/data/models/property_model.dart';

class FavouriteItemModel {
  const FavouriteItemModel({
    required this.propertyId,
    this.title,
    this.monthlyRent,
    this.city,
    this.state,
    this.imageUrl,
    this.savedAt,
  });

  factory FavouriteItemModel.fromJson(Map<String, dynamic> json) {
    return FavouriteItemModel(
      propertyId: json['propertyId']?.toString() ?? '',
      title: json['title']?.toString(),
      monthlyRent: (json['monthlyRent'] as num?)?.toDouble(),
      city: json['city']?.toString(),
      state: json['state']?.toString(),
      imageUrl: json['imageUrl']?.toString(),
      savedAt: json['savedAt']?.toString(),
    );
  }

  final String propertyId;
  final String? title;
  final double? monthlyRent;
  final String? city;
  final String? state;
  final String? imageUrl;
  final String? savedAt;

  PropertyModel toPropertyModel() {
    return PropertyModel(
      id: propertyId,
      title: title ?? '',
      monthlyRent: monthlyRent ?? 0,
      addressLine1: '',
      city: city ?? '',
      state: state ?? '',
      bedrooms: 0,
      bathrooms: 0,
      isFurnished: false,
      images: imageUrl != null
          ? [PropertyImageModel(id: '', imageUrl: imageUrl!)]
          : [],
    );
  }
}
