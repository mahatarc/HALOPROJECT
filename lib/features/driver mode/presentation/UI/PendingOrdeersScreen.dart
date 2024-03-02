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
                        Text(
                            'Customer Name: ${orderData['customerName'] ?? 'N/A'}'),
                        Text('Product Name: ${orderData['amount'] ?? 'N/A'}'),
                        Text('Price: \$${orderData['productName'] ?? 'N/A'}'),
                        Text(
                            'Customer Location: ${orderData['customeraddress']}'),
                        Text('Payment Status: ${orderData['paymentStatus']}'),
                        Text(
                          'Seller Information:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text('Business Name: ${orderData['businessName']}'),
                        Text('Seller Location: ${orderData['sellerAddress']}'),
                        Text('Seller Contact: ${orderData['contactNumber']}'),
                        Text('Seller City: ${orderData['sellerCity']}'),
                        Text('Seller Province: ${orderData['sellerProvince']}'),
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

  void _acceptOrder(BuildContext context, String orderId) {
    String driverId = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection('orders')
        .doc(orderId)
        .get()
        .then((orderSnapshot) {
      if (orderSnapshot.exists) {
        var orderData = orderSnapshot.data() as Map<String, dynamic>;

        // Store the accepted order in the 'accepted_orders' collection
        FirebaseFirestore.instance.collection('accepted_orders').add({
          'orderNumber': orderId,
          'productName': orderData['productName'],
          //'orderDate': orderData['orderDate'],
          'deliveryLocation': orderData['customeraddress'],
          'driverId': driverId,
        }).then((_) {
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
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => AcceptedOrdersPage(),
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

/*class Order {
  final String orderNumber;
  final String productName;
  final String customerName;
  final String customeraddress;
  final double amount;
  final String paymentStatus;
  final String businessName;
  final String sellerLocation;
  // final String sellerId;
  Order({
    required this.orderNumber,
    required this.productName,
    required this.customerName,
    required this.customeraddress,
    required this.amount,
    required this.paymentStatus,
    required this.businessName,
    required this.sellerLocation,
    //required this.sellerId,
  });

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      orderNumber: map['orderNumber'] ?? '',
      productName: map['productName'] ?? '',
      customerName: map['customerName'] ?? '',
      customeraddress: map['address'] ?? '',
      amount: map['amount'] != null ? map['amount'].toDouble() : 0.0,
      paymentStatus: map['paymentStatus'] ?? '',
      businessName: map['businessName'] ?? '',
      sellerLocation: map['sellerAddress'] ?? '',
      //  sellerId: map['sellerId'] ??'',
    );
  }
}*/