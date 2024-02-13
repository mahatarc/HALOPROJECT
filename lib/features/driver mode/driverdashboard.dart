import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutterproject/features/driver%20mode/CompletedOrdersScreen.dart';
import 'package:flutterproject/features/driver%20mode/driver_profile.dart';
import 'package:flutterproject/features/driver%20mode/myearnings.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DeliveryBoyDashboard(),
    );
  }
}

class DeliveryBoyDashboard extends StatefulWidget {
  @override
  _DeliveryBoyDashboardState createState() => _DeliveryBoyDashboardState();
}

class _DeliveryBoyDashboardState extends State<DeliveryBoyDashboard> {
  bool isAvailable = true; // Default value

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 32),
            Text(
              'Welcome, Delivery Boy!',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            SwitchListTile(
              title: Text(
                isAvailable ? 'You are Available' : 'You are Not Available',
                style: TextStyle(fontSize: 20),
              ),
              value: isAvailable,
              onChanged: (value) {
                setState(() {
                  isAvailable = value;
                });
              },
              activeColor: Color.fromARGB(255, 26, 157, 31),
              inactiveTrackColor: Colors.red,
            ),
            SizedBox(height: 32),
            Text(
              'Today Orders',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildOrderStatusCard('Accept Orders', 3, () {
                  // Navigate to the Accept Orders screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AcceptOrdersScreen()),
                  );
                }),
                _buildOrderStatusCard('Pending Orders', 6, () {
                  // Navigate to the Pending Orders screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PendingOrdersScreen()),
                  );
                }),
              ],
            ),
            SizedBox(height: 18),
            Column(
              children: [
                _buildOrderStatusCard('Completed Orders', 5, () {
                  // Navigate to the Completed Orders screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CompletedOrdersPage()),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // Default selected tab
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
  
  if (index == 0) {  
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DeliveryBoyDashboard()),  
    );
  } else
  if (index == 1) {  
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyEarningsPage()),  
    );
  } else if (index == 2) {  
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DeliveryBoyProfile()),
    );
  }
},
      ),
    );
  }

  Widget _buildOrderStatusCard(String title, int count, VoidCallback onPressed) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      color: Colors.lightGreen,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 40),
              ],
            ),
          ),
          Positioned(
            bottom: 9,
            right: 9,
            child: CircleAvatar(
              radius: 10,
              backgroundColor: Color.fromARGB(255, 223, 114, 114),
              child: Text(
                '$count',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onPressed,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AcceptOrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accept Orders'),
      ),
      body: Center(
        child: Text('Accept Orders Screen'),
      ),
    );
  }
}

class PendingOrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pending Orders'),
      ),
      body: Center(
        child: Text('Pending Orders Screen'),
      ),
    );
  }
}

class CompletedOrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Completed Orders'),
      ),
      body: Center(
        child: Text('Completed Orders Screen'),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Text('Profile Screen'),
      ),
    );
  }
}
