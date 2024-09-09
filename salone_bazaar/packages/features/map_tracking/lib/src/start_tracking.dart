import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class StartDeliveryWidget extends StatefulWidget {
  final String orderId;
  final Function(double, double) onLocationUpdate;

  const StartDeliveryWidget({
    super.key,
    required this.orderId,
    required this.onLocationUpdate,
  });

  @override
  State<StartDeliveryWidget> createState() => _StartDeliveryWidgetState();
}

class _StartDeliveryWidgetState extends State<StartDeliveryWidget> {
  bool _isTracking = false;
  StreamSubscription<Position>? _positionStream;

  @override
  void dispose() {
    // Cancel the location stream when the widget is disposed
    _positionStream?.cancel();
    super.dispose();
  }

  Future<void> _checkLocationPermissionAndStart() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location services are disabled.')),
      );
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permission denied.')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Location permission permanently denied.')),
      );
      return;
    }

    // Permission granted, start the delivery tracking
    _startDeliveryTracking();
  }

  void _startDeliveryTracking() {
    if (_isTracking) return; // Prevent multiple listeners

    setState(() {
      _isTracking = true;
    });

    // Start listening to position updates
    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 50, // Update every 50 meters
      ),
    ).listen((Position position) {
      widget.onLocationUpdate(position.latitude, position.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _isTracking
          ? null // Disable button while tracking
          : _checkLocationPermissionAndStart,
      child: _isTracking
          ? const Text(
              'Delivery Started') // Change button text after tracking starts
          : const Text('Start Delivery'),
    );
  }
}
