class UserModel {
  final String email;
  final String password;
  final String firstname;
  final String lastname;

  UserModel({
    required this.email,
    required this.password,
    required this.firstname,
     required this.lastname,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'firstname': firstname,
      'lastname':lastname,
    };
  }
}
