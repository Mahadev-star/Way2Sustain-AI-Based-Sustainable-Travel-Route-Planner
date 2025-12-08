import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Check if user exists in Firestore
  Future<bool> _userExistsInFirestore(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    return doc.exists;
  }

  // Create user profile in Firestore
  Future<void> _createUserProfile(User user, {String? name}) async {
    await _firestore.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'email': user.email,
      'displayName': name ?? user.displayName ?? 'Traveler',
      'photoURL': user.photoURL,
      'createdAt': FieldValue.serverTimestamp(),
      'lastLogin': FieldValue.serverTimestamp(),
      'isGuest': false,
      'carbonSaved': 0.0, // Total CO2 saved in kg
      'tripsCompleted': 0,
      'ecoScore': 0,
      'preferences': {
        'transportMode': 'balanced', // balanced, eco-friendly, fastest
        'notifications': true,
        'darkMode': true,
      },
    });
  }

  // Update user profile
  Future<void> updateUserProfile(Map<String, dynamic> data) async {
    final user = currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update(data);
    }
  }

  // Get user data
  Future<Map<String, dynamic>?> getUserData(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    return doc.data();
  }

  // ========== EMAIL/PASSWORD AUTH ==========

  Future<User?> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      // Create user in Firebase Auth
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update display name
      await result.user?.updateDisplayName(name);

      // Create user profile in Firestore
      await _createUserProfile(result.user!, name: name);

      return result.user;
    } catch (e) {
      // ignore: avoid_print
      print('Sign up error: $e');
      throw _handleAuthError(e);
    }
  }

  Future<User?> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update last login time
      await _updateLastLogin(result.user!.uid);

      return result.user;
    } catch (e) {
      // ignore: avoid_print
      print('Login error: $e');
      throw _handleAuthError(e);
    }
  }

  // ========== SOCIAL AUTH ==========

  Future<User?> signInWithGoogle() async {
    try {
      // Trigger Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      // Get authentication details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create Firebase credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with Google credentials
      final UserCredential result =
          await _auth.signInWithCredential(credential);

      // Check if user exists in Firestore, if not create profile
      if (!await _userExistsInFirestore(result.user!.uid)) {
        await _createUserProfile(result.user!);
      } else {
        await _updateLastLogin(result.user!.uid);
      }

      return result.user;
    } catch (e) {
      // ignore: avoid_print
      print('Google sign in error: $e');
      throw _handleAuthError(e);
    }
  }

  Future<User?> signInWithFacebook() async {
    try {
      // Trigger Facebook login flow
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      if (result.status == LoginStatus.success) {
        // Create Firebase credential
        final OAuthCredential credential = FacebookAuthProvider.credential(
          result.accessToken!.token,
        );

        // Sign in to Firebase with Facebook credentials
        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);

        // Check if user exists in Firestore, if not create profile
        if (!await _userExistsInFirestore(userCredential.user!.uid)) {
          await _createUserProfile(userCredential.user!);
        } else {
          await _updateLastLogin(userCredential.user!.uid);
        }

        return userCredential.user;
      }
      return null;
    } catch (e) {
      // ignore: avoid_print
      print('Facebook sign in error: $e');
      throw _handleAuthError(e);
    }
  }

  // ========== GUEST LOGIN ==========

  Future<User?> loginAsGuest() async {
    try {
      // Create anonymous user
      final UserCredential result = await _auth.signInAnonymously();

      // Create guest profile in Firestore
      await _firestore.collection('users').doc(result.user!.uid).set({
        'uid': result.user!.uid,
        'isGuest': true,
        'createdAt': FieldValue.serverTimestamp(),
        'lastLogin': FieldValue.serverTimestamp(),
        'displayName': 'Eco Traveler',
        'carbonSaved': 0.0,
        'tripsCompleted': 0,
        'ecoScore': 0,
        'preferences': {
          'transportMode': 'balanced',
          'notifications': false,
          'darkMode': true,
        },
      });

      return result.user;
    } catch (e) {
      // ignore: avoid_print
      print('Guest login error: $e');
      throw _handleAuthError(e);
    }
  }

  // ========== PASSWORD RESET ==========

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      // ignore: avoid_print
      print('Password reset error: $e');
      throw _handleAuthError(e);
    }
  }

  // ========== UPDATE PROFILE ==========

  Future<void> updateEmail(String newEmail) async {
    try {
      await currentUser?.verifyBeforeUpdateEmail(newEmail);
    } catch (e) {
      // ignore: avoid_print
      print('Update email error: $e');
      throw _handleAuthError(e);
    }
  }

  Future<void> updatePassword(String newPassword) async {
    try {
      await currentUser?.updatePassword(newPassword);
    } catch (e) {
      // ignore: avoid_print
      print('Update password error: $e');
      throw _handleAuthError(e);
    }
  }

  // ========== SIGN OUT ==========

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      await FacebookAuth.instance.logOut();
    } catch (e) {
      // ignore: avoid_print
      print('Sign out error: $e');
      rethrow;
    }
  }

  // ========== DELETE ACCOUNT ==========

  Future<void> deleteAccount() async {
    try {
      final user = currentUser;
      if (user != null) {
        // Delete from Firestore
        await _firestore.collection('users').doc(user.uid).delete();

        // Delete from Firebase Auth
        await user.delete();
      }
    } catch (e) {
      // ignore: avoid_print
      print('Delete account error: $e');
      throw _handleAuthError(e);
    }
  }

  // ========== HELPER METHODS ==========

  Future<void> _updateLastLogin(String userId) async {
    await _firestore.collection('users').doc(userId).update({
      'lastLogin': FieldValue.serverTimestamp(),
    });
  }

  String _handleAuthError(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-email':
          return 'Invalid email address format.';
        case 'user-disabled':
          return 'This account has been disabled.';
        case 'user-not-found':
          return 'No account found with this email.';
        case 'wrong-password':
          return 'Incorrect password.';
        case 'email-already-in-use':
          return 'An account already exists with this email.';
        case 'weak-password':
          return 'Password should be at least 6 characters.';
        case 'operation-not-allowed':
          return 'Email/password accounts are not enabled.';
        case 'network-request-failed':
          return 'Network error. Please check your connection.';
        default:
          return 'Authentication failed: ${error.message}';
      }
    }
    return 'An unexpected error occurred. Please try again.';
  }
}
