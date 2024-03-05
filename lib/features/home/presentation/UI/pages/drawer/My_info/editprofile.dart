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
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  bool _obscureNewPassword = true;
  bool _obscureCurrentPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password'),
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
              _buildPasswordField('Current Password', currentPasswordController,
                  _obscureCurrentPassword),
              _buildPasswordField(
                  'New Password', newPasswordController, _obscureNewPassword),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child:
                        Text('Cancel', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 172, 229, 142)),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        bool confirm = await _showConfirmationDialog();
                        if (confirm) {
                          String currentPassword =
                              currentPasswordController.text;
                          String newPassword = newPasswordController.text;

                          if (newPassword.length < 6) {
                            _showPasswordLengthDialog();
                            return; // Stop further execution
                          }

                          try {
                            AuthCredential credential =
                                EmailAuthProvider.credential(
                              email: FirebaseAuth.instance.currentUser!.email!,
                              password: currentPassword,
                            );
                            await FirebaseAuth.instance.currentUser!
                                .reauthenticateWithCredential(credential);

                            await FirebaseAuth.instance.currentUser!
                                .updatePassword(newPassword);

                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Password Reset Successful",
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 172, 229, 142))),
                                  content: Text(
                                      "Your password has been updated successfully.",
                                      style: TextStyle(color: Colors.black)),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("OK",
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 172, 229, 142)))),
                                  ],
                                  backgroundColor: Colors.white,
                                );
                              },
                            );

                            currentPasswordController.clear();
                            newPasswordController.clear();
                          } catch (error) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Password Reset Failed",
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 172, 229, 142))),
                                  content: Text(
                                      "Invalid current password. Please try again.",
                                      style: TextStyle(color: Colors.black)),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("OK",
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 172, 229, 142)))),
                                  ],
                                  backgroundColor: Colors.white,
                                );
                              },
                            );
                          }
                        }
                      }
                    },
                    child: Text('Save', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 172, 229, 142)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(
      String label, TextEditingController controller, bool obscureText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: IconButton(
            icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
            onPressed: () {
              setState(() {
                if (label == 'New Password') {
                  _obscureNewPassword = !_obscureNewPassword;
                } else if (label == 'Current Password') {
                  _obscureCurrentPassword = !_obscureCurrentPassword;
                }
              });
            },
          ),
        ),
        controller: controller,
        obscureText: obscureText,
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
          title: Text("Confirm Password Change",
              style: TextStyle(color: Color.fromARGB(255, 172, 229, 142))),
          content: Text("Are you sure you want to change the password?",
              style: TextStyle(color: Colors.black)),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text("No",
                    style:
                        TextStyle(color: Color.fromARGB(255, 172, 229, 142)))),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text("Yes",
                    style:
                        TextStyle(color: Color.fromARGB(255, 172, 229, 142)))),
          ],
          backgroundColor: Colors.white,
        );
      },
    );
  }

  void _showPasswordLengthDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Password Length",
              style: TextStyle(color: Color.fromARGB(255, 172, 229, 142))),
          content: Text("Please enter a password of 6 or more characters.",
              style: TextStyle(color: Colors.black)),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK",
                    style:
                        TextStyle(color: Color.fromARGB(255, 172, 229, 142)))),
          ],
          backgroundColor: Colors.white,
        );
      },
    );
  }
}
