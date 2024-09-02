import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:domain_models/domain_models.dart' as domain;

class AuthService {
  const AuthService();

  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Get user role from custom claims
  Future<String?> getUserRole() async {
    User? user = _auth.currentUser;
    if (user != null) {
      IdTokenResult tokenResult = await user.getIdTokenResult();
      return tokenResult.claims?['role'];
    }
    return null;
  }

  // Sign in with email and password
  Future<domain.User?> signInWithEmailAndPassword(
      String email, String password) async {
    print(password);
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      return result.user?.toDomain;
    } catch (e) {
      throw domain.InvalidCredentialException();
    }
  }

  Future<User?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } catch (e) {
      print("Error signing up with email and password: $e");
      return null;
    }
  }

  // Sign in with Google
  Future<domain.User?> signInWithGoogle() async {
    // TODO: add client-id: for flutter web
    final webClientId = '';

    try {
      final googleUser =
          await GoogleSignIn(clientId: webClientId).signInSilently();
      if (googleUser == null) throw domain.GoogleSignInCancelByUser();

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential result = await _auth.signInWithCredential(credential);
      final user = result.user?.toDomain;
      print(
          'email: ${user?.email}, \n id: ${user?.id},  \n photo: ${user?.photoURL}');
      return result.user?.toDomain;
    } catch (e) {
      print("Error signing in with Google: $e");
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
  }

  Future<void> requestPasswordResetEmail({required String email}) async {
    print(email);
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception("Failed to send password reset email: $e");
    }
  }
}

// convert the firebase user model to the app domain user.
extension on User {
  domain.User get toDomain => domain.User(
      id: uid, email: email, username: displayName, photoURL: photoURL);
}
