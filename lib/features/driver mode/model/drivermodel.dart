class Driver {
  final String name;
  final String phone;
  final String email;
  final String license;
  final String vehicleType;
  final String vehicleNumber;
  final String address;

  Driver({
    required this.name,
    required this.phone,
    required this.email,
    required this.license,
    required this.vehicleType,
    required this.vehicleNumber,
    required this.address,
  });

  Map<String, dynamic> toJson() {
    return {
      'Name': name,
      'PhoneNumber': phone,
      'Email': email,
      'LicenseNumber': license,
      'VehicleType': vehicleType,
      'VehiclePlateNumber': vehicleNumber,
      'Address': address,
    };
  }
}
