import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HealthValidationService {
  static Future<bool> hasRequiredHealthData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (!doc.exists) return false;

    final data = doc.data();
    if (data == null) return false;

    final healthData = data['healthData'];

    if (healthData == null || healthData is! Map) return false;

    // ✅ REQUIRED FIELDS
    final requiredFields = [
      'heartRate',
      'bloodSugar',
      'bmi',
      'bloodPressure',
    ];

    for (final field in requiredFields) {
      if (!healthData.containsKey(field)) {
        return false;
      }
      if (healthData[field] == null) {
        return false;
      }
    }

    return true; // ✅ ALL REQUIRED DATA PRESENT
  }
}
