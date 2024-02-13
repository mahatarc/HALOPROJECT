import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DeliveryDriverRegistrationPage(),
      theme: ThemeData(
        scaffoldBackgroundColor: Color.fromARGB(255, 173, 200, 142),
      ),
    );
  }
}

class DeliveryDriverRegistrationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Delivery Driver Registration',
      home: DeliveryDriverRegistrationForm(),
    );
  }
}

class DeliveryDriverRegistrationForm extends StatefulWidget {
  @override
  _DeliveryDriverRegistrationFormState createState() =>
      _DeliveryDriverRegistrationFormState();
}

class _DeliveryDriverRegistrationFormState
    extends State<DeliveryDriverRegistrationForm> {
  late File? pickedImage = null;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController licenseController = TextEditingController();
  final TextEditingController vehicleTypeController = TextEditingController();
  final TextEditingController vehicleNumberController =
      TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                // Implement delivery driver registration logic here
                _registerDriver(context);
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
            // Implement image upload logic here
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

  void _registerDriver(BuildContext context) {
    // Implement delivery driver registration logic here
    // Retrieve the entered values from the controllers
    String name = nameController.text;
    String phone = phoneController.text;
    String email = emailController.text;
    String license = licenseController.text;
    String vehicleType = vehicleTypeController.text;
    String vehicleNumber = vehicleNumberController.text;
    String address = addressController.text;

    // Print or process the driver information as needed
    print('Name: $name');
    print('Phone Number: $phone');
    print('Email: $email');
    print('License Number: $license');
    print('Vehicle Type: $vehicleType');
    print('Vehicle Plate Number: $vehicleNumber');
    print('Address: $address');

    // Add your logic for handling the registration data
  }
}
