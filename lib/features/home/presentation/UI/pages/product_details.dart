import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterproject/buy_now/location.dart';

class ProductsDetails extends StatefulWidget {
  final product_detail_id;
  final product_detail_name;
  final product_detail_price;
  final product_detail_picture;
  final product_detail_details;

  ProductsDetails(
      {this.product_detail_id,
      this.product_detail_name,
      this.product_detail_price,
      this.product_detail_picture,
      this.product_detail_details, Map<String, dynamic>? product});

  @override
  State<ProductsDetails> createState() => _ProductsDetailsState();
}

class _ProductsDetailsState extends State<ProductsDetails> {
  int myIndex = 0;
  int selectedQuantity = 1;

  @override
  Widget build(BuildContext context) {
    final double productPrice =
        double.parse(widget.product_detail_price.toString());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[200],
        title: Text('Product Details'),
      ),
      body: ListView(
        children: [
          // Product image and details section
          Container(
            height: 300,
            child: GridTile(
              child: Container(
                color: Colors.white,
                child: Image.network(
                  widget.product_detail_picture,
                  fit: BoxFit.contain,
                ),
              ),
              footer: Container(
                color: Colors.white60,
                child: ListTile(
                  leading: Text(
                    widget.product_detail_name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Text(
                          "\₹$productPrice",
                          style: TextStyle(
                            color: Colors.brown,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Quantity selection row
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                    // border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Row(
                    children: [
                      Expanded(child: Text("Quantity")),
                      DropdownButton<int>(
                        value: selectedQuantity,
                        items: List.generate(10, (index) => index + 1)
                            .map((quantity) => DropdownMenuItem<int>(
                                  value: quantity,
                                  child: Text('$quantity'),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedQuantity = value ?? 1;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Product description
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Product Description:\nThis is a high-quality product with a detailed description.',
              style: TextStyle(fontSize: 16),
            ),
          ),
          // Customer Reviews
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Customer Reviews',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                ListTile(
                  title: Text('Alpha'),
                  subtitle: Text('Excellent product!'),
                  trailing: Icon(Icons.star, color: Colors.yellow),
                ),
                ListTile(
                  title: Text('Beta'),
                  subtitle: Text('Very satisfied with the purchase.'),
                  trailing: Icon(Icons.star, color: Colors.yellow),
                ),
              ],
            ),
          ),
          // Related Products Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Related Products',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.green[100],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // "Buy Now" button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DeliveryAddressScreen(
                            product_detail_name: widget.product_detail_name,
                            product_detail_price: widget.product_detail_price,
                            product_detail_picture:
                                widget.product_detail_picture,
                            //     product_detail_details:
                            //    widget.product_detail_details,
                          )),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              child: Text(
                'Buy Now',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            // "Add to Cart" button
            ElevatedButton(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                await FirebaseFirestore.instance
                    .collection('carts')
                    .doc(user!.uid)
                    .collection(user.uid)
                    .doc(widget.product_detail_id)
                    .set({'count': selectedQuantity});
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Item added successfully.'),
                      );
                    });
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              child: Text(
                'Add to Cart',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
