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
                              text: '${orderData['customeraddress'] ?? 'N/A'}',
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
                              text: '${orderData['sellerCity'] ?? 'Kathmandu'}',
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
              );
            },
          );
        },
      ),
    );
  }
}
