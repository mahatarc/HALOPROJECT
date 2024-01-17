import 'package:flutter/material.dart';
import 'package:flutterproject/features/userauth/presenation/pages/drawer/My_info/profile.dart';
import 'package:flutterproject/features/userauth/presenation/pages/drawer/settings.dart';
import 'package:flutterproject/features/userauth/presenation/pages/login_page.dart';

class Mydrawer extends StatelessWidget {
  const Mydrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      
        child: ListView(
      padding: const EdgeInsets.all(0),
      children: <Widget>[
        const UserAccountsDrawerHeader(
          decoration: BoxDecoration(
              color: Color.fromRGBO(165, 214, 167, 1), // Set the background color of the top section
            ),
          accountName: Text("Archana"),
          accountEmail: Text(" archanamahat@gmail.com"),
          currentAccountPicture: Icon(Icons.person_2_rounded, size: 50),
        ),
        GestureDetector(
          onTap: () {
            // Navigate to the information page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfilePage(),
              ),
            );
          },
          child: ListTile(
            leading: Icon(Icons.info),
            title: Text("My Information"),
            //trailing: Icon(Icons.edit),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SettingsScreen(),
              ),
            );
          },
          child: ListTile(
            leading: Icon(Icons.settings),
            title: Text("Settings"),
            //trailing: Icon(Icons.edit),
          ),
        ),
        const ListTile(
          leading: Icon(Icons.payment_rounded),
          title: Text("Payments"),
          // trailing: Icon(Icons.settings),
        ),
        const ListTile(
          leading: Icon(Icons.history),
          title: Text("Transaction History"),
          // trailing: Icon(Icons.settings),
        ),
        const ListTile(
          leading: Icon(Icons.delivery_dining),
          title: Text("Delivery"),
          // trailing: Icon(Icons.settings),
        ),
        const ListTile(
          leading: Icon(Icons.support),
          title: Text("Help and support"),
          // trailing: Icon(Icons.settings),
        ),
        const SizedBox(
          height: 30,
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => LoginPage()));
          },
          child: Container(
            // width: 100,
            height: 50,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 156, 199, 107),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Text("Log Out",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
            ),
          ),
        ),
      ],
    ));
  }
}