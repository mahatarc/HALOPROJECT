import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentService {
  Future<bool> processPayment(
    String cardNumber,
    String cvv,
    String expiryDate,
    String fullName,
    String address,
    String city,
    String productPrice,
    String productName,
    String? businessName,
    String? contactNumber,
    String? sellerAddress,
    String? sellerCity,
    String? sellerProvince,
  ) async {
    await Future.delayed(Duration(seconds: 2));

    if (_isExpired(expiryDate)) {
      return false;
    }

    try {
      // Store order details in Firestore
      await FirebaseFirestore.instance.collection('orders').add({
        'productName': productName,
        'customerName': fullName,
        'customeraddress': address,
        'city': city,
        'amount': productPrice,
        'paymentStatus': 'Successful',
        'timestamp': Timestamp.now(),
        'businessName': businessName,
        'contactNumber': contactNumber,
        'address': sellerAddress,
        'Sellercity': sellerCity,
        'province': sellerProvince,
      });
      return true;
    } catch (e) {
      print("Error storing order details: $e");
      return false;
    }
  }

  bool _isExpired(String expiryDate) {
    final currentDate = DateTime.now();

    final parts = expiryDate.split('-');
    final expiryYear = int.tryParse('20' + parts[1]) ?? 0;
    final expiryMonth = int.tryParse(parts[0]) ?? 0;

    if (expiryYear < currentDate.year ||
        (expiryYear == currentDate.year && expiryMonth < currentDate.month)) {
      return true;
    }

    return false;
  }
}

class CardPaymentScreen extends StatelessWidget {
  final PaymentService paymentService = PaymentService();
  final String fullName;
  final String address;
  final String city;
  final String productName;
  final double productPrice;
  final String productPicture;
  final String? businessName;
  final String? contactNumber;
  final String? sellerAddress;
  final String? sellerCity;
  final String? sellerProvince;

  CardPaymentScreen({
    required this.fullName,
    required this.address,
    required this.city,
    required this.productName,
    required this.productPrice,
    required this.productPicture,
    this.businessName,
    this.contactNumber,
    this.sellerAddress,
    this.sellerCity,
    this.sellerProvince,
  });

  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Credit/Debit Card Payment'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: cardNumberController,
                decoration: InputDecoration(labelText: 'Card Number'),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              SizedBox(height: 10),
              TextField(
                controller: cvvController,
                decoration: InputDecoration(labelText: 'CVV'),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              SizedBox(height: 10),
              TextField(
                controller: expiryDateController,
                decoration: InputDecoration(labelText: 'Expiry Date (MM-YY)'),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^\d{0,2}-?\d{0,2}$')),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (cardNumberController.text.isEmpty ||
                      cvvController.text.isEmpty ||
                      expiryDateController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Please fill all fields.'),
                    ));
                    return;
                  }

                  final parts = expiryDateController.text.split('-');
                  final expiryMonth = int.tryParse(parts[0]) ?? 0;
                  final expiryYear = int.tryParse('20' + parts[1]) ?? 0;

                  if (expiryMonth < 1 ||
                      expiryMonth > 12 ||
                      expiryYear < 2000 ||
                      expiryYear > 2099) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Please enter a valid expiry date.'),
                    ));
                    return;
                  }

                  bool isSuccess = await paymentService.processPayment(
                    cardNumberController.text,
                    cvvController.text,
                    expiryDateController.text,
                    fullName,
                    address,
                    city,
                    productName,
                    productPrice.toString(),
                    // Convert product price to string
                    businessName,
                    contactNumber,
                    sellerAddress,
                    sellerCity,
                    sellerProvince,
                  );

                  if (isSuccess) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OrderPlacedPage()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Payment failed. Expiry date has passed.'),
                    ));
                  }
                },
                child: Text('Pay Now'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderPlacedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[100],
      appBar: AppBar(
        backgroundColor: Colors.green[100],
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.check_circle_outline,
                color: Colors.white,
                size: 100,
              ),
              SizedBox(height: 20),
              Text(
                'Order Placed Successfully!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Your order has been successfully placed. Thank you for shopping with us!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(
                    context,
                    ModalRoute.withName(Navigator.defaultRouteName),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Colors.green[100],
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Continue Shopping',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
