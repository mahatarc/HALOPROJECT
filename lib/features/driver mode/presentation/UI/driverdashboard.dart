import 'package:flutter/material.dart';
import 'package:flutterproject/features/driver%20mode/presentation/UI/CompletedOrdersScreen.dart';
import 'package:flutterproject/features/driver%20mode/presentation/UI/driver_profile.dart';
import 'package:flutterproject/features/driver%20mode/presentation/UI/myearnings.dart';

class DeliveryBoyDashboard extends StatefulWidget {
  const DeliveryBoyDashboard({super.key});

  @override
  State<DeliveryBoyDashboard> createState() => _DeliveryBoyDashboardState();
}

class _DeliveryBoyDashboardState extends State<DeliveryBoyDashboard> {
  int currentIndex = 0;
  List<Widget> pages = [Delivery(), MyEarningsPage(), DeliveryBoyProfile()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type:
            BottomNavigationBarType.fixed, // Set type to fixed for even spacing
        selectedItemColor: Color.fromARGB(255, 64, 64, 64),
        backgroundColor: Colors.green[100],
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
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
            icon: Icon(Icons.add_shopping_cart),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class Delivery extends StatefulWidget {
  const Delivery({super.key});

  @override
  State<Delivery> createState() => _DeliveryState();
}

class _DeliveryState extends State<Delivery> {
  bool isAvailable = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Driver"),
        backgroundColor: Colors.green[100],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            const Text(
              'Welcome, Delivery Boy!',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: Text(
                isAvailable ? 'You are Available' : 'You are Not Available',
                style: const TextStyle(fontSize: 20),
              ),
              value: isAvailable,
              onChanged: (value) {
                setState(() {
                  isAvailable = value;
                });
              },
              activeColor: const Color.fromARGB(255, 26, 157, 31),
              inactiveTrackColor: Colors.red,
            ),
            const SizedBox(height: 32),
            const Text(
              'Today Orders',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildOrderStatusCard('Accept Orders', 3, () {
                  // Navigate to the Accept Orders screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AcceptOrdersScreen()),
                  );
                }),
                _buildOrderStatusCard('Pending Orders', 6, () {
                  // Navigate to the Pending Orders screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PendingOrdersScreen()),
                  );
                }),
              ],
            ),
            const SizedBox(height: 18),
            Column(
              children: [
                _buildOrderStatusCard('Completed Orders', 5, () {
                  // Navigate to the Completed Orders screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CompletedOrdersPage()),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderStatusCard(
      String title, int count, VoidCallback onPressed) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
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
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
          Positioned(
            bottom: 9,
            right: 9,
            child: CircleAvatar(
              radius: 10,
              backgroundColor: const Color.fromARGB(255, 223, 114, 114),
              child: Text(
                '$count',
                style: const TextStyle(color: Colors.black),
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
  const AcceptOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accept Orders'),
      ),
      body: const Center(
        child: Text('Accept Orders Screen'),
      ),
    );
  }
}

class PendingOrdersScreen extends StatelessWidget {
  const PendingOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pending Orders'),
      ),
      body: const Center(
        child: Text('Pending Orders Screen'),
      ),
    );
  }
}

class CompletedOrdersScreen extends StatelessWidget {
  const CompletedOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Completed Orders'),
      ),
      body: const Center(
        child: Text('Completed Orders Screen'),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: const Center(
        child: Text('Profile Screen'),
      ),
    );
  }
}
