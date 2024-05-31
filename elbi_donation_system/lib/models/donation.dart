class Donation {
  String donationId;
  String donorId; // Foreign Key to the User who made the donation
  String OrganizationId;
  String category;
  String deliveryMethod;
  bool isAddedToDrive;
  double weight;
  List<String>?
      photos; // Optional photos, represented as a list of base64 strings
  DateTime dateTime;
  List<String>? addresses; // Optional addresses for pickup
  String contactNumber; // Contact number of the donor
  String status;
  String? qrCode; // Field to store QR code data

  Donation({
    required this.donationId,
    required this.donorId,
    required this.OrganizationId,
    required this.category,
    required this.deliveryMethod,
    required this.isAddedToDrive,
    required this.weight,
    this.photos,
    required this.dateTime,
    this.addresses,
    required this.contactNumber,
    required this.status,
    this.qrCode,
  });

  // Convert Donation object to JSON
  Map<String, dynamic> toJson() {
    return {
      'donationId': donationId,
      'donorId': donorId,
      'OrganizationId': OrganizationId,
      'category': category,
      'deliveryMethod': deliveryMethod,
      'isAddedToDrive': isAddedToDrive,
      'weight': weight,
      'photos': photos,
      'dateTime': dateTime.toIso8601String(),
      'addresses': addresses,
      'contactNumber': contactNumber,
      'status': status,
      'qrCode': qrCode,
    };
  }

  // Convert JSON to Donation object
  factory Donation.fromJson(Map<String, dynamic> json) {
    return Donation(
      donationId: json['donationId'] ?? '',
      donorId: json['donorId'] ?? '',
      OrganizationId: json['OrganizationId'] ?? '',
      category: json['category'] ?? '',
      deliveryMethod: json['deliveryMethod'] ?? '',
      isAddedToDrive: json['isAddedToDrive'] ?? false,
      weight: (json['weight'] ?? 0.0).toDouble(),
      photos:
          (json['photos'] as List<dynamic>?)?.map((e) => e as String).toList(),
      dateTime:
          DateTime.parse(json['dateTime'] ?? DateTime.now().toIso8601String()),
      addresses: (json['addresses'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      contactNumber: json['contactNumber'] ?? '',
      status: json['status'] ?? '',
      qrCode: json['qrCode'] ?? '',
    );
  }
}
