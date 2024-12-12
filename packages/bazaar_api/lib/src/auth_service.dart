import 'package:domain_models/domain_models.dart' as domain;
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  const AuthService();

  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Update display name
  Future<void> updateDisplayName(String displayName) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.updateDisplayName(displayName);
        await user.reload();
      }
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    } catch (e) {
      throw const domain.UndefinedRestaurantAuthException();
    }
  }

  // Error handling
  Exception _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found' || 'wrong-password' || 'invalid-credential':
        return const domain.InvalidCredentialException();
      case 'email-already-in-use':
        return const domain.EmailAlreadyRegisteredException();
      default:
        return const domain.UndefinedRestaurantAuthException();
    }
  }

  // Get current user
  domain.User? get currentUser => _auth.currentUser?.toDomain;

  // // Get user role from custom claims
  Future<domain.UserRole> getUserRole() async {
    final user = _auth.currentUser;
    if (user == null) throw const domain.UserAuthenticationRequiredException();

    IdTokenResult tokenResult = await user.getIdTokenResult();
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

  // Sign in with email and password
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (_) {
      throw const domain.InvalidCredentialException();
    }
  }

  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      // Sign in using Firebase Authentication
      await _auth.signInWithPopup(GameCenterAuthProvider());
    } catch (e) {
      rethrow;
    }
  }

  // Sign in with Google
  // Future<void> signInWithGoogle() async {
  //   print('signed in with google');

  //   try {
  //     final googleUser = await GoogleSignIn().signInSilently();
  //     if (googleUser == null) throw domain.GoogleSignInCancelByUser();

  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser.authentication;
  //     final AuthCredential credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );

  //     await _auth.signInWithCredential(credential);
  //   } catch (e) {
  //     print(e);
  //     rethrow;
  //   }
  // }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
    // await GoogleSignIn().signOut();
  }

  Future<void> requestPasswordResetEmail({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception("Failed to send password reset email: $e");
    }
  }

  Future<void> registerRetailer({
    required String businessName,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {}
}

// convert the firebase user model to the app domain user.
extension on User {
  domain.User get toDomain => domain.User(
        uid: uid,
        email: email,
        displayName: displayName,
        photoURL: photoURL,
        emailVerified: emailVerified,
      );
}
