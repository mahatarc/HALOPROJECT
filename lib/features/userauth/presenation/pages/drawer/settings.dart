import 'package:flutter/material.dart';
import 'package:flutterproject/features/userauth/presenation/pages/seller%20mode/seller_registration.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;
  bool darkModeEnabled = false;
  bool sellerModeEnabled = false;
  bool driverModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[200],
        title: Text('Settings'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back to the previous screen
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildGeneralSettingsTile(),
            _buildModeSettingsTile(),
          ],
        ),
      ),
    );
  }

  Widget _buildGeneralSettingsTile() {
    return ExpansionTile(
      title: Text(
        'General Settings',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      children: [
        SwitchListTile(
          title: Text('Enable Notifications'),
          value: notificationsEnabled,
          onChanged: (value) {
            setState(() {
              notificationsEnabled = value;
            });
          },
        ),
        /*SwitchListTile(
          title: Text('Dark Mode'),
          value: darkModeEnabled,
          onChanged: (value) {
            setState(() {
              darkModeEnabled = value;
            });
          },
        ),*/
      ],
    );
  }

  Widget _buildModeSettingsTile() {
    return ExpansionTile(
      title: Text(
        'Mode Settings',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      children: [
        ListTile(
          title: Text('Seller Mode'),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SellerRegistrationForm()));
            // builder: (context) => SellerDashboard()));
          },
        ),
        ListTile(
          title: Text('Driver Mode'),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SellerRegistrationForm()));
          },
        ),
      ],
    );
  }
}
