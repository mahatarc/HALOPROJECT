import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderScreen extends StatelessWidget {
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
