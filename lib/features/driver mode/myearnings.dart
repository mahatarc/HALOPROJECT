import 'package:flutter/material.dart';
import 'package:flutterproject/features/driver%20mode/driver_profile.dart';
import 'package:flutterproject/features/driver%20mode/driverdashboard.dart';




Widget _buildOrderStatusCard(String title, String amount) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      color: Colors.lightGreen,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Column(
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
          ],
        ),
      ),
    );
  }


// Add MyEarningsPage widget
class MyEarningsPage extends StatelessWidget {
   @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 18),
            Text(
              'My Earnings',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildOrderStatusCard('Total Earnings Today', '\$100.00'),
            _buildOrderStatusCard('Total Earnings This Week', '\$500.00'),
            _buildOrderStatusCard('Total Earnings This Month', '\$2000.00'),
            _buildOrderStatusCard('Overall Total Earnings', '\$10000.00'),
          ],
        ),
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
            // Navigate to the Profile screen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DeliveryBoyDashboard()),
            );}
            else
          if (index == 2) {
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