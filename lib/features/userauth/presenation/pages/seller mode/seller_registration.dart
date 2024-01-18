import 'package:flutter/material.dart';
import 'package:flutterproject/features/userauth/presenation/pages/seller%20mode/seller.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class SellerRegistrationForm extends StatefulWidget {
  @override
  _SellerRegistrationFormState createState() => _SellerRegistrationFormState();
}

class _SellerRegistrationFormState extends State<SellerRegistrationForm> {
  late File? pickedImage = null;
  final TextEditingController businessNameController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController provinceController = TextEditingController();
  final TextEditingController citizenshipNumberController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[200],
        title: const Text("Seller Registration Form"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildImageUploadSection(),
            SizedBox(height: 16),
            _buildTextField('Business Name', businessNameController),
            _buildTextField('Contact Number', contactNumberController),
            _buildTextField('Email', emailController),
            _buildTextField('Address', addressController),
            _buildTextField('City', cityController),
            _buildTextField('Province', provinceController),
            _buildTextField('Citizenship Number', citizenshipNumberController),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Implement seller registration logic here
                _registerSeller(context);
              },
              style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(
                      255, 224, 246, 220), // Change the background color
                  onPrimary: const Color.fromARGB(
                      255, 11, 3, 3), // Change the text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  )),
              /*style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromARGB(255, 142, 206, 142)),
              ),*/
              child: Text('Register'),
            ),
          ],
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
                color: Colors.grey, // Set a default background color
                child: Icon(
                  Icons.image, // You can use any default icon or widget here
                  size: 100,
                  color: Colors.white,
                ),
              )
            : Image.file(
                pickedImage!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
        SizedBox(height: 8),
        ElevatedButton(
          onPressed: () {
            // Implement image upload logic here
            _pickImage();
          },
          style: ElevatedButton.styleFrom(
              primary: Color.fromARGB(
                  255, 224, 246, 220), // Change the background color
              onPrimary:
                  const Color.fromARGB(255, 11, 3, 3), // Change the text color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              )),

          /* style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
                Color.fromARGB(255, 142, 206, 142)),
          ),*/
          child: Text('Upload Shop Picture'),
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
        ),
        controller: controller,
      ),
    );
  }

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

  void _registerSeller(BuildContext context) {
    // Implement seller registration logic here
    // Retrieve the entered values from the controllers
    String businessName = businessNameController.text;
    String contactNumber = contactNumberController.text;
    String email = emailController.text;
    String address = addressController.text;
    String city = cityController.text;
    String province = provinceController.text;
    String citizenshipNumber = citizenshipNumberController.text;

    // Print or process the seller information as needed
    print('Business Name: $businessName');
    print('Contact Number: $contactNumber');
    print('Email: $email');
    print('Address: $address');
    print('City: $city');
    print('Province: $province');
    print('Citizenship Number: $citizenshipNumber');

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SellerDashboard()),
    );
  }
}
