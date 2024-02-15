import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterproject/features/seller%20mode/model/sellermodel.dart';
import 'package:flutterproject/features/seller%20mode/presentation/UI/seller.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';

class SellerRegistrationForm extends StatefulWidget {
  @override
  _SellerRegistrationFormState createState() => _SellerRegistrationFormState();
}

class _SellerRegistrationFormState extends State<SellerRegistrationForm> {
  File? _pickedImage;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _contactNumberController =
      TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _provinceController = TextEditingController();
  final TextEditingController _citizenshipNumberController =
      TextEditingController();

  void _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _registerSeller(BuildContext context, Seller seller) async {
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
    if (_pickedImage != null) {
      final Reference ref = FirebaseStorage.instance
          .ref()
          .child('seller_images/${DateTime.now().millisecondsSinceEpoch}');
      await ref.putFile(_pickedImage!);
      imageUrl = await ref.getDownloadURL();
      print(imageUrl);
      await FirebaseFirestore.instance
          .collection('sellers')
          .doc(user.uid)
          .set({'imageUrl': imageUrl});
    }

    // Register seller in Firestore
    try {
      await FirebaseFirestore.instance
          .collection('sellers')
          .doc(user.uid)
          .set(seller.toJson());
      // Registration successful, navigate to seller dashboard
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'role': 'seller'});
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SellerDashboard()),
      );
    } catch (error) {
      // Handle registration error
      print('Error registering seller: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.green[200],
          title: const Text("Seller Registration Form"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // Navigate back to the previous screen (Drawer in this case)
              Navigator.pop(context);
            },
          )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildImageUploadSection(),
              SizedBox(height: 16),
              _buildTextField('Business Name', _businessNameController),
              _buildTextField('Contact Number', _contactNumberController),
              _buildTextField('Address', _addressController),
              _buildTextField('City', _cityController),
              _buildTextField('Province', _provinceController),
              _buildTextField(
                  'Citizenship Number', _citizenshipNumberController),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  _registerSeller(
                      context,
                      Seller(
                          businessName: _businessNameController.text,
                          contactNumber: _contactNumberController.text,
                          address: _addressController.text,
                          city: _cityController.text,
                          province: _provinceController.text,
                          citizenshipNumber: _citizenshipNumberController.text,
                          imageUrl: ''));
                },
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 224, 246, 220),
                  onPrimary: Color.fromARGB(255, 11, 3, 3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
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
        _pickedImage == null
            ? Container(
                height: 200,
                width: double.infinity,
                color: Colors.grey,
                child: Icon(
                  Icons.image,
                  size: 100,
                  color: Colors.white,
                ),
              )
            : Image.file(
                _pickedImage!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
        SizedBox(height: 8),
        ElevatedButton(
          onPressed: _pickImage,
          style: ElevatedButton.styleFrom(
            primary: Color.fromARGB(255, 224, 246, 220),
            onPrimary: Color.fromARGB(255, 11, 3, 3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          child: Text('Upload Shop Picture'),
        ),
      ],
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
          if (value!.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }
}
