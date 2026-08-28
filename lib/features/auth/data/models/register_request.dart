class RegisterRequest {
  const RegisterRequest({
    required this.fullName,
    required this.email,
    required this.password,
    required this.role,
    this.phoneNumber,
  });

  final String fullName;
  final String email;
  final String password;
  final String role;
  final String? phoneNumber;

  Map<String, dynamic> toJson() => {
    'fullName': fullName,
    'email': email,
    'password': password,
    'role': role,
    if (phoneNumber != null) 'phoneNumber': phoneNumber,
  };
}
