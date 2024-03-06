import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderScreen extends StatelessWidget {
  final String? businessName;

  OrderScreen({this.businessName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[200],
        title: Text('Orders'),
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

              if (orderData['businessName'] != businessName) {
                return SizedBox
                    .shrink(); // Hide order if business names don't match
              }

              return FutureBuilder<List<DocumentSnapshot>>(
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

                  return Card(
                    margin:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order ID: ${orders[index].id}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          if (productDataList != null)
                            ...productDataList.map((productData) {
                              var product =
                                  productData.data() as Map<String, dynamic>;
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Product: ${product['name']}'),
                                  Text('Price: \$${product['price']}'),
                                  SizedBox(height: 8),
                                ],
                              );
                            }).toList(),
                          Text('Customer: ${orderData['customerName']}'),
                          // Text('Location: ${orderData['customeraddress']}'),
                          Text('Price: \$${orderData['amount'] ?? 'N/A'}'),
                          Text('productName: ${orderData['productName']}'),
                          Text('Payment Status: ${orderData['paymentStatus']}'),
                          SizedBox(height: 16),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<List<DocumentSnapshot>> _getProductDocuments(
      List? productIdList) async {
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
}
