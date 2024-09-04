import 'package:firebase_auth/firebase_auth.dart';

import 'package:domain_models/domain_models.dart' as domain;

class AuthService {
  const AuthService();

  // static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user
  // domain.User? get currentUser => _auth.currentUser?.toDomain;

  // // Get user role from custom claims
  // Future<String?> getUserRole() async {

  //   User? user = _auth.currentUser;
  //   if (user != null) {
  //     IdTokenResult tokenResult = await user.getIdTokenResult();
  //     return tokenResult.claims?['role'];
  //   }
  //   return null;
  // }

  // Sign in with email and password
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await Future.delayed(
        const Duration(seconds: 2)); // TODO: remove for production

    // try {
    //   await _auth.signInWithEmailAndPassword(email: email, password: password);
    // } on FirebaseAuthException catch (_) {
    //   throw domain.InvalidCredentialException();
    // }
  }

  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    await Future.delayed(
        const Duration(seconds: 2)); // TODO: remove for production

    // try {
    //   _auth.createUserWithEmailAndPassword(email: email, password: password);
    // } catch (e) {
    //   rethrow;
    // }
  }

  // Sign in with Google
  Future<void> signInWithGoogle() async {
    await Future.delayed(
        const Duration(seconds: 2)); // TODO: remove for production

    // final webClientId = Platform.environment['GOOGLE_AUTH_WEB_CLIENT_ID'];

    // try {
    //   final googleUser =
    //       await GoogleSignIn(clientId: webClientId).signInSilently();
    //   if (googleUser == null) throw domain.GoogleSignInCancelByUser();

    //   final GoogleSignInAuthentication googleAuth =
    //       await googleUser.authentication;
    //   final AuthCredential credential = GoogleAuthProvider.credential(
    //     accessToken: googleAuth.accessToken,
    //     idToken: googleAuth.idToken,
    //   );

    //   await _auth.signInWithCredential(credential);
    // } catch (e) {
    //   rethrow;
    // }
  }

  // Sign out
  Future<void> signOut() async {
    await Future.delayed(
        const Duration(seconds: 2)); // TODO: remove for production

    // await _auth.signOut();
    // await GoogleSignIn().signOut();
  }

  Future<void> requestPasswordResetEmail({required String email}) async {
    await Future.delayed(
        const Duration(seconds: 2)); // TODO: remove for production

    // try {
    //   await _auth.sendPasswordResetEmail(email: email);
    // } catch (e) {
    //   throw Exception("Failed to send password reset email: $e");
    // }
  }

  Future<void> registerRetailer({
    required String businessName,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    await Future.delayed(
        const Duration(seconds: 2)); // TODO: remove for production
  }
}

// convert the firebase user model to the app domain user.
extension on User {
  domain.User get toDomain => domain.User(
        id: uid,
        email: email,
        username: displayName,
        photoURL: photoURL,
      );
}
