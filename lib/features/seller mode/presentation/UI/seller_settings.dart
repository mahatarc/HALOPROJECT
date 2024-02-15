import 'package:flutter/material.dart';
import 'package:flutterproject/features/home/presentation/UI/pages/home.dart';

class SellerSettings extends StatefulWidget {
  const SellerSettings({Key? key});

  @override
  State<SellerSettings> createState() => _SellerSettingsState();
}

class _SellerSettingsState extends State<SellerSettings> {
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
          title: Text('Customer Mode'),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => LandingPage()));
            // builder: (context) => SellerDashboard()));
          },
        ),
        ListTile(
          title: Text('Driver Mode'),
          onTap: () {},
        ),
      ],
    );
  }
}
