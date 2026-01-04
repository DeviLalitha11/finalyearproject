// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';

// class AuthService extends ChangeNotifier {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   late final GoogleSignIn _googleSignIn;

//   AuthService() {
//     _initializeGoogleSignIn();
//   }

//   void _initializeGoogleSignIn() {
//     _googleSignIn = GoogleSignIn(
//       clientId: '1:558194635350:web:89194cba32790560b0c1f7',
//     );
//   }

//   User? get currentUser => _auth.currentUser;
//   bool get isAuthenticated => currentUser != null;

//   Stream<User?> get authStateChanges => _auth.authStateChanges();

//   // Email/Password Sign In
//   Future<UserCredential?> signInWithEmailAndPassword(
//     String email,
//     String password,
//   ) async {
//     try {
//       final result = await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       notifyListeners();
//       return result;
//     } catch (e) {
//       throw _handleAuthError(e);
//     }
//   }

//   // Email/Password Sign Up
//   Future<UserCredential?> createUserWithEmailAndPassword(
//     String email,
//     String password,
//   ) async {
//     try {
//       final result = await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       notifyListeners();
//       return result;
//     } catch (e) {
//       throw _handleAuthError(e);
//     }
//   }

//   // Google Sign In
//   Future<UserCredential?> signInWithGoogle() async {
//     try {
//       // Trigger the authentication flow
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

//       if (googleUser == null) {
//         throw 'Google sign in was cancelled';
//       }

//       // Obtain the auth details from the request
//       final GoogleSignInAuthentication googleAuth =
//           await googleUser.authentication;

//       // Create a new credential
//       final credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       // Sign in to Firebase with the credential
//       final result = await _auth.signInWithCredential(credential);
//       notifyListeners();
//       return result;
//     } catch (e) {
//       throw _handleAuthError(e);
//     }
//   }

//   // Apple Sign In
//   Future<UserCredential?> signInWithApple() async {
//     try {
//       final AuthorizationCredentialAppleID credential =
//           await SignInWithApple.getAppleIDCredential(
//             scopes: [
//               AppleIDAuthorizationScopes.email,
//               AppleIDAuthorizationScopes.fullName,
//             ],
//           );

//       // Create OAuthProvider credential
//       final oauthCredential = OAuthProvider('apple.com').credential(
//         idToken: credential.identityToken,
//         accessToken: credential.authorizationCode,
//       );

//       // Sign in to Firebase with the credential
//       final result = await _auth.signInWithCredential(oauthCredential);
//       notifyListeners();
//       return result;
//     } catch (e) {
//       throw _handleAuthError(e);
//     }
//   }

//   // Password Reset
//   Future<void> sendPasswordResetEmail(String email) async {
//     try {
//       await _auth.sendPasswordResetEmail(email: email);
//     } catch (e) {
//       throw _handleAuthError(e);
//     }
//   }

//   // Update Password
//   Future<void> updatePassword(String newPassword) async {
//     try {
//       await currentUser?.updatePassword(newPassword);
//       notifyListeners();
//     } catch (e) {
//       throw _handleAuthError(e);
//     }
//   }

//   // Sign Out
//   Future<void> signOut() async {
//     try {
//       await _googleSignIn.signOut();
//       await _auth.signOut();
//       notifyListeners();
//     } catch (e) {
//       throw _handleAuthError(e);
//     }
//   }

//   // Delete Account
//   Future<void> deleteAccount() async {
//     try {
//       await currentUser?.delete();
//       notifyListeners();
//     } catch (e) {
//       throw _handleAuthError(e);
//     }
//   }

//   // Update Profile
//   Future<void> updateProfile({String? displayName, String? photoURL}) async {
//     try {
//       await currentUser?.updateDisplayName(displayName);
//       await currentUser?.updatePhotoURL(photoURL);
//       notifyListeners();
//     } catch (e) {
//       throw _handleAuthError(e);
//     }
//   }

//   // Error Handling
//   String _handleAuthError(dynamic error) {
//     if (error is FirebaseAuthException) {
//       switch (error.code) {
//         case 'user-not-found':
//           return 'No user found with this email.';
//         case 'wrong-password':
//           return 'Wrong password provided.';
//         case 'email-already-in-use':
//           return 'An account already exists with this email.';
//         case 'weak-password':
//           return 'The password provided is too weak.';
//         case 'invalid-email':
//           return 'The email address is not valid.';
//         case 'user-disabled':
//           return 'This user account has been disabled.';
//         case 'too-many-requests':
//           return 'Too many requests. Try again later.';
//         case 'operation-not-allowed':
//           return 'This sign-in method is not enabled.';
//         default:
//           return 'An error occurred: ${error.message}';
//       }
//     }
//     return error.toString();
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  late final GoogleSignIn _googleSignIn;

  AuthService() {
    _googleSignIn = GoogleSignIn();
  }

  User? get currentUser => _auth.currentUser;
  bool get isAuthenticated => currentUser != null;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // 🔹 EMAIL SIGN UP
  Future<UserCredential?> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      notifyListeners();
      return result;
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // 🔹 EMAIL LOGIN
  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      notifyListeners();
      return cred;
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // 🔹 GOOGLE SIGN IN
  Future<UserCredential> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) throw 'Google sign-in cancelled';

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCred = await _auth.signInWithCredential(credential);

      final doc = _db.collection('users').doc(userCred.user!.uid);

      if (!(await doc.get()).exists) {
        await doc.set({
          'uid': userCred.user!.uid,
          'name': userCred.user!.displayName,
          'email': userCred.user!.email,
          'photo': userCred.user!.photoURL,
          'provider': 'google',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      notifyListeners();
      return userCred;
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // 🔹 APPLE SIGN IN
  Future<UserCredential> signInWithApple() async {
    try {
      final appleCred = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oauth = OAuthProvider('apple.com').credential(
        idToken: appleCred.identityToken,
        accessToken: appleCred.authorizationCode,
      );

      final userCred = await _auth.signInWithCredential(oauth);

      await _db.collection('users').doc(userCred.user!.uid).set({
        'uid': userCred.user!.uid,
        'email': userCred.user!.email,
        'provider': 'apple',
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      notifyListeners();
      return userCred;
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    notifyListeners();
  }

  String _handleAuthError(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return 'No user found with this email.';
        case 'wrong-password':
          return 'Incorrect password.';
        case 'email-already-in-use':
          return 'Email already registered.';
        case 'weak-password':
          return 'Password is too weak.';
        case 'invalid-email':
          return 'Invalid email address.';
        default:
          return error.message ?? 'Authentication failed';
      }
    }
    return error.toString();
  }
}
