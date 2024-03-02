import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PendingOrdersPage extends StatefulWidget {
  @override
  _PendingOrdersPageState createState() => _PendingOrdersPageState();
}

class _PendingOrdersPageState extends State<PendingOrdersPage> {
  final List<Order> pendingOrders = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pending Orders'),
        backgroundColor: Color.fromARGB(255, 155, 229, 123),
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

          if (orders.isEmpty) {
            return Center(child: Text('No orders available.'));
          }

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              var orderData = orders[index].data() as Map<String, dynamic>;
              var productIdList = orderData['productIdList'] as List?;

              return GestureDetector(
                onTap: () {
                  // Call function to show options for the tapped order
                  _showOrderOptions(
                      context,
                      Order(
                        orderData['orderNumber'],
                        orderData['productNames'],
                        orderData['placementDate'],
                      ));
                },
                child: FutureBuilder<List<DocumentSnapshot>>(
                  future: _getProductDocuments(productIdList),
                  builder: (context, productSnapshot) {
                    if (productSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (productSnapshot.hasError) {
                      return Center(
                          child: Text('Error: ${productSnapshot.error}'));
                    }

                    var productDataList = productSnapshot.data;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text('Order ID: ${orders[index].id}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (productDataList != null)
                                ...productDataList.map((productData) {
                                  var product = productData.data()
                                      as Map<String, dynamic>;
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Product: ${product['name']}'),
                                      Text('Price: \$${product['price']}'),
                                      SizedBox(height: 8),
                                    ],
                                  );
                                }).toList(),
                              Text('Customer: ${orderData['customerName']}'),
                              Text('Location: ${orderData['address']}'),
                              Text(
                                  'Price: \$${orderData['amount'] ?? 'N/A'}'), // Use 'totalAmount' with a fallback value of 'N/A' if it's null
                              Text(
                                  'Payment Status: ${orderData['paymentStatus']}'),
                              SizedBox(height: 16),
                            ],
                          ),
                        ),
                        Divider(), // Add a Divider between each order
                      ],
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showOrderOptions(BuildContext context, Order order) {
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
                _acceptOrder(order);
              },
            ),
            ListTile(
              title: Text('Reject Order'),
              onTap: () {
                Navigator.pop(context); // Close the modal
                _rejectOrder(order);
              },
            ),
          ],
        );
      },
    );
  }

  void _acceptOrder(Order order) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AcceptOrderScreen(order),
      ),
    );
  }

  void _rejectOrder(Order order) {
    setState(() {
      pendingOrders.remove(order);
    });
  }
}

class Order {
  final String orderNumber;
  final String productNames;
  final String placementDate;

  Order(this.orderNumber, this.productNames, this.placementDate);
}

class AcceptOrderScreen extends StatelessWidget {
  final Order order;

  AcceptOrderScreen(this.order);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accept Order'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Order Number: ${order.orderNumber}'),
            Text('Products: ${order.productNames}'),
            Text('Placed on: ${order.placementDate}'),
            // Add more details or actions as needed
          ],
        ),
      ),
    );
  }
}

Future<List<DocumentSnapshot>> _getProductDocuments(List? productIdList) async {
  if (productIdList == null || productIdList.isEmpty) {
    return []; // Return an empty list if productIdList is null or empty
  }

  var productDocuments = <DocumentSnapshot>[];
  for (var productId in productIdList) {
    var productDocument = await FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .get();
    productDocuments.add(productDocument);
  }

  return productDocuments;
}
