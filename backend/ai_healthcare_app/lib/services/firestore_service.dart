import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart' as user_model;

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // User Profile Collection
  Future<void> createUserProfile({
    required String uid,
    required String email,
    String? displayName,
    String? phone,
    String? bloodGroup,
    DateTime? dateOfBirth,
    String? address,
    String? emergencyContactName,
    String? emergencyContactPhone,
    String? allergies,
    String? medicalConditions,
  }) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'email': email,
        'displayName': displayName,
        'phone': phone,
        'bloodGroup': bloodGroup,
        'dateOfBirth': dateOfBirth?.toIso8601String(),
        'address': address,
        'emergencyContactName': emergencyContactName,
        'emergencyContactPhone': emergencyContactPhone,
        'allergies': allergies,
        'medicalConditions': medicalConditions,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Failed to create user profile: $e';
    }
  }

  Future<void> updateUserProfile({
    String? displayName,
    String? phone,
    String? bloodGroup,
    DateTime? dateOfBirth,
    String? address,
    String? emergencyContactName,
    String? emergencyContactPhone,
    String? allergies,
    String? medicalConditions,
  }) async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) throw 'User not authenticated';

      final updates = <String, dynamic>{
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (displayName != null) updates['displayName'] = displayName;
      if (phone != null) updates['phone'] = phone;
      if (bloodGroup != null) updates['bloodGroup'] = bloodGroup;
      if (dateOfBirth != null) {
        updates['dateOfBirth'] = dateOfBirth.toIso8601String();
      }
      if (address != null) updates['address'] = address;
      if (emergencyContactName != null) {
        updates['emergencyContactName'] = emergencyContactName;
      }
      if (emergencyContactPhone != null) {
        updates['emergencyContactPhone'] = emergencyContactPhone;
      }
      if (allergies != null) updates['allergies'] = allergies;
      if (medicalConditions != null) {
        updates['medicalConditions'] = medicalConditions;
      }

      await _firestore.collection('users').doc(uid).update(updates);
    } catch (e) {
      throw 'Failed to update user profile: $e';
    }
  }

  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) return null;

      final doc = await _firestore.collection('users').doc(uid).get();
      return doc.data();
    } catch (e) {
      throw 'Failed to get user profile: $e';
    }
  }

  // Health Data Collection
  Future<void> addHealthData({
    required String
    type, // 'blood_pressure', 'blood_sugar', 'temperature', 'weight'
    required Map<String, dynamic> data,
  }) async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) throw 'User not authenticated';

      await _firestore
          .collection('users')
          .doc(uid)
          .collection('health_data')
          .add({
            'type': type,
            'data': data,
            'timestamp': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      throw 'Failed to add health data: $e';
    }
  }

  Future<List<Map<String, dynamic>>> getHealthData({
    String? type,
    int? limit,
  }) async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) return [];

      Query query = _firestore
          .collection('users')
          .doc(uid)
          .collection('health_data')
          .orderBy('timestamp', descending: true);

      if (type != null) {
        query = query.where('type', isEqualTo: type);
      }

      if (limit != null) {
        query = query.limit(limit);
      }

      final snapshot = await query.get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {'id': doc.id, ...data};
      }).toList();
    } catch (e) {
      throw 'Failed to get health data: $e';
    }
  }

  // Medical Records
  Future<void> addMedicalRecord({
    required String title,
    required String description,
    String? doctorName,
    DateTime? date,
    String? fileUrl,
  }) async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) throw 'User not authenticated';

      await _firestore
          .collection('users')
          .doc(uid)
          .collection('medical_records')
          .add({
            'title': title,
            'description': description,
            'doctorName': doctorName,
            'date': date?.toIso8601String(),
            'fileUrl': fileUrl,
            'createdAt': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      throw 'Failed to add medical record: $e';
    }
  }

  Future<List<Map<String, dynamic>>> getMedicalRecords() async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) return [];

      final snapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('medical_records')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
    } catch (e) {
      throw 'Failed to get medical records: $e';
    }
  }

  // AI Analysis Results
  Future<void> saveAIAnalysisResult(Map<String, dynamic> results) async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) throw 'User not authenticated';

      await _firestore
          .collection('users')
          .doc(uid)
          .collection('ai_analyses')
          .add({'results': results, 'timestamp': FieldValue.serverTimestamp()});
    } catch (e) {
      throw 'Failed to save AI analysis result: $e';
    }
  }

  Future<void> saveAIAnalysis({
    required String analysisType,
    required Map<String, dynamic> results,
    required String recommendation,
  }) async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) throw 'User not authenticated';

      await _firestore
          .collection('users')
          .doc(uid)
          .collection('ai_analyses')
          .add({
            'analysisType': analysisType,
            'results': results,
            'recommendation': recommendation,
            'timestamp': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      throw 'Failed to save AI analysis: $e';
    }
  }

  Future<List<Map<String, dynamic>>> getAIAnalyses() async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) return [];

      final snapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('ai_analyses')
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
    } catch (e) {
      throw 'Failed to get AI analyses: $e';
    }
  }

  // Settings and Preferences
  Future<void> updateUserSettings(Map<String, dynamic> settings) async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) throw 'User not authenticated';

      await _firestore.collection('users').doc(uid).update({
        'settings': settings,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Failed to update user settings: $e';
    }
  }

  Future<Map<String, dynamic>?> getUserSettings() async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) return null;

      final doc = await _firestore.collection('users').doc(uid).get();
      return doc.data()?['settings'] as Map<String, dynamic>?;
    } catch (e) {
      throw 'Failed to get user settings: $e';
    }
  }

  // User Data Management
  Future<void> createUser(user_model.User user) async {
    try {
      await _firestore.collection('users').doc(user.id).set(user.toMap());
    } catch (e) {
      throw 'Failed to create user: $e';
    }
  }

  Future<void> updateUser(user_model.User user) async {
    try {
      await _firestore.collection('users').doc(user.id).update(user.toMap());
    } catch (e) {
      throw 'Failed to update user: $e';
    }
  }

  Future<user_model.User?> getUser(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return user_model.User.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      throw 'Failed to get user: $e';
    }
  }

  Future<user_model.User?> getCurrentUser() async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid != null) {
        return await getUser(uid);
      }
      return null;
    } catch (e) {
      throw 'Failed to get current user: $e';
    }
  }
}
