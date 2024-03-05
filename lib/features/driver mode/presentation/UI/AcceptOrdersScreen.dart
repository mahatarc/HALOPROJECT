import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AcceptedOrdersPage extends StatelessWidget {
  final String? userId;

  const AcceptedOrdersPage({this.userId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Accepted Orders',
        ),
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
              return GestureDetector(
                onTap: () {
                  _showOrderOptions(context, orders[index].id);
                },
                child: Card(
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
                        Text.rich(
                          TextSpan(
                            text: 'Customer Name: ',
                            style: TextStyle(fontWeight: FontWeight.w500),
                            children: <TextSpan>[
                              TextSpan(
                                text: '${orderData['customerName'] ?? 'N/A'}',
                                style: TextStyle(
                                    fontWeight: FontWeight
                                        .normal), // Non-bold style for children text
                              ),
                            ],
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            text: 'Product Name: ',
                            style: TextStyle(fontWeight: FontWeight.w500),
                            children: <TextSpan>[
                              TextSpan(
                                text: '${orderData['productName'] ?? 'N/A'}',
                                style: TextStyle(
                                    fontWeight: FontWeight
                                        .normal), // Non-bold style for children text
                              ),
                            ],
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            text: 'Price: \रु ',
                            style: TextStyle(fontWeight: FontWeight.w500),
                            children: <TextSpan>[
                              TextSpan(
                                text: '${orderData['amount'] ?? 'N/A'}',
                                style: TextStyle(
                                    fontWeight: FontWeight
                                        .normal), // Non-bold style for children text
                              ),
                            ],
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            text: 'Customer Location: ',
                            style: TextStyle(fontWeight: FontWeight.w500),
                            children: <TextSpan>[
                              TextSpan(
                                text:
                                    '${orderData['customeraddress'] ?? 'N/A'}',
                                style: TextStyle(
                                    fontWeight: FontWeight
                                        .normal), // Non-bold style for children text
                              ),
                            ],
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            text: 'Payment Status: ',
                            style: TextStyle(fontWeight: FontWeight.w500),
                            children: <TextSpan>[
                              TextSpan(
                                text: '${orderData['paymentStatus'] ?? 'N/A'}',
                                style: TextStyle(
                                    fontWeight: FontWeight
                                        .normal), // Non-bold style for children text
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'Seller Information:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text.rich(
                          TextSpan(
                            text: 'Business Name: ',
                            style: TextStyle(fontWeight: FontWeight.w500),
                            children: <TextSpan>[
                              TextSpan(
                                text:
                                    '${orderData['businessName'] ?? 'Agro Market'}',
                                style: TextStyle(
                                    fontWeight: FontWeight
                                        .normal), // Non-bold style for children text
                              ),
                            ],
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            text: 'Seller Location: ',
                            style: TextStyle(fontWeight: FontWeight.w500),
                            children: <TextSpan>[
                              TextSpan(
                                text:
                                    '${orderData['sellerAddress'] ?? 'Kalimati'}',
                                style: TextStyle(
                                    fontWeight: FontWeight
                                        .normal), // Non-bold style for children text
                              ),
                            ],
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            text: 'Seller Contact: ',
                            style: TextStyle(fontWeight: FontWeight.w500),
                            children: <TextSpan>[
                              TextSpan(
                                text:
                                    '${orderData['contactNumber'] ?? '9851098124'}',
                                style: TextStyle(
                                    fontWeight: FontWeight
                                        .normal), // Non-bold style for children text
                              ),
                            ],
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            text: 'Seller City: ',
                            style: TextStyle(fontWeight: FontWeight.w500),
                            children: <TextSpan>[
                              TextSpan(
                                text:
                                    '${orderData['sellerCity'] ?? 'Kathmandu'}',
                                style: TextStyle(
                                    fontWeight: FontWeight
                                        .normal), // Non-bold style for children text
                              ),
                            ],
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            text: 'Seller Province: ',
                            style: TextStyle(fontWeight: FontWeight.w500),
                            children: <TextSpan>[
                              TextSpan(
                                text: '${orderData['sellerProvince'] ?? '3'}',
                                style: TextStyle(
                                    fontWeight: FontWeight
                                        .normal), // Non-bold style for children text
                              ),
                            ],
                          ),
                        ),
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
              title: Text('Confirm Delivery'),
              onTap: () {
                Navigator.pop(context); // Close the modal
                _confirmDelivery(orderId, context);
              },
            ),
            ListTile(
              title: Text('Reject Order'),
              onTap: () {
                Navigator.pop(context); // Close the modal
                _rejectOrder(orderId, context);
              },
            ),
          ],
        );
      },
    );
  }

  void _confirmDelivery(String orderId, BuildContext context) {
    FirebaseFirestore.instance
        .collection('accepted_orders')
        .doc(orderId)
        .get()
        .then((orderSnapshot) {
      if (orderSnapshot.exists) {
        var orderData = orderSnapshot.data() as Map<String, dynamic>;

        // Transfer order to completed_orders collection
        FirebaseFirestore.instance
            .collection('completed_orders')
            .doc(orderId)
            .set(orderData)
            .then((_) {
          // Delete order from accepted_orders collection
          orderSnapshot.reference.delete().then((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    'Order $orderId confirmed and moved to completed orders'),
              ),
            );
          }).catchError((error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error deleting order: $error'),
              ),
            );
          });
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error transferring order: $error'),
            ),
          );
        });
      }
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching order: $error'),
        ),
      );
    });
  }

  void _rejectOrder(String orderId, BuildContext context) {
    FirebaseFirestore.instance
        .collection('accepted_orders')
        .doc(orderId)
        .get()
        .then((orderSnapshot) {
      if (orderSnapshot.exists) {
        var orderData = orderSnapshot.data() as Map<String, dynamic>;

        FirebaseFirestore.instance
            .collection('orders')
            .doc(orderId)
            .set(orderData)
            .then((_) {
          orderSnapshot.reference.delete().then((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Order $orderId rejected and transferred'),
              ),
            );
          }).catchError((error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error deleting order: $error'),
              ),
            );
          });
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error transferring order: $error'),
            ),
          );
        });
      }
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching order: $error'),
        ),
      );
    });
  }
}
