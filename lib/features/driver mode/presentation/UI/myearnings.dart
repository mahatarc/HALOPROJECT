import 'package:flutter/material.dart';
import 'package:flutterproject/features/driver%20mode/presentation/UI/driver_profile.dart';
import 'package:flutterproject/features/driver%20mode/presentation/UI/driverdashboard.dart';

// Function to build the earnings card
Widget _buildOrderStatusCard(String title, String amount) {
  return Card(
    elevation: 4,
    margin: EdgeInsets.symmetric(vertical: 8.0),
    color: Colors.green[200],
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            amount,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    ),
  );
}

class MyEarningsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 228, 234, 232),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor:
            Colors.green[100], // Change the background color of the app bar
        title: Text('My Earnings'),
      ),
      body: ListView(
        // Use ListView instead of SingleChildScrollView for better scrolling
        padding: EdgeInsets.all(16.0),
        children: [
          SizedBox(height: 5),
          _buildOrderStatusCard('Total Earnings Today', '\$100.00'),
          Divider(),
          _buildOrderStatusCard('Total Earnings This Week', '\$500.00'),
          Divider(),
          _buildOrderStatusCard('Total Earnings This Month', '\$2000.00'),
          Divider(),
          _buildOrderStatusCard('Overall Total Earnings', '\$10000.00'),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on),
            label: 'My Earnings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          // Handle tap on BottomNavigationBar items
          if (index == 0) {
            // Navigate to the Dashboard screen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DeliveryBoyDashboard()),
            );
          } else if (index == 2) {
            // Navigate to the Profile screen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DeliveryBoyProfile()),
            );
          }
        },
      ),
    );
  }
}
