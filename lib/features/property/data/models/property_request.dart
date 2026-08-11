class CreatePropertyRequest {
  const CreatePropertyRequest({
    required this.title,
    this.description,
    required this.monthlyRent,
    required this.addressLine1,
    this.addressLine2,
    required this.city,
    required this.state,
    this.postcode,
    required this.bedrooms,
    required this.bathrooms,
    this.parkingSpaces,
    required this.isFurnished,
    this.propertyTypeId,
  });

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
  final int? propertyTypeId;

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      if (description != null) 'description': description,
      'monthlyRent': monthlyRent,
      'addressLine1': addressLine1,
      if (addressLine2 != null) 'addressLine2': addressLine2,
      'city': city,
      'state': state,
      if (postcode != null) 'postcode': postcode,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      if (parkingSpaces != null) 'parkingSpaces': parkingSpaces,
      'isFurnished': isFurnished,
      if (propertyTypeId != null) 'propertyTypeId': propertyTypeId,
    };
  }
}

class UpdatePropertyRequest {
  const UpdatePropertyRequest({
    required this.title,
    this.description,
    required this.monthlyRent,
    required this.addressLine1,
    this.addressLine2,
    required this.city,
    required this.state,
    this.postcode,
    required this.bedrooms,
    required this.bathrooms,
    this.parkingSpaces,
    required this.isFurnished,
    this.availabilityStatus,
    this.propertyTypeId,
  });

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
  final int? propertyTypeId;

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      if (description != null) 'description': description,
      'monthlyRent': monthlyRent,
      'addressLine1': addressLine1,
      if (addressLine2 != null) 'addressLine2': addressLine2,
      'city': city,
      'state': state,
      if (postcode != null) 'postcode': postcode,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      if (parkingSpaces != null) 'parkingSpaces': parkingSpaces,
      'isFurnished': isFurnished,
      if (availabilityStatus != null) 'availabilityStatus': availabilityStatus,
      if (propertyTypeId != null) 'propertyTypeId': propertyTypeId,
    };
  }
}
