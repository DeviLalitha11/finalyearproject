import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> addUser(String name, String email) async {
    try {
      await users.add({
        'full_name': name,
        'email': email,
        'created_at': DateTime.now(),
      });
    } catch (e) {
      rethrow; // Pass the error back to the UI to show a snackbar
    }
  }
}