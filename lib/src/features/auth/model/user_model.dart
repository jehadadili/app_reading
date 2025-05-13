class UserModel {
  String id;
  String username;
  String email;
  String password;
  String cpassword;
  bool isAdmin;
  UserModel({
    required this.id,
    required this.email,
    required this.password,
    required this.cpassword,
    required this.username,
    required this.isAdmin,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json['id'],
        username: json['username'],
        email: json['email'],
        password: json['password'],
        cpassword: json['password'],
        isAdmin: json['is_admin']);
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
      'is_admin': isAdmin,
    };
  }
}
