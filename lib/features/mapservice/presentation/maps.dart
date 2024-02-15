import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

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

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  // Method to get the user's current location
  void _getUserLocation() async {
    LocationData locationData = await Location().getLocation();
    setState(() {
      _targetLocation = LatLng(locationData.latitude!, locationData.longitude!);
      print('Target Location: $_targetLocation');
      print('successful');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        myLocationEnabled: true,
        mapType: MapType.terrain,
        initialCameraPosition: CameraPosition(
          target: _targetLocation ??
              LatLng(27.7172,
                  85.3240), // Use the target location if available, otherwise use default
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
    );
  }
}
