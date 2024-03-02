import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterproject/buy_now/location.dart';
import 'package:flutterproject/features/seller%20mode/model/sellermodel.dart';

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
      this.product_detail_details});

  @override
  State<ProductsDetails> createState() => _ProductsDetailsState();
}

class _ProductsDetailsState extends State<ProductsDetails> {
  int myIndex = 0;
  int selectedQuantity = 1;
  Seller? _seller;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchSellerDetails();
  }

  Future<void> _fetchSellerDetails() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final productDoc = await FirebaseFirestore.instance
          .collection('products')
          .doc(widget.product_detail_id)
          .get();

      if (productDoc.exists) {
        final sellerId = productDoc.data()?['user_id'];

        final sellerDoc = await FirebaseFirestore.instance
            .collection('sellers')
            .doc(sellerId)
            .get();

        if (sellerDoc.exists) {
          setState(() {
            _seller = Seller.fromMap(sellerDoc.data() as Map<String, dynamic>);
          });
        } else {
          print('Seller document does not exist.');
        }
      } else {
        print('Product document does not exist.');
      }
    } catch (error) {
      print('Error fetching seller details: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget buildSellerInformationSection() {
    if (_isLoading) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: CircularProgressIndicator(),
      );
    } else if (_seller != null) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Seller Information:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('Business Name: ${_seller?.businessName ?? 'N/A'}'),
            Text('Contact Number: ${_seller?.contactNumber ?? 'N/A'}'),
            Text('Address: ${_seller?.address ?? 'N/A'}'),
            Text('City: ${_seller?.city ?? 'N/A'}'),
            Text('Province: ${_seller?.province ?? 'N/A'}'),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'Seller Information not available',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      );
    }
  }

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Product Description:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.product_detail_details,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          // Seller information section
          buildSellerInformationSection(),
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
                            businessName: _seller?.businessName,
                            contactNumber: _seller?.contactNumber,
                            address: _seller?.address,
                            city: _seller?.city,
                            province: _seller?.province,
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
