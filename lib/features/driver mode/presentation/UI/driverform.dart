import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutterproject/features/driver%20mode/model/drivermodel.dart';
import 'package:flutterproject/features/driver%20mode/presentation/UI/driverdashboard.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class DeliveryDriverRegistrationForm extends StatefulWidget {
  @override
  _DeliveryDriverRegistrationFormState createState() =>
      _DeliveryDriverRegistrationFormState();
}

class _DeliveryDriverRegistrationFormState
    extends State<DeliveryDriverRegistrationForm> {
  File? pickedImage;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController licenseController = TextEditingController();
  final TextEditingController vehicleTypeController = TextEditingController();
  final TextEditingController vehicleNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  void _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        pickedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _registerDriver(BuildContext context, Driver driver) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // User not authenticated, handle accordingly
      return;
    }

    // Upload image to Firebase Storage
    String imageUrl = '';
    if (pickedImage != null) {
      final Reference ref = FirebaseStorage.instance
          .ref()
          .child('driver_images/${DateTime.now().millisecondsSinceEpoch}');
      await ref.putFile(pickedImage!);
      imageUrl = await ref.getDownloadURL();
      print(imageUrl);
      await FirebaseFirestore.instance
          .collection('drivers')
          .doc(user.uid)
          .set({'imageUrl': imageUrl});
    }

    try {
      await FirebaseFirestore.instance
          .collection('drivers')
          .doc(user.uid)
          .set(driver.toJson());
      // Registration successful, navigate to seller dashboard
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'role': 'driver'});
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DeliveryBoyDashboard()),
      );
    } catch (error) {
      // Handle registration error
      print('Error registering driver: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error registering driver. Please try again later.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[200],
        title: const Text("Driver Registration Form"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildImageUploadSection(),
              SizedBox(height: 16),
              _buildTextField('Name', nameController),
              _buildTextField('Phone Number', phoneController),
              _buildTextField('Email', emailController),
              _buildTextField('License Number', licenseController),
              _buildTextField('Vehicle Type(Bike,Car)', vehicleTypeController),
              _buildTextField('Vehicle Plate Number', vehicleNumberController),
              _buildTextField('Address', addressController),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  _registerDriver(
                      context,
                      Driver(
                          name: nameController.text,
                          phone: phoneController.text,
                          email: emailController.text,
                          license: licenseController.text,
                          vehicleType: vehicleTypeController.text,
                          vehicleNumber: vehicleNumberController.text,
                          address: addressController.text));
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(255, 142, 206, 142)),
                ),
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageUploadSection() {
    return Column(
      children: [
        // Display the uploaded image or show a placeholder
        pickedImage == null
            ? Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey, // Set a default background color
                ),
                child: Icon(
                  Icons.image, // You can use any default icon or widget here
                  size: 100,
                  color: Colors.white,
                ),
              )
            : ClipOval(
                child: Image.file(
                  pickedImage!,
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
              ),
        SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            _pickImage();
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
                Color.fromARGB(255, 142, 206, 142)),
          ),
          child: Text('Upload Photo from Gallery'),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          errorText: _getErrorText(label, controller.text),
        ),
        controller: controller,
      ),
    );
  }

  String? _getErrorText(String label, String value) {
    if (value.isEmpty) {
      return 'Please enter $label';
    }
    return null;
  }
}
