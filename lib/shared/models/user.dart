class User {
  const User({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.role,
    this.profileImageUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: (json['id'] as num).toInt(),
      name: json['name']?.toString() ?? json['fullName']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phoneNumber: json['phoneNumber']?.toString(),
      role: json['role']?.toString(),
      profileImageUrl: json['profileImageUrl']?.toString(),
    );
  }

  final int id;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? role;
  final String? profileImageUrl;
}
