class Donation {
  String donationId;
  String donorId; // Foreign Key to the User who made the donation
  String OrganizationId;
  String category;
  String deliveryMethod;
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
    required this.weight,
    this.photos,
    required this.dateTime,
    this.addresses,
    required this.contactNumber,
    required this.status,
    this.qrCode,
  });

  Map<String, dynamic> toJson() {
    return {
      'donationId': donationId,
      'donorId': donorId,
      'organizationId': OrganizationId,
      'category': category,
      'deliveryMethod': deliveryMethod,
      'weight': weight,
      'photos': photos,
      'dateTime': dateTime.toIso8601String(),
      'addresses': addresses,
      'contactNumber': contactNumber,
      'status': status,
      'qrCode': qrCode,
    };
  }

  static Donation fromJson(Map<String, dynamic> json) {
    return Donation(
      donationId: json['donationId'] ?? '',
      donorId: json['donorId'] ?? '',
      OrganizationId: json['organizationId'] ?? '',
      category: json['category'] ?? '',
      deliveryMethod: json['deliveryMethod'] ?? '',
      weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
      photos: json['photos'] != null ? List<String>.from(json['photos']) : null,
      dateTime:
          DateTime.parse(json['dateTime'] ?? DateTime.now().toIso8601String()),
      addresses: json['addresses'] != null
          ? List<String>.from(json['addresses'])
          : null,
      contactNumber: json['contactNumber'] ?? '',
      status: json['status'] ?? '',
      qrCode: json['qrCode'],
    );
  }
}
