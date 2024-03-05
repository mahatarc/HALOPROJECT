import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'profile.dart';

class EditProfilePage extends StatefulWidget {
  final PersonalInformation personalInfo;
  const EditProfilePage({Key? key, required this.personalInfo})
      : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.personalInfo.name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 172, 229, 142),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextField('Name', nameController),
              _buildPasswordField(
                  'Current Paassword', currentPasswordController),
              _buildPasswordField('New Password', newPasswordController),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        bool confirm = await _showConfirmationDialog();
                        if (confirm) {
                          String currentPassword =
                              currentPasswordController.text;
                          String newPassword = newPasswordController.text;
                          try {
                            // Re-authenticate the user with their current password
                            AuthCredential credential =
                                EmailAuthProvider.credential(
                              email: FirebaseAuth.instance.currentUser!.email!,
                              password: currentPassword,
                            );
                            await FirebaseAuth.instance.currentUser!
                                .reauthenticateWithCredential(credential);

                            // Update the password
                            await FirebaseAuth.instance.currentUser!
                                .updatePassword(newPassword);

                            // Show success dialog
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Password Reset Successful"),
                                  content: Text(
                                      "Your password has been updated successfully."),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("OK"),
                                    ),
                                  ],
                                );
                              },
                            );

                            // Clear form fields
                            currentPasswordController.clear();
                            newPasswordController.clear();

                            // You may also sign out the user if needed
                          } catch (error) {
                            // Show error dialog
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Password Reset Failed"),
                                  content: Text(
                                      "Invalid current password. Please try again."),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("OK"),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        }
                      }
                    },
                    child: Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
        ),
        controller: controller,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
        ),
        controller: controller,
        obscureText: true,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a $label';
          }
          return null;
        },
      ),
    );
  }

  Future<bool> _showConfirmationDialog() async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Password Change"),
          content: Text("Are you sure you want to change the password?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // No, cancel action
              },
              child: Text("No"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Yes, confirm action
              },
              child: Text("Yes"),
            ),
          ],
        );
      },
    );
  }
}
