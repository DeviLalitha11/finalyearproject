import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Adds user data to Firestore under the "users" collection
  /// Fields: userId, name, email, age, gender, healthData, createdAt
  Future<void> addUserDataToFirebase({
    required String userId,
    required String name,
    required String email,
    int? age,
    String? gender,
    Map<String, dynamic>? healthData,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'userId': userId,
        'name': name,
        'email': email,
        'age': age,
        'gender': gender,
        'healthData': healthData,
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true)); // Merge to avoid overwriting existing data
    } catch (e) {
      throw 'Failed to save user data to Firebase: $e';
    }
  }

  /// Retrieves user data from Firestore
  Future<Map<String, dynamic>?> getUserData(String userId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(userId)
          .get();
      return doc.data() as Map<String, dynamic>?;
    } catch (e) {
      throw 'Failed to retrieve user data: $e';
    }
  }
}
