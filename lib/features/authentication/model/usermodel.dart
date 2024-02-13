class UserModel {
  final String email;
  final String name;
  final String role;
  

  UserModel({
    required this.email,
    required this.name,
     required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'firstname': name,
       'role': role,
    };
  }
}
