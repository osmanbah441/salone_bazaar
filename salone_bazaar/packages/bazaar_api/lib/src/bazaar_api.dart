import 'package:bazaar_api/src/auth_service.dart';
import 'package:bazaar_api/src/products_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

class BazaarApi {
  const BazaarApi();

  static Future<void> initializeApi({bool isDebug = true}) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    if (isDebug) {
      await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
      FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
    }
  }

  final auth = const AuthService();

  final product = const ProductsRepository();
}
