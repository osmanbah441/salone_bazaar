import 'package:bazaar_api/src/auth_service.dart';
import 'package:bazaar_api/src/cart_repository.dart';
import 'package:bazaar_api/src/order_repository.dart';
import 'package:bazaar_api/src/products_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

class BazaarApi {
  const BazaarApi()
      : auth = const AuthService(),
        product = const ProductsRepository(),
        cart = const CartRepository(),
        order = const OrderRepository();

  final AuthService auth;
  final ProductsRepository product;
  final CartRepository cart;
  final OrderRepository order;

  static Future<void> initializeApi({bool isDebug = true}) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    if (isDebug) {
      await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
      FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
    }
  }
}
