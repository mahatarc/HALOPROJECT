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
        title: Text('Delivery Address'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: fullNameController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(labelText: 'Full Name'),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z\s]+$')),
              ],
            ),
            SizedBox(height: 10),
            TextField(
              controller: addressLine1Controller,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(labelText: 'Address Line'),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z\s]+$')),
              ],
            ),
            SizedBox(height: 10),
            TextField(
              controller: cityController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(labelText: 'City'),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z\s]+$')),
              ],
            ),
            SizedBox(height: 10),
            TextField(
              controller: postalCodeController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(labelText: 'Postal Code'),
              keyboardType: TextInputType.number,
              inputFormatters: [
                LengthLimitingTextInputFormatter(5),
                FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*$')),
              ],
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
              child: Text('Proceed to Payment'),
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
