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
    this.latitude,
    this.longitude,
    this.propertyTypeId,
    this.propertyTypeName,
    this.availabilityStatus,
    this.isActive = true,
    this.landlordId,
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

    final singleImageUrl = json['imageUrl']?.toString();
    if (singleImageUrl != null && images.isEmpty) {
      images.add(PropertyImageModel(id: '', imageUrl: singleImageUrl));
    }

    final rawPropertyType = json['propertyType'];
    String? propertyTypeId;
    String? propertyTypeName;
    if (rawPropertyType is Map<String, dynamic>) {
      propertyTypeId = rawPropertyType['id']?.toString();
      propertyTypeName = rawPropertyType['name']?.toString();
    } else if (rawPropertyType is String) {
      propertyTypeName = rawPropertyType;
    }
    propertyTypeName ??= json['propertyTypeName']?.toString();

    return PropertyModel(
      id: json['id']?.toString() ?? '',
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
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      propertyTypeId: propertyTypeId,
      propertyTypeName: propertyTypeName,
      isFurnished: json['isFurnished'] == true,
      availabilityStatus: json['availabilityStatus']?.toString(),
      isActive: json['isActive'] != false,
      landlordId: json['landlordId']?.toString(),
      landlordName: json['landlordName']?.toString(),
      images: images,
    );
  }

  final String id;
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
  final double? latitude;
  final double? longitude;
  final String? propertyTypeId;
  final String? propertyTypeName;
  final bool isFurnished;
  final String? availabilityStatus;
  final bool isActive;
  final String? landlordId;
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
      latitude: latitude,
      longitude: longitude,
      propertyTypeId: propertyTypeId,
      propertyTypeName: propertyTypeName,
      isFurnished: isFurnished,
      availabilityStatus: availabilityStatus,
      isActive: isActive,
      landlordId: landlordId,
      landlordName: landlordName,
      imageUrls: images.map((image) => image.imageUrl).toList(),
    );
  }
}
