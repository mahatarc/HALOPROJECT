import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapService extends StatefulWidget {
  const MapService({super.key});

  @override
  State<MapService> createState() => _MapServiceState();
}

class _MapServiceState extends State<MapService> {
  @override
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  Marker? _userLocationMarker;

  CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(27.7172, 85.3240),
    zoom: 14.4746,
  );
  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  void _getUserLocation() async {
    LocationData locationData = await Location().getLocation();
    setState(() {
      _kGooglePlex = CameraPosition(
          target: LatLng(locationData.latitude!, locationData.longitude!),
          zoom: 14.4746);
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        myLocationEnabled: true,
        mapType: MapType.terrain,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          setState(() {
            _userLocationMarker = Marker(
              markerId: MarkerId('userLocation'),
              position: _kGooglePlex.target,
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueBlue), // Custom marker icon
            );
          });
          _controller.complete(controller);
        },
        onCameraMove: (CameraPosition position) {},
        markers: _userLocationMarker != null
            ? Set<Marker>.of([_userLocationMarker!])
            : Set<Marker>(),
      ),
    );
  }
}
