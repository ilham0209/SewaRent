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
    this.propertyType,
    this.availabilityStatus,
    this.imageUrls = const [],
    this.landlordName,
  });

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
  final String? availabilityStatus;
  final String? propertyType;
  final List<String> imageUrls;
  final String? landlordName;

  String get locationLabel => '$city, $state';
}
