import 'package:domain_models/domain_models.dart' as domain;
import 'package:firebase_auth/firebase_auth.dart';

import 'user_extenstion.dart';

class UserRepository {
  const UserRepository();
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  domain.User? get currentUser => _auth.currentUser?.toDomain;

  Future<domain.UserRole> getUserRole() => _auth.currentUser!.getUserRole();

  Future<void> updateDisplayName(String displayName) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw const domain.UserAuthenticationRequiredException();
    }

    await user.updateDisplayName(displayName);
    await user.reload();
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (_) {
      throw const domain.InvalidCredentialException();
    }
  }

  Future<void> createBuyerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (_) {
      throw const domain.EmailAlreadyRegisteredException();
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      // this work only for web we need to implement for mobile
      final authProvider = GoogleAuthProvider();
      await _auth.signInWithPopup(authProvider);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async => await _auth.signOut();

  Future<void> requestPasswordResetEmail(String email) async =>
      await _auth.sendPasswordResetEmail(email: email);

  Future<void> createSellerAccount({
    required String email,
    required String password,
    required String businessName,
    required String phoneNumber,
  }) async {
    throw UnimplementedError();
  }
}
