import 'package:flutter/material.dart';

class UserProfileImage extends StatelessWidget {
  const UserProfileImage({super.key, this.photoUrl});

  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final double radius =
        width < 600 ? MediaQuery.of(context).size.width * 0.2 : 120;
    return Center(
      child: CircleAvatar(
        radius: radius,
        child: (photoUrl == null)
            ? Image.asset(
                'assets/user_profile_icon.png',
                package: 'component_library',
                fit: BoxFit.cover,
              )
            : Image.network(
                photoUrl!,
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
