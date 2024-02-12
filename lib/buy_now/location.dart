import 'package:flutter/material.dart';
import 'package:flutterproject/buy_now/Payment.dart';

class DeliveryAddressScreen extends StatefulWidget {
  @override
  _DeliveryAddressScreenState createState() => _DeliveryAddressScreenState();
}

class _DeliveryAddressScreenState extends State<DeliveryAddressScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController addressLine1Controller = TextEditingController();
  final TextEditingController addressLine2Controller = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  bool _isFormValid() {
    return fullNameController.text.isNotEmpty &&
        addressLine1Controller.text.isNotEmpty &&
        cityController.text.isNotEmpty;
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
            ),
            SizedBox(height: 10),
            TextField(
              controller: addressLine1Controller,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(labelText: 'Address '),
            ),
            SizedBox(height: 10),
            TextField(
              controller: cityController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(labelText: 'City'),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(labelText: 'Postal Code'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isFormValid()
                  ? () {
                      // Navigate to Payment screen after entering delivery address
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Payment()),
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
                    border: Border.all(color: Color.fromARGB(255, 79, 214, 86)),
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
