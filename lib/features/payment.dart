import 'package:flutter/material.dart';

class Payment extends StatelessWidget {
  const Payment({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Select Payment Method'),
        backgroundColor: Colors.green[100],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 60,
              child: GestureDetector(
                onTap: () {
                  // Navigate to Credit/Debit Card payment screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CardPaymentScreen()),
                  );
                },
                child: Container(
                  // color: Colors.white,
                  decoration: BoxDecoration(
                    border: Border.all(color: Color.fromARGB(255, 75, 74, 74)),
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.credit_card),
                      SizedBox(width: 10),
                      Text('Online Payment'),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 60,
              child: GestureDetector(
                onTap: () {
                  // Navigate to Pay on Delivery screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PayOnDeliveryScreen()),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromARGB(255, 69, 68, 68)),
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.local_shipping),
                      SizedBox(width: 10),
                      Text('Pay on Delivery'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CardPaymentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Credit/Debit Card Payment'),
      ),
      body: Center(
        child: Text('Enter credit/debit card details here'),
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
