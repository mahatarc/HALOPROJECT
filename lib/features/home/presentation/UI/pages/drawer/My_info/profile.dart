import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterproject/features/authentication/services/firebaseauth.dart';
import 'package:image_picker/image_picker.dart';
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
  File? _image;
  bool _isImageChanged = false;

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
        backgroundColor: Colors.green[100],
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
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: _image != null
                          ? FileImage(_image!)
                          : userData['profilePicture'] != null
                              ? NetworkImage(userData['profilePicture'])
                              : AssetImage('images/profile.jpg')
                                  as ImageProvider<Object>?,
                    ),
                    IconButton(
                      onPressed: () async {
                        await _showImageOptionsDialog(context);
                      },
                      icon: Icon(Icons.camera_alt),
                    ),
                  ],
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
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey[100], // Background color
                    onPrimary: Colors.black, // Text color
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10), // Adjust the border radius
                    ),
                  ),
                  child: Text('Edit Profile'),
                ),
                SizedBox(height: 32),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('My Personal Information'),
                      _buildPersonalInfoTile('Name', personalInfo.name),
                      _buildPersonalInfoTile('Email', personalInfo.email),
                      _buildPersonalInfoTile('Role', personalInfo.role),
                    ],
                  ),
                ),
                if (_isImageChanged) // Show save button only if image is changed
                  ElevatedButton(
                    onPressed: () {
                      // Save image logic
                      _saveImage();
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.grey[100], // Background color
                      onPrimary: Colors.black, // Text color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            10), // Adjust the border radius
                      ),
                    ),
                    child: Text('Save'),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _showImageOptionsDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose an option'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text('Gallery'),
                  onTap: () async {
                    Navigator.of(context).pop();
                    await _getImage(ImageSource.gallery);
                    setState(() {
                      _isImageChanged =
                          true; // Set flag to indicate image change
                    });
                  },
                ),
                SizedBox(height: 10),
                GestureDetector(
                  child: Text('Camera'),
                  onTap: () async {
                    Navigator.of(context).pop();
                    await _getImage(ImageSource.camera);
                    setState(() {
                      _isImageChanged =
                          true; // Set flag to indicate image change
                    });
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  void _saveImage() async {
    // Upload image to Firebase Storage
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('profile_images/${_authService.getCurrentUserId()}');
    UploadTask uploadTask = ref.putFile(_image!);
    TaskSnapshot taskSnapshot = await uploadTask;
    String imageUrl = await taskSnapshot.ref.getDownloadURL();

    // Update user profile in Firestore
    await _usersCollection
        .doc(_authService.getCurrentUserId())
        .update({'profilePicture': imageUrl});

    setState(() {
      _isImageChanged = false;
    });
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
