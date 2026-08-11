class UpdateProfileRequest {
  const UpdateProfileRequest({this.fullName, this.phoneNumber});

  final String? fullName;
  final String? phoneNumber;

  Map<String, dynamic> toJson() {
    return {
      if (fullName != null) 'fullName': fullName,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
    };
  }
}
