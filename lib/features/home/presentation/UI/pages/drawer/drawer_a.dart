import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterproject/features/authentication/presentation/bloc/sign_in_bloc/sign_in_bloc.dart';
import 'package:flutterproject/features/home/presentation/UI/pages/drawer/My_info/help_support.dart';
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
                accountName: Text("${userData['name']}"),
                accountEmail: Text("${userData['email']}"),
                currentAccountPicture: CircleAvatar(
                  radius: 30,
                  backgroundImage: userData['profilePicture'] != null
                      ? NetworkImage(userData['profilePicture'])
                          as ImageProvider
                      : AssetImage('images/profile1.jpeg'),
                ),
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
                  Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                          builder: (context) => SettingsScreen()));
                },
                child: ListTile(
                  leading: Icon(Icons.settings),
                  title: Text("Settings"),
                ),
              ),

              // const ListTile(
              //   leading: Icon(Icons.delivery_dining),
              //   title: Text("Delivery"),
              // ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(
                          builder: (context) => HelpAndSupportPage()));
                },
                child: ListTile(
                  leading: Icon(Icons.support),
                  title: Text("Help and support"),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true)
                      .pushReplacement(MaterialPageRoute(
                          builder: (context) => BlocProvider(
                                create: (context) => SignInBloc(),
                                child: const LoginPage(),
                              )));
                },
                style: ElevatedButton.styleFrom(
                  primary: const Color.fromARGB(255, 156, 199, 107),
                  minimumSize: const Size(20, 50),
                ),
                child: Text(
                  'Log Out',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
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
