import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location_package;
import 'package:geocoding/geocoding.dart' as geocoding;

class MapService extends StatefulWidget {
  const MapService({Key? key}) : super(key: key);

  @override
  State<MapService> createState() => _MapServiceState();
}

class _MapServiceState extends State<MapService> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  Marker? _userLocationMarker;
  LatLng? _targetLocation;
  String? _address;
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  // Method to get the user's current location
  void _getUserLocation() async {
    location_package.LocationData locationData =
        await location_package.Location().getLocation();
    setState(() {
      _targetLocation = LatLng(locationData.latitude!, locationData.longitude!);
      print('Target Location: $_targetLocation');
      _getAddressFromLocation(_targetLocation!);
    });
  }

  // Method to handle the creation of the Google Map
  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _userLocationMarker = Marker(
        markerId: MarkerId('userLocation'),
        position: _targetLocation!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      );
    });
    _controller.complete(controller);
  }

  // Method to get address from location
  void _getAddressFromLocation(LatLng location) async {
    try {
      List<geocoding.Placemark> placemarks =
          await geocoding.placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );
      if (placemarks != null && placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        setState(() {
          _address =
              '${placemark.street}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}';
          _addressController.text = _address!;
        });
      }
    } catch (e) {
      print('Error getting address: $e');
    }
  }

  // Method to handle the "OK" button press
  void _onOkButtonPressed() {
    Navigator.pop(
        context, _address); // Return the address to the previous screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Delivery Address'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              myLocationEnabled: true,
              mapType: MapType.terrain,
              initialCameraPosition: CameraPosition(
                target: _targetLocation ??
                    LatLng(
                        27.7172, 85.3240), // Use default location if available
                zoom: 14.4746,
              ),
              onMapCreated: _onMapCreated,
              onCameraMove: (CameraPosition position) {
                // You can add logic here to handle camera movement
              },
              markers: _userLocationMarker != null
                  ? Set<Marker>.of([_userLocationMarker!])
                  : Set<Marker>(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _onOkButtonPressed,
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
