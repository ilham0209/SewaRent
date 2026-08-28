class Property {
  const Property({
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
    this.imageUrls = const [],
  });

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
  final List<String> imageUrls;

  String get locationLabel => '$city, $state';
}
