import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ShowLocationButton extends StatelessWidget {
  final double latitude;
  final double longitude;

  const ShowLocationButton({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  Future<void> _launchURL() async {
    final url = 'https://www.google.com/maps?q=$latitude,$longitude';

    // Check if the URL can be launched
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () async {
        try {
          await _launchURL();
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error launching URL: $e')),
          );
        }
      },
      icon: const Icon(Icons.location_on),
      label: const Text('Show Location'),
    );
  }
}
