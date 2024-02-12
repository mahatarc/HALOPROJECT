class UserModel {
  final String email;
  final String password;
  final String name;
  final String role;

  UserModel({
    required this.email,
    required this.password,
    required this.name,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'name': name,
      'role': role,
    };
  }
}
