import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterproject/features/seller%20mode/presentation/Bloc/your_products_bloc/your_products_bloc.dart';
import 'package:flutterproject/features/seller%20mode/presentation/UI/add_products.dart';
import 'package:flutterproject/features/seller%20mode/presentation/UI/orders.dart';
import 'package:flutterproject/features/seller%20mode/presentation/UI/seller_drawer.dart';
import 'package:flutterproject/features/seller%20mode/presentation/UI/your_products.dart';

class SellerDashboard extends StatefulWidget {
  @override
  State<SellerDashboard> createState() => _SellerDashboardState();
}

class _SellerDashboardState extends State<SellerDashboard> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[200],
        title: Text('Seller Dashboard'),
        // automaticallyImplyLeading: false,
      ),
      drawer: SellerDrawer(), // Add the drawer here
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildInfoBox(
                    'Products', 100, Icons.shopping_cart, Colors.green),
                _buildInfoBox('Orders', 50, Icons.shopping_bag, Colors.green),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildInfoBox('Rating', 4, Icons.star, Colors.green),
                _buildInfoBox(
                    'Total Sales', 1000, Icons.monetization_on, Colors.green),
              ],
            ),
            SizedBox(height: 16.0),
            // Container for adding products
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              child: Column(
                children: [
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
                      primary: Color.fromARGB(
                          255, 224, 246, 220), // Change the background color
                      onPrimary: const Color.fromARGB(
                          255, 11, 3, 3), // Change the text color
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
                  MaterialPageRoute(builder: (context) => OrderScreen()),
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
      width: 150, // Adjust the width as needed
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
