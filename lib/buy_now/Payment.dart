import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentService {
  Future<bool> processPayment({
    required String cardNumber,
    required String cvv,
    required String expiryDate,
    required String fullName,
    required String address,
    required String city,
    required String productPrice,
    required String productName,
    required String? businessName,
    required String? contactNumber,
    required String? sellerAddress,
    required String? sellerCity,
    required String? sellerProvince,
  }) async {
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
        'sellerAddress': sellerAddress,
        'sellerCity': sellerCity,
        'sellerProvince': sellerProvince,
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

class PaymentPage extends StatelessWidget {
  // final PaymentService paymentService = PaymentService();
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

  PaymentPage({
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[100],
        title: Text('Choose Payment Method'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                launch('https://esewa.com.np/');
              },
              child: Text('Pay through e-sewa'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CardPaymentScreen(
                            fullName: fullName,
                            address: address,
                            city: city,
                            productName: productName,
                            productPrice: productPrice,
                            productPicture: productPicture,
                            businessName: businessName,
                            contactNumber: contactNumber,
                            sellerAddress: sellerAddress,
                            sellerCity: sellerCity,
                            sellerProvince: sellerProvince,
                          )),
                );
              },
              child: Text('Pay through Credit/Debit Card'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => OrderPlacedPage()),
                );
              },
              child: Text('Pay on Delivery'),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
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
  String? expiryDateError;

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
                    cardNumber: cardNumberController.text,
                    cvv: cvvController.text,
                    expiryDate: expiryDateController.text,
                    fullName: fullName,
                    address: address,
                    city: city,
                    productName: productName,
                    productPrice: productPrice.toString(),
                    businessName: businessName,
                    contactNumber: contactNumber,
                    sellerAddress: sellerAddress,
                    sellerCity: sellerCity,
                    sellerProvince: sellerProvince,
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
