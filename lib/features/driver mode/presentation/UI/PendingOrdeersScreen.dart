import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PendingOrdersPage extends StatefulWidget {
  @override
  _PendingOrdersPageState createState() => _PendingOrdersPageState();
}

class _PendingOrdersPageState extends State<PendingOrdersPage> {
  late List<DocumentSnapshot> pendingOrders;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pending Orders'),
        backgroundColor: Colors.green[100],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('orders').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final orders = snapshot.data!.docs;
          pendingOrders = orders;

          if (orders.isEmpty) {
            return Center(child: Text('No orders available.'));
          }

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              var orderData = orders[index].data() as Map<String, dynamic>;
              var productIdList = orderData['productIdList'] as List?;

              return Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 8.0),
                color: Colors.green[200],
                child: InkWell(
                  onTap: () {
                    _showOrderOptions(context, orders[index].id as String);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order ID: ${orders[index].id}',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        if (productIdList != null)
                          ...productIdList.map((productId) {
                            return FutureBuilder<DocumentSnapshot>(
                              future: FirebaseFirestore.instance
                                  .collection('products')
                                  .doc(productId)
                                  .get(),
                              builder: (context, productSnapshot) {
                                if (productSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                }

                                if (productSnapshot.hasError) {
                                  return Text(
                                      'Error: ${productSnapshot.error}');
                                }

                                var productData = productSnapshot.data!.data()
                                    as Map<String, dynamic>;
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Product: ${productData['name']}'),
                                    Text('Price: \$${productData['price']}'),
                                    SizedBox(height: 8),
                                  ],
                                );
                              },
                            );
                          }).toList(),
                        Text('Customer: ${orderData['customerName']}'),
                        Text('Location: ${orderData['address']}'),
                        Text('Price: \$${orderData['amount'] ?? 'N/A'}'),
                        Text('Payment Status: ${orderData['paymentStatus']}'),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showOrderOptions(BuildContext context, String orderId) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Accept Order'),
              onTap: () {
                Navigator.pop(context); // Close the modal
                _acceptOrder(orderId);
              },
            ),
            ListTile(
              title: Text('Reject Order'),
              onTap: () {
                Navigator.pop(context); // Close the modal
                _rejectOrder(orderId);
              },
            ),
          ],
        );
      },
    );
  }

  void _acceptOrder(String orderId) {
    // Implement accept order functionality
    // Show pop-up message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Order $orderId accepted'),
      ),
    );
  }

  void _rejectOrder(String orderId) {
    // Implement reject order functionality
    // Show pop-up message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Order $orderId rejected'),
      ),
    );
  }
}
