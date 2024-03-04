import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterproject/buy_now/location.dart';
import 'package:flutterproject/features/seller%20mode/model/sellermodel.dart';

class ProductsDetails extends StatefulWidget {
  final String product_detail_id;
  final String product_detail_name;
  final String product_detail_price;
  final String product_detail_picture;
  final String product_detail_details;
  final Map<String, dynamic>? seller;

  ProductsDetails({
    required this.product_detail_id,
    required this.product_detail_name,
    required this.product_detail_price,
    required this.product_detail_picture,
    required this.product_detail_details,
    this.seller,
  });

  @override
  _ProductsDetailsState createState() => _ProductsDetailsState();
}

class _ProductsDetailsState extends State<ProductsDetails> {
  int myIndex = 0;
  int selectedQuantity = 1;
  Seller? _seller;
  bool _isLoading = false;
  List<Map<String, dynamic>> _reviews = [];
  TextEditingController _reviewController = TextEditingController();
  int _selectedRating = 5;

  @override
  void initState() {
    super.initState();
    if (widget.seller != null) {
      _seller = Seller.fromMap(widget.seller!);
    } else {
      _fetchSellerDetails();
    }

    _fetchReviews();
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

  Future<void> _fetchReviews() async {
    try {
      final reviewsSnapshot = await FirebaseFirestore.instance
          .collection('product_reviews')
          .doc(widget.product_detail_id)
          .collection('reviews')
          .get();

      setState(() {
        _reviews = reviewsSnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
      });
    } catch (error) {
      print('Error fetching reviews: $error');
    }
  }

  // Submit review
  Future<void> _submitReview() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final review = _reviewController.text;
      final rating = _selectedRating;

      try {
        final userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        await FirebaseFirestore.instance
            .collection('product_reviews')
            .doc(widget.product_detail_id)
            .collection('reviews')
            .add({
          'author': userData.data()?['name'] ?? 'Anonymous',
          'review': review,
          'rating': rating,
          'timestamp': Timestamp.now(),
        });

        // Clear the input field after submitting
        _reviewController.clear();

        // Fetch reviews again to update the list
        _fetchReviews();
      } catch (error) {
        print('Error submitting review: $error');
      }
    } else {
      // Handle the case when the user is not authenticated
      print('User not authenticated');
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
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              'Business Name: ${_seller?.businessName ?? 'N/A'}',
            ),
            Text(
              'Contact Number: ${_seller?.contactNumber ?? 'N/A'}',
            ),
            Text(
              'Address: ${_seller?.address ?? 'N/A'}',
            ),
            Text(
              'City: ${_seller?.city ?? 'N/A'}',
            ),
            Text(
              'Province: ${_seller?.province ?? 'N/A'}',
            ),
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

  // Build reviews section
  Widget buildReviewsSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Customer Reviews',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          _reviews.isEmpty
              ? Text('No reviews yet')
              : Column(
                  children: _reviews.map((review) {
                    return ListTile(
                      title: Text(review['author'] ?? 'Anonymous'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(review['review'] ?? ''),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.yellow,
                              ),
                              Text(review['rating'].toString()),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
          SizedBox(height: 16.0),
          // Input for new review
          Text(
            'Leave a Review',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          TextField(
            controller: _reviewController,
            decoration: InputDecoration(
              hintText: 'Enter your review',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          SizedBox(height: 8.0),
          DropdownButton<int>(
            value: _selectedRating,
            items: List.generate(5, (index) => index + 1)
                .map((rating) => DropdownMenuItem<int>(
                      value: rating,
                      child: Text('$rating stars'),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedRating = value ?? 5;
              });
            },
          ),
          SizedBox(height: 8.0),
          ElevatedButton(
            onPressed: _submitReview,
            style: ElevatedButton.styleFrom(
              primary: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            child: Text(
              'Submit Review',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double productPrice =
        double.parse(widget.product_detail_price.toString());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[100],
        title: Text(
          'Product Details',
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Container(
            height: 300,
            child: GridTile(
              child: Image.network(
                widget.product_detail_picture,
                fit: BoxFit.cover,
              ),
              footer: Container(
                color: Colors.white.withOpacity(0.6),
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product_detail_name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "\₹$productPrice",
                      style: TextStyle(
                        color: Colors.brown,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                            Expanded(
                                child: Text(
                              "Quantity",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            )),
                            SizedBox(width: 5),
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
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Product Description:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    widget.product_detail_details,
                  ),
                ),
                buildSellerInformationSection(),
                buildReviewsSection(),
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DeliveryAddressScreen(
                                      product_detail_name:
                                          widget.product_detail_name,
                                      product_detail_price:
                                          widget.product_detail_price,
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
