import 'package:flutter/material.dart';

class yourProducts extends StatefulWidget {
  const yourProducts({super.key});

  @override
  State<yourProducts> createState() => _yourProductsState();
}

class _yourProductsState extends State<yourProducts> {
  int currerntIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[200],
        title: Text('Your Products'),
      ),
      /* bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            currerntIndex = index;
            if (index == 0) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SellerDashboard()),
              );
            }
            if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => yourProducts()),
              );
            }
            if (index == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Order()),
              );
            }
            if (index == 3) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SellerSettings()),
              );
            }
          });
        },
        backgroundColor: Colors.green[200],
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Your Products",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Orders",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.text_decrease_rounded),
            label: "Settings",
          ),
        ],
      ),*/
    );
  }
}
