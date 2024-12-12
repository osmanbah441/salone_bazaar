import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:map_tracking/model/my_order.dart';

import 'start_tracking.dart';

class DeliveryBoyPage extends StatefulWidget {
  const DeliveryBoyPage({super.key});

  @override
  State<DeliveryBoyPage> createState() => _DeliveryBoyPageState();
}

class _DeliveryBoyPageState extends State<DeliveryBoyPage> {
  final TextEditingController orderIdController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  late CollectionReference orderCollection;
  late CollectionReference orderTrackingCollection;

  String phoneNumber = '';
  double amountToCollect = 0;
  double customerLatitude = 37.7749;
  double customerLongitude = -122.4194;
  bool showDeliveryInfo = false;
  bool isTrackingStarted = false;

  @override
  void initState() {
    super.initState();
    orderCollection = firestore.collection('order');
    orderTrackingCollection = firestore.collection('orderTracking');
  }

  // Function to get the order details by order ID
  void getOrderById() async {
    try {
      final query = await orderCollection
          .where('id', isEqualTo: orderIdController.text)
          .get();
      if (query.docs.isNotEmpty) {
        final order =
            MyOrder.fromJson(query.docs.first.data() as Map<String, dynamic>);
        setState(() {
          phoneNumber = order.phone;
          amountToCollect = order.amount;
          customerLatitude = order.latitude;
          customerLongitude = order.longitude;
          showDeliveryInfo = true;
          isTrackingStarted =
              false; // Reset tracking status when a new order is fetched
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  // Function to update Firebase with new location data
  void saveOrUpdateMyOrderLocation(
      String orderId, double latitude, double longitude) async {
    try {
      final docRef = orderTrackingCollection.doc(orderId);
      await firestore.runTransaction((transaction) async {
        final query = await transaction.get(docRef);
        if (query.exists) {
          transaction.update(docRef, {
            'latitude': latitude,
            'longitude': longitude,
          });
        } else {
          transaction.set(docRef, {
            'orderId': orderId,
            'latitude': latitude,
            'longitude': longitude,
          });
        }
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Delivery Boy App')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text('Enter Order ID'),
            TextField(
              controller: orderIdController,
              decoration: const InputDecoration(labelText: 'Order ID'),
            ),
            ElevatedButton(
              onPressed: getOrderById,
              child: const Text('Get Order'),
            ),
            if (showDeliveryInfo) ...[
              // Show delivery information once the order is fetched
              Text('Phone: $phoneNumber'),
              Text('Amount: $amountToCollect'),
              Text(
                  'Customer Location: ($customerLatitude, $customerLongitude)'),
              ElevatedButton(
                onPressed: isTrackingStarted
                    ? null // Disable button if tracking is already started
                    : () {
                        setState(() {
                          isTrackingStarted = true;
                        });
                      },
                child: isTrackingStarted
                    ? const Text('Tracking Started')
                    : const Text('Start Tracking'),
              ),
              if (isTrackingStarted)
                StartDeliveryWidget(
                  orderId:
                      orderIdController.text, // Now we have a valid orderId
                  onLocationUpdate: (latitude, longitude) {
                    // Update Firebase when location changes
                    saveOrUpdateMyOrderLocation(
                        orderIdController.text, latitude, longitude);
                  },
                ),
            ],
          ],
        ),
      ),
    );
  }
}
