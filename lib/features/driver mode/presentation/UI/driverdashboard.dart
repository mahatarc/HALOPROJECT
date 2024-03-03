import 'package:flutter/material.dart';
import 'package:flutterproject/features/driver%20mode/presentation/UI/AcceptOrdersScreen.dart';
import 'package:flutterproject/features/driver%20mode/presentation/UI/CompletedOrdersScreen.dart';
import 'package:flutterproject/features/driver%20mode/presentation/UI/PendingOrdeersScreen.dart';
import 'package:flutterproject/features/driver%20mode/presentation/UI/driver_drawer.dart';
import 'package:google_fonts/google_fonts.dart';

class DeliveryBoyDashboard extends StatefulWidget {
  @override
  _DeliveryBoyDashboardState createState() => _DeliveryBoyDashboardState();
}

class _DeliveryBoyDashboardState extends State<DeliveryBoyDashboard> {
  bool isAvailable = true; // Default value

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DriverDrawer(),
      backgroundColor: Color.fromARGB(255, 228, 234, 232),
      appBar: AppBar(
        backgroundColor: Colors.green[100],
        title: Text(
          "Driver Dashboard",
          style: GoogleFonts.acme(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, Delivery Boy!',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            /* SwitchListTile(
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
              inactiveTrackColor: Colors.grey,
            ),*/
            SizedBox(height: 5),
            Divider(),
            SizedBox(height: 10),
            Text(
              'Today Orders',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: _buildOrderStatusCard('Accept Orders', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AcceptedOrdersPage(),
                      ),
                    );
                  }),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildOrderStatusCard('Pending Orders', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PendingOrdersPage(),
                      ),
                    );
                  }),
                ),
              ],
            ),
            SizedBox(height: 18),
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
            icon: Icon(Icons.check_box_rounded),
            label: 'History',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DeliveryBoyDashboard()),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CompletedOrdersPage()),
            );
          }
        },
      ),
    );
  }

  Widget _buildOrderStatusCard(String title, VoidCallback onPressed) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      color: Colors.green[200],
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
          /* Positioned(
            bottom: 9,
            right: 9,
           /* child: CircleAvatar(
              radius: 10,
              backgroundColor: Color.fromARGB(255, 223, 114, 114),
              // child: Text(

              // style: TextStyle(color: Colors.black),
              // ),
            ),*/
          ),*/
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
