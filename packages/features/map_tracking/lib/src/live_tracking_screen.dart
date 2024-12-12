import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:map_tracking/model/my_order.dart';

class LiveTrackingScreen extends StatefulWidget {
  final MyOrder order;

  const LiveTrackingScreen({super.key, required this.order});

  @override
  State<LiveTrackingScreen> createState() => _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends State<LiveTrackingScreen> {
  late LatLng destination;
  LatLng deliveryLocation = const LatLng(0, 0);
  GoogleMapController? mapController;

  double remainingDistance = 0;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference orderTrackingCollection;
  final location = Location();

  @override
  void initState() {
    super.initState();
    destination = LatLng(widget.order.latitude, widget.order.longitude);
    orderTrackingCollection = firestore.collection('orderTracking');
    startTracking(widget.order.id);
  }

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }

  void startTracking(String orderId) {
    orderTrackingCollection.doc(orderId).snapshots().listen((data) {
      if (data.exists) {
        final trackingData = data.data() as Map<String, dynamic>;
        updateUIWithLocation(
            trackingData['latitude'], trackingData['longitude']);
      } else {}
    });
  }

  void updateUIWithLocation(double latitude, double longitude) {
    setState(() {
      deliveryLocation = LatLng(latitude, longitude);
      mapController?.animateCamera(CameraUpdate.newLatLng(deliveryLocation));
      calculateRemainingDistance();
    });
  }

  void calculateRemainingDistance() {
    final distance = Geolocator.distanceBetween(
          deliveryLocation.latitude,
          deliveryLocation.longitude,
          destination.latitude,
          destination.longitude,
        ) /
        1000; // Convert to kilometers

    setState(() {
      remainingDistance = distance;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Tracking'),
      ),
      body: Stack(
        children: [
          _Map(
            onMapCreated: (ctl) => mapController = ctl,
            destination: destination,
            deliveryLocation: deliveryLocation,
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 16,
            child: _RemainDistance(remainingDistance: remainingDistance),
          ),
        ],
      ),
    );
  }
}

class _Map extends StatelessWidget {
  const _Map({
    required this.onMapCreated,
    required this.destination,
    required this.deliveryLocation,
  });

  final Function(GoogleMapController) onMapCreated;
  final LatLng destination;
  final LatLng deliveryLocation;

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: MapType.normal,
      onMapCreated: onMapCreated,
      initialCameraPosition: CameraPosition(
        target: destination,
        zoom: 12,
      ),
      markers: {
        Marker(
          markerId: const MarkerId('Destination'),
          position: destination,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: InfoWindow(
              title: 'Destination',
              snippet:
                  'Lat: ${destination.latitude}, long: ${destination.longitude}'),
        ),
        Marker(
          markerId: const MarkerId('Delivery'),
          position: deliveryLocation,
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
          infoWindow: InfoWindow(
              title: 'Delivery',
              snippet:
                  'Lat: ${deliveryLocation.latitude}, long: ${deliveryLocation.longitude}'),
        ),
      },
    );
  }
}

class _RemainDistance extends StatelessWidget {
  const _RemainDistance({required this.remainingDistance});

  final double remainingDistance;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.teal,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
            'Remaining Distance: ${remainingDistance.toStringAsFixed(2)} Kilometers'),
      ),
    );
  }
}
