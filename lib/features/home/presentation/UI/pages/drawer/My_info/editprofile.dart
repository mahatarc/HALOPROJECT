import 'package:cloud_firestore/cloud_firestore.dart';
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
  TextEditingController emailController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();

    nameController.text = widget.personalInfo.firstName;
    emailController.text = widget.personalInfo.email;

    // Initialize other controllers with existing data if needed.
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
              _buildTextField('Email', emailController),
              // Add other fields as needed for editing other information.
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
                        // Save the updated information
                        PersonalInformation updatedInfo = PersonalInformation(
                          firstName: nameController.text,
                          lastName: widget.personalInfo.lastName,
                          email: emailController.text,
                          role: widget.personalInfo.role,
                        );
                        Navigator.pop(context, updatedInfo);

                        // Update Firestore document with the new information
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(/* Provide user ID here */)
                            .update({
                          'firstName': updatedInfo.firstName,
                          'email': updatedInfo.email,
                          // Update other fields as needed.
                        });

                        // Navigate back to the profile page and pass the updated information as a result
                        Navigator.pop(context, updatedInfo);
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
}
