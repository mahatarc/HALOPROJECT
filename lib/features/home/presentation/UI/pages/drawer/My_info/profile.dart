import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterproject/features/authentication/services/firebaseauth.dart';
import 'package:flutterproject/features/home/presentation/UI/pages/drawer/My_info/editprofile.dart';

class PersonalInformation {
  final String name;
  final String email;
  final String role;

  PersonalInformation({
    required this.name,
    required this.email,
    required this.role,
  });
}

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late CollectionReference _usersCollection;
  final _authService = FirebaseAuthService();
  @override
  void initState() {
    super.initState();
    _usersCollection = FirebaseFirestore.instance.collection('users');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 172, 229, 142),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream:
            _usersCollection.doc(_authService.getCurrentUserId()).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          var userData = snapshot.data?.data() as Map<String, dynamic>?;

          if (userData == null) {
            return Text('No user data found.');
          }

          var personalInfo = PersonalInformation(
            name: userData['name'] ?? '',
            email: userData['email'] ?? '',
            role: userData['role'] ?? '',
          );

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: userData['profilePicture'] != null
                      ? NetworkImage(userData['profilePicture'])
                      : AssetImage('images/profile.jpg')
                          as ImageProvider<Object>?,
                ),
                SizedBox(height: 16),
                Text(
                  personalInfo.name,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  personalInfo.email,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfilePage(
                          personalInfo: personalInfo,
                        ),
                      ),
                    );
                  },
                  child: Text('Edit Profile'),
                ),
                SizedBox(height: 32),
                _buildSectionTitle('My Personal Information'),
                _buildPersonalInfoTile('Name', personalInfo.name),
                _buildPersonalInfoTile('Email', personalInfo.email),
                _buildPersonalInfoTile('Role', personalInfo.role),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildPersonalInfoTile(String label, String value) {
    return ListTile(
      title: Text(
        label,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(value),
    );
  }
}
