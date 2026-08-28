class User {
  const User({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.role,
    this.profileImageUrl,
    this.landlordCode,
    this.landlordId,
    this.bankName,
    this.bankAccountNumber,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      name: json['fullName']?.toString() ?? json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phoneNumber: json['phoneNumber']?.toString(),
      role: json['role']?.toString(),
      profileImageUrl: json['profileImageUrl']?.toString(),
      landlordCode: json['landlordCode']?.toString(),
      landlordId: json['landlordId']?.toString(),
      bankName: json['bankName']?.toString(),
      bankAccountNumber: json['bankAccountNumber']?.toString(),
    );
  }

  final String id;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? role;
  final String? profileImageUrl;
  final String? landlordCode;
  final String? landlordId;
  final String? bankName;
  final String? bankAccountNumber;

  bool get isLandlord => role == 'Landlord';
  bool get isTenant => role == 'Tenant';
  bool get isLinkedToLandlord => landlordId != null;
}
