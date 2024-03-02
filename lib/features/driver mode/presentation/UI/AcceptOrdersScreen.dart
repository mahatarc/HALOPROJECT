import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AcceptedOrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accepted Orders'),
        backgroundColor: Colors.green[100],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('accepted_orders')
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
            return Center(child: Text('No accepted orders available.'));
          }

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              var orderData = orders[index].data() as Map<String, dynamic>;
              return ListTile(
                title: Text('Order ID: ${orderData['orderNumber']}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Product Price: ${orderData['productName']}'),
                    Text('Product Name : ${orderData['amount']}'),
                    Text('Business Name: ${orderData['businessName']}'),
                    Text('Seller Address: ${orderData['sellerAddress']}'),
                    Text('deliveryLocation: ${orderData['customeraddress']}'),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
