import 'package:flutter/material.dart';

import 'package:flutterproject/features/userauth/presenation/pages/seller%20mode/add_products.dart';
import 'package:flutterproject/features/userauth/presenation/pages/seller%20mode/seller_drawer.dart';

class SellerDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[200],
        title: Text('Seller Dashboard'),
      ),
      drawer: SellerDrawer(),
      body: Container(
        height: 900,
        margin: EdgeInsets.all(16.0),
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.green[100],
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 500,
                  margin: EdgeInsets.only(bottom: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Products',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddProduct()));
                          },
                          style: ElevatedButton.styleFrom(
                              primary: Color.fromARGB(255, 224, 246,
                                  220), // Change the background color
                              onPrimary: const Color.fromARGB(
                                  255, 11, 3, 3), // Change the text color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              )),
                          child: Text('+ Add Product'),
                        ),
                      ],
                    ),
                  ),
                ),
                /*  Container(
                  child: Text(
                    'Order Management',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('View Orders'),
                ),
                SizedBox(height: 32),
                Text(
                  'Product Management',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to product listing screen
                    /* Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductListingScreen()),
                    );*/
                  },
                  child: Text('Manage Products'),
                ),
                SizedBox(height: 32),
                Text(
                  'Analytics',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to analytics screen
                    /*   Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AnalyticsScreen()),
                    );*/
                  },
                  child: Text('View Analytics'),
                ),
                SizedBox(height: 32),*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Remaining screen classes remain unchanged.
