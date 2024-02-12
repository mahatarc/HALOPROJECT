import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PaymentService {
  Future<bool> processPayment(
      String cardNumber, String cvv, String expiryDate) async {
    await Future.delayed(Duration(seconds: 2));

    if (_isExpired(expiryDate)) {
      return false;
    }

    return true;
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

                  bool isSuccess = await paymentService.processPayment(
                    cardNumberController.text,
                    cvvController.text,
                    expiryDateController.text,
                  );

                  if (isSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Payment successful!'),
                    ));
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
