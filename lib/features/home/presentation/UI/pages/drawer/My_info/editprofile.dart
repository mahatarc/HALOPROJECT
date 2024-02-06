import 'package:flutter/material.dart';
import 'package:flutterproject/features/home/presentation/UI/pages/drawer/My_info/profile.dart';

class EditProfilePage extends StatefulWidget {
  final PersonalInformation personalInfo;

  EditProfilePage(this.personalInfo);

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
    // Initialize the controllers with the current values
    nameController.text = widget.personalInfo.name;
    emailController.text = widget.personalInfo.email;
    locationController.text = widget.personalInfo.location;
    phoneNumberController.text = widget.personalInfo.phoneNumber;
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
              _buildTextField('Location', locationController),
              _buildTextField('Phone Number', phoneNumberController),
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
                    onPressed: () {
                      // Save the updated information
                      PersonalInformation updatedInfo = PersonalInformation(
                        nameController.text,
                        emailController.text,
                        locationController.text,
                        phoneNumberController.text,
                      );
                      // Navigate back to the profile page and pass the updated information as a result
                      Navigator.pop(context, updatedInfo);
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
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
        ),
        controller: controller,
      ),
    );
  }
}
