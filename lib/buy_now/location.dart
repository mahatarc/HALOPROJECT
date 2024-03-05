import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterproject/buy_now/Payment.dart';

class DeliveryAddressScreen extends StatefulWidget {
  final product_detail_name;
  final product_detail_price;
  final product_detail_picture;
  final String? businessName;
  final String? contactNumber;
  final String? address;
  final String? city;
  final String? province;

  DeliveryAddressScreen({
    this.product_detail_name,
    this.product_detail_price,
    this.product_detail_picture,
    this.businessName,
    this.contactNumber,
    this.address,
    this.city,
    this.province,
  });
  @override
  _DeliveryAddressScreenState createState() => _DeliveryAddressScreenState();
}

class _DeliveryAddressScreenState extends State<DeliveryAddressScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController addressLine1Controller = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();

  bool _isFormValid() {
    return _isValidAlphabetic(fullNameController.text) &&
        _isValidAlphabetic(addressLine1Controller.text) &&
        _isValidAlphabetic(cityController.text);
  }

  bool _isValidAlphabetic(String text) {
    return RegExp(r'^[a-zA-Z\s]+$').hasMatch(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[100],
        title: Text(
          'Delivery Address',
        ),
      ),
      body: SingleChildScrollView(
        // Wrap with SingleChildScrollView
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: fullNameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ), // Adding border to text field
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: addressLine1Controller,
              decoration: InputDecoration(
                labelText: 'Address Line',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: cityController,
              decoration: InputDecoration(
                labelText: 'City',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: postalCodeController,
              decoration: InputDecoration(
                labelText: 'Postal Code',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isFormValid()
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentPage(
                            fullName: fullNameController.text,
                            address: addressLine1Controller.text,
                            city: cityController.text,
                            productName: widget.product_detail_name,
                            productPrice:
                                double.parse(widget.product_detail_price),
                            productPicture: widget.product_detail_picture,
                            businessName: widget.businessName,
                            contactNumber: widget.contactNumber,
                            sellerAddress: widget.address,
                            sellerCity: widget.city,
                            sellerProvince: widget.province,
                          ),
                        ),
                      );
                    }
                  : null,
              child: Text(
                'Proceed to Payment',
                style: TextStyle(
                  color: Colors.white, // Button text color
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: _isFormValid() ? Colors.green[200] : Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PayOnDeliveryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pay on Delivery'),
      ),
      body: Center(
        child: Text('Pay when the product is delivered'),
      ),
    );
  }
}
