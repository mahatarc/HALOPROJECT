import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Authentication
import 'package:flutterproject/features/seller%20mode/model/productmodel.dart';
import 'package:flutterproject/features/seller%20mode/presentation/Bloc/your_products_bloc/your_products_bloc.dart';
import 'package:flutterproject/features/seller%20mode/presentation/UI/add_products.dart';
import 'package:flutterproject/features/seller%20mode/presentation/UI/orders.dart'; // Import the order screen widget
import 'package:flutterproject/features/seller%20mode/presentation/UI/seller_drawer.dart';
import 'package:flutterproject/features/seller%20mode/presentation/UI/your_products.dart';

class SellerDashboard extends StatefulWidget {
  @override
  State<SellerDashboard> createState() => _SellerDashboardState();
}

class _SellerDashboardState extends State<SellerDashboard> {
  int currentIndex = 0;
  int totalProducts = 0;
  int totalOrders = 0;
  int totalSales = 0;
  String? businessName; // Define businessName here

  @override
  void initState() {
    super.initState();
    fetchSellerData();
  }

  Future<void> fetchSellerData() async {
    // Fetch the current user's ID from Firebase Authentication
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      List<ProductModel> productModelList = [];
      // Fetch total products count
      QuerySnapshot productsSnapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('user_id', isEqualTo: userId)
          .get();
      setState(() {
        totalProducts = productsSnapshot.docs.length;
      });

      // Fetch total orders count for the seller
      QuerySnapshot ordersSnapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('user_id', isEqualTo: userId)
          .get();
      setState(() {
        totalOrders = ordersSnapshot.docs.length;
      });

      // Fetch total sales
      int totalSalesAmount = 0;
      ordersSnapshot.docs.forEach((orderDoc) {
        int orderTotalAmount = orderDoc['total_amount'] ?? 0;
        totalSalesAmount += orderTotalAmount;
      });
      setState(() {
        totalSales = totalSalesAmount;
      });

      // Fetch business name (example)
      DocumentSnapshot sellerDoc = await FirebaseFirestore.instance
          .collection('sellers')
          .doc(userId)
          .get();
      setState(() {
        businessName = sellerDoc['businessName'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[200],
        title: Text('Seller Dashboard'),
      ),
      drawer: SellerDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildInfoBox('Products', totalProducts, Icons.shopping_cart,
                    Colors.green),
                _buildInfoBox(
                    'Orders', totalOrders, Icons.shopping_bag, Colors.green),
              ],
            ),
            SizedBox(height: 16.0),
            /* Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildInfoBox('Rating', 4, Icons.star,
                    Colors.green), // Assuming a constant rating for now
                _buildInfoBox('Total Sales', totalSales, Icons.monetization_on,
                    Colors.green),
              ],
            ),*/
            SizedBox(height: 25),
            Container(
              height: 250,
              width: double.infinity,
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 60,
                  ),
                  Text(
                    'Add your products here!',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddProduct()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 224, 246, 220),
                      onPrimary: const Color.fromARGB(255, 11, 3, 3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: Text('+ Add Product'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
          onDestinationSelected: (index) {
            setState(() {
              currentIndex = index;
              if (index == 1) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BlocProvider(
                              create: (context) => YourProductsBloc(),
                              child: YourProducts(),
                            )));
              }
              if (index == 2) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => OrderScreen(
                            businessName: businessName,
                          )),
                );
              }
            });
          },
          height: 70,
          elevation: 0,
          backgroundColor: Colors.green[100],
          destinations: [
            NavigationDestination(
                icon: const Icon(Icons.home), label: 'Dashboard'),
            NavigationDestination(
                icon: Icon(Icons.newspaper), label: 'Your Products'),
            NavigationDestination(
                icon: Icon(Icons.add_shopping_cart), label: 'Orders'),
          ]),
    );
  }

  Widget _buildInfoBox(String title, int count, IconData icon, Color color) {
    return Container(
      width: 150,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      padding: EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                count.toString(),
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Icon(
            icon,
            color: Colors.white,
            size: 30.0,
          ),
        ],
      ),
    );
  }
}
