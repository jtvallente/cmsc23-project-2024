class Donation {
  String donationId;
  String donorId; // Foreign Key to the User who made the donation
  String category;
  String deliveryMethod;
  double weight;
  String? photo; // Optional photo, represented as a URL or base64 string
  DateTime dateTime;
  String? address; // Optional address for pickup
  String? contactNumber; // Optional contact number for pickup
  String status;

  Donation({
    required this.donationId,
    required this.donorId,
    required this.category,
    required this.deliveryMethod,
    required this.weight,
    this.photo,
    required this.dateTime,
    this.address,
    this.contactNumber,
    required this.status,
  });
}
