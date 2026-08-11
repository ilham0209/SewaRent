import '../../domain/entities/property.dart';
import 'property_image_model.dart';

class PropertyModel {
  const PropertyModel({
    required this.id,
    required this.title,
    required this.monthlyRent,
    required this.addressLine1,
    required this.city,
    required this.state,
    required this.bedrooms,
    required this.bathrooms,
    required this.isFurnished,
    this.description,
    this.addressLine2,
    this.postcode,
    this.parkingSpaces,
    this.propertyType,
    this.availabilityStatus,
    this.landlordName,
    this.images = const [],
  });

  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    final images = <PropertyImageModel>[];
    final rawImages = json['images'];
    if (rawImages is List) {
      for (final image in rawImages) {
        if (image is Map<String, dynamic>) {
          images.add(PropertyImageModel.fromJson(image));
        }
      }
    }

    return PropertyModel(
      id: (json['id'] as num).toInt(),
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString(),
      monthlyRent: (json['monthlyRent'] as num?)?.toDouble() ?? 0,
      addressLine1: json['addressLine1']?.toString() ?? '',
      addressLine2: json['addressLine2']?.toString(),
      city: json['city']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      postcode: json['postcode']?.toString(),
      bedrooms: (json['bedrooms'] as num?)?.toInt() ?? 0,
      bathrooms: (json['bathrooms'] as num?)?.toInt() ?? 0,
      parkingSpaces: (json['parkingSpaces'] as num?)?.toInt(),
      isFurnished: json['isFurnished'] == true,
      propertyType: json['propertyType']?.toString(),
      availabilityStatus: json['availabilityStatus']?.toString(),
      landlordName: json['landlordName']?.toString(),
      images: images,
    );
  }

  final int id;
  final String title;
  final String? description;
  final double monthlyRent;
  final String addressLine1;
  final String? addressLine2;
  final String city;
  final String state;
  final String? postcode;
  final int bedrooms;
  final int bathrooms;
  final int? parkingSpaces;
  final bool isFurnished;
  final String? propertyType;
  final String? availabilityStatus;
  final String? landlordName;
  final List<PropertyImageModel> images;

  Property toEntity() {
    return Property(
      id: id,
      title: title,
      description: description,
      monthlyRent: monthlyRent,
      addressLine1: addressLine1,
      addressLine2: addressLine2,
      city: city,
      state: state,
      postcode: postcode,
      bedrooms: bedrooms,
      bathrooms: bathrooms,
      parkingSpaces: parkingSpaces,
      isFurnished: isFurnished,
      propertyType: propertyType,
      availabilityStatus: availabilityStatus,
      landlordName: landlordName,
      imageUrls: images.map((image) => image.imageUrl).toList(),
    );
  }
}
