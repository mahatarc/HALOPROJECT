class Seller {
  final String businessName;
  final String contactNumber;
  final String address;
  final String city;
  final String province;
  final String citizenshipNumber;
  final String imageUrl;

  Seller({
    required this.businessName,
    required this.contactNumber,
    required this.address,
    required this.city,
    required this.province,
    required this.citizenshipNumber,
    required this.imageUrl,
  });

  factory Seller.fromMap(Map<String, dynamic> map) {
    return Seller(
      businessName: map['businessName'] ?? '',
      contactNumber: map['contactNumber'] ?? '',
      address: map['address'] ?? '',
      city: map['city'] ?? '',
      province: map['province'] ?? '',
      citizenshipNumber: map['citizenshipNumber'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }
}
