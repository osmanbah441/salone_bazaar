import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

/// A widget that allows users to select a location on a Google Map.
///
/// Use the [LocationPicker] widget in your UI:
///  LocationPicker()
///
/// Access the selected latitude and longitude using the static getter methods:
///
///   double latitude = LocationPicker.latitude;
///   double longitude = LocationPicker.longitude;
///
class LocationPicker extends StatefulWidget {
  const LocationPicker({super.key});

  // Getter methods to access the selected latitude and longitude
  static double get latitude => _latitude;
  static double get longitude => _longitude;

  static double _latitude = 0.0;
  static double _longitude = 0.0;

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  GoogleMapController? _mapController;
  LatLng _selectedLocation = const LatLng(0, 0);
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _setInitialLocation(); // Fetch user's location on initialization
  }

  void _updateLocationGetter() {
    LocationPicker._latitude = _selectedLocation.latitude;
    LocationPicker._longitude = _selectedLocation.longitude;
  }

  Future<void> _setInitialLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showError('Location services are disabled.');
      return;
    }

    // Check for location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showError('Location permission denied.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showError('Location permission permanently denied.');
      return;
    }

    // If permissions are granted, get the current location
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _selectedLocation = LatLng(position.latitude, position.longitude);
        _updateLocationGetter();
        _isLoading = false;
      });

      _mapController?.animateCamera(
        CameraUpdate.newLatLng(_selectedLocation),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showError('Failed to get current location');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Failed to get current location')),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  void _onMapTap(LatLng latLng) {
    setState(() {
      _selectedLocation = latLng;
      _updateLocationGetter();
    });

    // Move the camera to the selected location
    _mapController?.animateCamera(
      CameraUpdate.newLatLng(latLng),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 380,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(16),
      ),
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              mapType: MapType.normal,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              initialCameraPosition: CameraPosition(
                target: _selectedLocation,
                zoom: 14,
              ),
              onMapCreated: (controller) {
                _mapController = controller;

                if (_selectedLocation.latitude != 0 &&
                    _selectedLocation.longitude != 0) {
                  _mapController?.animateCamera(
                    CameraUpdate.newLatLng(_selectedLocation),
                  );
                }
              },
              onTap: _onMapTap,
              markers: {
                Marker(
                  markerId: const MarkerId('selectedlocation'),
                  position: _selectedLocation,
                ),
              },
            ),
    );
  }
}
