import 'package:flutter/material.dart';
import 'package:flutterproject/features/home/presentation/UI/pages/drawer/My_info/profile.dart';
import 'package:flutterproject/features/home/presentation/UI/pages/drawer/settings.dart';
import 'package:flutterproject/features/authentication/presentation/UI/pages/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterproject/features/authentication/services/firebaseauth.dart';

class Mydrawer extends StatelessWidget {
  const Mydrawer({Key? key});

  @override
  Widget build(BuildContext context) {
    final _authService = FirebaseAuthService();
    final CollectionReference _usersCollection =
        FirebaseFirestore.instance.collection('users');

    return Drawer(
      child: StreamBuilder<DocumentSnapshot>(
        stream:
            _usersCollection.doc(_authService.getCurrentUserId()).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          var userData = snapshot.data?.data() as Map<String, dynamic>?;

          if (userData == null) {
            return Text('No user data found.');
          }

          return ListView(
            padding: const EdgeInsets.all(0),
            children: <Widget>[
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(165, 214, 167, 1),
                ),
                accountName:
                    Text("${userData['firstName']} ${userData['lastName']}"),
                accountEmail: Text("${userData['email']}"),
                currentAccountPicture: Icon(Icons.person_2_rounded, size: 50),
              ),
              GestureDetector(
                onTap: () {
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
                ),
              ),
              const ListTile(
                leading: Icon(Icons.payment_rounded),
                title: Text("Payments"),
              ),
              const ListTile(
                leading: Icon(Icons.history),
                title: Text("Transaction History"),
              ),
              const ListTile(
                leading: Icon(Icons.delivery_dining),
                title: Text("Delivery"),
              ),
              const ListTile(
                leading: Icon(Icons.support),
                title: Text("Help and support"),
              ),
              const SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
                child: Container(
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
          );
        },
      ),
    );
  }
}
