import 'package:flutter/material.dart';
import 'package:flutterproject/buy_now/Payment.dart';
import 'package:flutterproject/features/mapservice/presentation/maps.dart';

class DeliveryAddressScreen extends StatefulWidget {
  final product_detail_name;
  final product_detail_price;
  final product_detail_picture;
  final String? businessName;
  final String? contactNumber;
  final String? address;
  final String? city;
  final String? province;
  final String? contact;

  DeliveryAddressScreen({
    this.product_detail_name,
    this.product_detail_price,
    this.product_detail_picture,
    this.businessName,
    this.contactNumber,
    this.address,
    this.city,
    this.province,
    this.contact,
  });

  @override
  _DeliveryAddressScreenState createState() => _DeliveryAddressScreenState();
}

class _DeliveryAddressScreenState extends State<DeliveryAddressScreen> {
  String? _selectedAddress;
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController addressLine1Controller = TextEditingController();
  final TextEditingController contact_no_Controller = TextEditingController();
  //final TextEditingController postalCodeController = TextEditingController();

  bool _isFormValid() {
    return _isValidAlphabetic(fullNameController.text) &&
        _selectedAddress != null &&
        contact_no_Controller.text.isNotEmpty;
    ;
  }

  bool _isValidAlphabetic(String text) {
    return RegExp(r'^[a-zA-Z\s]+$').hasMatch(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[100],
        title: Text('Delivery Address'),
      ),
      body: SingleChildScrollView(
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
            if (_selectedAddress != null) ...[
              // Text(
              //   'Selected Address: $_selectedAddress',
              //   style: TextStyle(fontSize: 16),
              // ),
              SizedBox(height: 20),
            ],
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 40,
              width: 20,
              child: ElevatedButton(
                onPressed: () async {
                  // Navigate to the map screen
                  final selectedAddress = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MapService(),
                    ),
                  );
                  if (selectedAddress != null) {
                    setState(() {
                      // Update the selected address
                      _selectedAddress = selectedAddress;
                      addressLine1Controller.text = _selectedAddress!;
                    });
                  }
                },
                child: Text('Set Location'),
              ),
            ),
            SizedBox(height: 20),
            // Updated text field to display selected address
            TextField(
              controller: addressLine1Controller,
              onChanged: (value) {
                setState(() {
                  _selectedAddress = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Delivery Address',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
              ),
            ),

            SizedBox(height: 10),
            TextField(
              controller: contact_no_Controller,
              decoration: InputDecoration(
                labelText: 'Contact Number',
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
                            contact: contact_no_Controller.text,
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
