import 'package:domain_models/domain_models.dart' as domain;
import 'package:firebase_auth/firebase_auth.dart';

// use to convert the firebase user to a domain user
extension UserExtenstion on User {
  Future<domain.UserRole> getUserRole() async {
    IdTokenResult tokenResult = await getIdTokenResult();
    final role = tokenResult.claims?['role'];
    if (role == null) return domain.UserRole.customer;
    switch (role as String) {
      case "admin":
        return domain.UserRole.admin;
      case "deliveryCrew":
        return domain.UserRole.deliveryCrew;
      case "retailer":
        return domain.UserRole.retailer;
      default:
        return domain.UserRole.customer;
    }
  }

  domain.User get toDomain => domain.User(
        uid: uid,
        email: email,
        displayName: displayName,
        photoURL: photoURL,
        emailVerified: emailVerified,
      );
}
