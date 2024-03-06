import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterproject/features/driver%20mode/presentation/UI/AcceptOrdersScreen.dart';

class PendingOrdersPage extends StatefulWidget {
  @override
  _PendingOrdersPageState createState() => _PendingOrdersPageState();
}

class _PendingOrdersPageState extends State<PendingOrdersPage> {
  late List<DocumentSnapshot> pendingOrders;
  late List<Order> acceptedOrders = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pending Orders',
        ),
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
                elevation: 2,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                // color: Colors.green[200],
                child: InkWell(
                  onTap: () {
                    _showOrderOptions(context, orders[index].id as String);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /*Text(
                          'Order ID: ${orders[index].id}',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),*/
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
                                    Text('Price: \₹${productData['price']}'),
                                    SizedBox(height: 8),
                                  ],
                                );
                              },
                            );
                          }).toList(),
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
                        SizedBox(height: 10),
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
              title: Text('Accept Order'),
              onTap: () {
                Navigator.pop(context); // Close the modal
                _acceptOrder(context, orderId);
              },
            ),
            /*  ListTile(
              title: Text('Reject Order'),
              onTap: () {
                Navigator.pop(context); // Close the modal
                _rejectOrder(orderId);
              },
            ),*/
          ],
        );
      },
    );
  }

  void _acceptOrder(BuildContext context, String orderId) {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection('orders')
        .doc(orderId)
        .get()
        .then((orderSnapshot) {
      if (orderSnapshot.exists) {
        var orderData = orderSnapshot.data() as Map<String, dynamic>;

        // Store the entire order document in 'accepted_orders'
        FirebaseFirestore.instance
            .collection('accepted_orders')
            .doc(orderId)
            .set(orderData)
            .then((_) {
          // Remove the accepted order from the 'orders' collection
          orderSnapshot.reference.delete().then((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Order $orderId accepted'),
              ),
            );

            // After accepting the order, fetch the accepted orders
            _fetchAcceptedOrders(context);
          }).catchError((error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to delete order: $error'),
              ),
            );
          });
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to accept order: $error'),
            ),
          );
        });
      }
    }).catchError((error) {
      // Handle error fetching the order
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching order: $error'),
        ),
      );
    });
  }

  void _fetchAcceptedOrders(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AcceptedOrdersPage(userId: userId),
      ),
    );
  }

  void _rejectOrder(String orderId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Order $orderId rejected'),
      ),
    );
  }
}
