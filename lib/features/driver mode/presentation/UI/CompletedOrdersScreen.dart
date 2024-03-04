import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CompletedOrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'History',
          /*style: GoogleFonts.acme(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),*/
        ),
        backgroundColor: Colors.green[100],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('completed_orders')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final orders = snapshot.data!.docs;
          if (orders.isEmpty) {
            return Center(child: Text('No completed orders available.'));
          }

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              var orderData = orders[index].data() as Map<String, dynamic>;
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Customer Information:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                          'Customer Name: ${orderData['customerName'] ?? 'N/A'}'),
                      Text('Product Name: ${orderData['amount'] ?? 'N/A'}'),
                      Text('Price: \रु ${orderData['productName'] ?? 'N/A'}'),
                      Text(
                          'Customer Location: ${orderData['customeraddress'] ?? 'N/A'}'),
                      Text(
                          'Payment Status: ${orderData['paymentStatus'] ?? 'N/A'}'),
                      SizedBox(height: 10),
                      Text(
                        'Seller Information:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                          'Business Name: ${orderData['businessName'] ?? 'N/A'}'),
                      Text(
                          'Seller Location: ${orderData['sellerAddress'] ?? 'N/A'}'),
                      Text(
                          'Seller Contact: ${orderData['contactNumber'] ?? 'N/A'}'),
                      Text('Seller City: ${orderData['sellerCity'] ?? 'N/A'}'),
                      Text(
                          'Seller Province: ${orderData['sellerProvince'] ?? 'N/A'}'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
