// User class to store Firebase user information

class User {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoURL;
  final bool emailVerified;

  User({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.photoURL,
    required this.emailVerified,
  });

  factory User.fromMap(Map<String, dynamic> map) => User(
      uid: map['uid'],
      email: map['email'],
      displayName: map['displayName'],
      photoURL: map['photoURL'],
      emailVerified: map['emailVerified']);
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
