class RegisterRequest {
  final String firstname;
  final String lastname;
  final String email;
  final String password;
  final String confirmPassword;
  final String phone;

  RegisterRequest({
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.phone,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'password': password,
      'confirmPassword': confirmPassword,
      'phone': phone,
    };
  }
}