import 'package:flutter/material.dart';
import 'package:flutter_application_1/drawer/My_info/editprofile.dart';

class User {
  final String name;
  final String email;
  final String profilePicture;

  User(this.name, this.email, this.profilePicture);
}

class PersonalInformation {
  final String name;
  final String email;
  final String location;
  final String phoneNumber;

  PersonalInformation(this.name, this.email, this.location, this.phoneNumber);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile',
      home: ProfilePage(),
      theme: ThemeData(
        scaffoldBackgroundColor: Color.fromARGB(
            255, 223, 245, 202), // Set the background color to light green
      ),
    );
  }
}

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

// ignore: must_be_immutable
class _ProfilePageState extends State<ProfilePage> {
  User user = User(
      "Bill Gates", "bill.gates@example.com", "assets/images/billgates.jpg");
  PersonalInformation personalInfo = PersonalInformation(
      "Bill Gates", "bill.gates@example.com", "Kathmandu, Nepal", "9867898086");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 172, 229, 142),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Center the content vertically
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(user.profilePicture),
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
                final updatedInfo = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfilePage(
                        personalInfo), // Navigate to the edit profile screen (you can implement this)
                  ),
                );
                // Handle the result returned from EditProfilePage
                if (updatedInfo != null && updatedInfo is PersonalInformation) {
                  // Update the personalInfo with the new information
                  setState(() {
                    personalInfo = updatedInfo;
                  });
                }
              },
              child: Text('Edit Profile'),
            ),
            SizedBox(height: 32),
            _buildSectionTitle('My Personal Information'),
            _buildPersonalInfoTile('Name', personalInfo.name),
            _buildPersonalInfoTile('Email', personalInfo.email),
            _buildPersonalInfoTile('Location', personalInfo.location),
            _buildPersonalInfoTile('Phone Number', personalInfo.phoneNumber),
          ],
        ),
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
