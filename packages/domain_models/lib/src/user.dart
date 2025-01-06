// User class to store Firebase user information

class User {
  const User({
    this.uid,
    this.email,
    this.displayName,
    this.photoURL,
    this.emailVerified,
  });

  final String? uid;
  final String? email;
  final String? displayName;
  final String? photoURL;
  final bool? emailVerified;
}

enum UserRole {
  admin,
  deliveryCrew,
  retailer,
  customer;

  bool get isAdmin => this == UserRole.admin;
  bool get isDeliveryCrew => this == UserRole.deliveryCrew;

  bool get isAdminOrDeliveryCrew => isAdmin || isDeliveryCrew;
}
