import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:latlong2/latlong.dart'; // For working with coordinates
import 'package:location/location.dart'; // For accessing device location

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  LocationData? _currentLocation;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    final location = Location();
    _currentLocation = await location.getLocation();
    setState(() {});
  }

  /*@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Driver Map'),
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          center: LatLng(_currentLocation?.latitude ?? 0, _currentLocation?.longitude ?? 0),
          zoom: 15.0,
        ),
        layers: [
          TileLayerOptions(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayerOptions(
            markers: [
              Marker(
                width: 40.0,
                height: 40.0,
                point: LatLng(_currentLocation?.latitude ?? 0, _currentLocation?.longitude ?? 0),
                builder: (ctx) => Container(
                  child: Icon(Icons.location_on, color: Colors.blue),
                ),
              ),
              // Add a marker for the customer's location
              // Replace the coordinates below with the actual customer's location
              Marker(
                width: 40.0,
                height: 40.0,
                point: LatLng(27.7172, 85.3240), // Example coordinates
                builder: (ctx) => Container(
                  child: Icon(Icons.person, color: Colors.red),
                ),
              ),
            ],
          ),
        ], children: [],
      ),
    );
  }
}*/


@override
Widget build(BuildContext context) {
   return Scaffold(
      appBar: AppBar(
        title: Text('Driver Map'),
      ),
  body: FlutterMap(
    mapController: _mapController,
    options: MapOptions(
      center: LatLng(_currentLocation?.latitude ?? 0, _currentLocation?.longitude ?? 0),
     // initialCenter: LatLng(51.509364, -0.128928),
      initialZoom: 9.2,
    ),
    children: [
      TileLayer(
        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        userAgentPackageName: 'com.example.app',
      ),
      RichAttributionWidget(
        attributions: [
          TextSourceAttribution(
            'OpenStreetMap contributors',
            onTap: () => launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
          ),
        ],
      ),
    ],
  ),
   );
}
}