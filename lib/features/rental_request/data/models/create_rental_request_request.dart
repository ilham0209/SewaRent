class CreateRentalRequestRequest {
  const CreateRentalRequestRequest({required this.propertyId, this.message});

  final String propertyId;
  final String? message;

  Map<String, dynamic> toJson() {
    return {'propertyId': propertyId, if (message != null) 'message': message};
  }
}
