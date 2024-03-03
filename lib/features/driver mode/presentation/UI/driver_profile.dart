import 'package:flutter/material.dart';
import 'package:flutterproject/features/cart/presentation/UI/pages/cart.dart';
import 'package:flutterproject/features/driver%20mode/presentation/UI/driverdashboard.dart';
import 'package:flutterproject/features/driver%20mode/presentation/UI/myearnings.dart';
import 'package:flutterproject/features/home/presentation/UI/pages/home.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class DeliveryBoyProfile extends StatefulWidget {
  @override
  _DeliveryBoyProfileState createState() => _DeliveryBoyProfileState();
}

class _DeliveryBoyProfileState extends State<DeliveryBoyProfile> {
  File? profilePicture;
  bool isEditing = false;
  bool sellerModeEnabled = false;
  bool customerModeEnabled = false;

  TextEditingController nameController =
      TextEditingController(text: 'Hari Bahadur');
  TextEditingController phoneController =
      TextEditingController(text: '9850434678');
  TextEditingController locationController =
      TextEditingController(text: 'Kalimati');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color.fromARGB(255, 228, 234, 232),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Profile'),
        backgroundColor: Colors.green[100],
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              _showPopupMenu(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfilePicture(),
            SizedBox(height: 16),
            _buildTextField('Name', nameController),
            _buildTextField('Phone Number', phoneController),
            _buildTextField('Location', locationController),
            SizedBox(height: 300), // Add some spacing
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // Default selected tab
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on),
            label: 'My Earnings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DeliveryBoyDashboard()),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyEarningsPage()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DeliveryBoyProfile()),
            );
          }
        },
      ),
    );
  }

  Widget _buildProfilePicture() {
    return GestureDetector(
      onTap: () {
        if (isEditing) {
          _pickImage();
        }
      },
      child: CircleAvatar(
        radius: 40,
        backgroundColor: Colors.grey,
        backgroundImage:
            profilePicture != null ? FileImage(profilePicture!) : null,
        child: isEditing
            ? Icon(
                Icons.camera_alt,
                size: 40,
                color: Colors.white,
              )
            : null,
      ),
    );
  }

  Widget _buildRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.star,
          color: Colors.amber,
          size: 16.0,
        ),
        SizedBox(width: 4.0),
        Text(
          '4.5',
          style: TextStyle(fontSize: 12.0),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
        ),
        readOnly: !isEditing,
      ),
    );
  }

  void _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        profilePicture = File(pickedFile.path);
      });
    }
  }

  Widget _buildModeSettingsTile() {
    return ExpansionTile(
      title: Text(
        'Mode Settings',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      children: [
        ListTile(
          title: Text('Customer Mode'),
          onTap: () {
            // Navigate to the SellerModeScreen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LandingPage(),
              ),
            );
          },
        ),
        ListTile(
          title: Text('Seller Mode'),
          onTap: () {
            // Navigate to the DriverModeScreen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CartPage(),
              ),
            );
          },
        ),
      ],
    );
  }

  void _showPopupMenu(BuildContext context) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final Offset offset = Offset(overlay.size.width - 40, kToolbarHeight);

    showMenu(
      context: context,
      position:
          RelativeRect.fromLTRB(offset.dx, offset.dy, offset.dx, offset.dy),
      items: [
        PopupMenuItem(
          child: Text('Edit'),
          value: 'edit',
        ),
        PopupMenuItem(
          child: Text('Save'),
          value: 'save',
        ),
        PopupMenuItem(
          child: _buildModeSettingsTile(),
        ),
      ],
      elevation: 8.0,
    ).then((value) {
      // Handle the selected option (edit or save)
      if (value == 'edit') {
        setState(() {
          isEditing = true;
        });
      } else if (value == 'save') {
        _saveProfile();
      }
    });
  }

  void _saveProfile() {
    print('Updated Name: ${nameController.text}');
    print('Updated Phone Number: ${phoneController.text}');
    print('Updated Locatioin: ${locationController.text}');
    setState(() {
      isEditing = false;
    });
  }
}
