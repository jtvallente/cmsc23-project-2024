class Admin {
  String adminId;
  String name;
  String username;
  String password;
  String email;

  Admin({
    required this.adminId,
    required this.name,
    required this.username,
    required this.password,
    required this.email,
  });

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      adminId: json['adminId'] ?? '',
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'adminId': adminId,
      'name': name,
      'username': username,
      'password': password,
      'email': email,
    };
  }
}
