class User {
  String userId;
  String name;
  String email;
  String username;
  String password;
  List<String> addresses;
  String contactNo;
  bool isOrganization;
  List<String> proofOfLegitimacyBase64;
  bool isApproved;
  String description;
  bool openForDonations;

  User({
    required this.userId,
    required this.name,
    required this.email,
    required this.username,
    required this.password,
    required this.addresses,
    required this.contactNo,
    required this.isOrganization,
    required this.isApproved,
    this.proofOfLegitimacyBase64 = const [],
    this.description = '',
    this.openForDonations = false,
  });

  // Method to convert a User object to JSON (Map<String, dynamic>)
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'username': username,
      'password': password,
      'addresses': addresses,
      'contactNo': contactNo,
      'isOrganization': isOrganization,
      'proofOfLegitimacyBase64': proofOfLegitimacyBase64,
      'isApproved': isApproved,
      'description': description,
      'openForDonations': openForDonations,
    };
  }

  // Method to create a User object from JSON (Map<String, dynamic>)
  static User fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'],
      name: json['name'],
      email: json['email'],
      username: json['username'],
      password: json['password'],
      addresses: List<String>.from(json['addresses']),
      contactNo: json['contactNo'].toString(),
      isOrganization: json['isOrganization'],
      proofOfLegitimacyBase64:
          List<String>.from(json['proofOfLegitimacyBase64']),
      isApproved: json['isApproved'],
      description: json['description'],
      openForDonations: json['openForDonations'],
    );
  }
}
