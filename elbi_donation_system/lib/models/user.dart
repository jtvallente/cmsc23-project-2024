class User {
  String userId;
  String name;
  String username;
  String password;
  List<String> addresses;
  String contactNo;
  bool isOrganization;
  List<String> proofOfLegitimacyBase64; // Store as base64 strings
  bool isApproved;
  String description;
  bool openForDonations;

  User({
    required this.userId,
    required this.name,
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
}
