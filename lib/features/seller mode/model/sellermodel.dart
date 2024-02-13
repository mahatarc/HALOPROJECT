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

  Map<String, dynamic> toJson() {
    return {
      'businessName': businessName,
      'contactNumber': contactNumber,
      'address': address,
      'city': city,
      'province': province,
      'citizenshipNumber': citizenshipNumber,
      
    };
  }
}
