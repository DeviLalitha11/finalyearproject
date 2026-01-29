// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class AIAnalysisService {
//   static const String _baseUrl = 'http://localhost:8000';

//   static Future<Map<String, dynamic>> runAnalysis() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) {
//       throw Exception('User not logged in');
//     }

//     final doc = await FirebaseFirestore.instance
//         .collection('users')
//         .doc(user.uid)
//         .get();

//     final health = doc.data()?['healthData'];
//     if (health == null) {
//       throw Exception('Health data missing');
//     }

//     // 🔢 Build features array (order must match model training)
//     final features = [
//       (health['heartRate'] ?? 70).toDouble(),
//       (health['bloodSugar'] ?? 100).toDouble(),
//       (health['bmi'] ?? 22).toDouble(),
//     ];

//     final response = await http.post(
//       Uri.parse('$_baseUrl/predict/heart'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({'features': features}),
//     );

//     if (response.statusCode != 200) {
//       throw Exception('AI server error: ${response.body}');
//     }

//     final heartResult = jsonDecode(response.body);

//     return {
//       'heart_disease': heartResult['result'],
//       'recommendations': _generateRecommendations(health),
//     };
//   }

//   static String _generateRecommendations(Map<String, dynamic> health) {
//     final sugar = health['bloodSugar'] ?? 0;
//     final bmi = health['bmi'] ?? 0;

//     if (sugar > 140) {
//       return 'Reduce sugar intake, exercise daily, and monitor glucose levels.';
//     }
//     if (bmi > 25) {
//       return 'Focus on balanced diet and regular physical activity.';
//     }
//     return 'Your health indicators are stable. Maintain a healthy lifestyle.';
//   }
// }


// import 'dart:io';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class AIAnalysisService {
//   static const String _baseUrl = 'http://127.0.0.1:8000';

//   static Future<Map<String, dynamic>> runAnalysis() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) {
//       throw Exception('User not logged in');
//     }

//     final doc = await FirebaseFirestore.instance
//         .collection('users')
//         .doc(user.uid)
//         .get();

//     final health = doc.data()?['healthData'];
//     if (health == null) {
//       throw Exception('Health data missing');
//     }

//     final response = await http.post(
//       Uri.parse('$_baseUrl/analyze'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         "heartRate": health['heartRate'],
//         "bloodPressure": health['bloodPressure'],
//         "bloodSugar": health['bloodSugar'],
//         "bmi": health['bmi'],
//         "temperature": health['temperature'],
//         "oxygen": health['oxygen'],
//         "symptoms": health['symptoms'] ?? []
//       }),
//     );

//     if (response.statusCode != 200) {
//       throw Exception('AI server error: ${response.body}');
//     }

//     return jsonDecode(response.body);
//   }
// }






// import 'dart:convert';
// import 'dart:io' show Platform;

// import 'package:http/http.dart' as http;
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class AIAnalysisService {
//   /// 🔗 Platform-aware backend URL
//   static String get _baseUrl {
//     // Android emulator cannot access localhost directly
//     if (Platform.isAndroid) {
//       return 'http://10.0.2.2:8000';
//     }

//     // Web, Windows, macOS, iOS simulator
//     return 'http://127.0.0.1:8000';
//   }

//   static Future<Map<String, dynamic>> runAnalysis() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) {
//       throw Exception('User not logged in');
//     }

//     final doc = await FirebaseFirestore.instance
//         .collection('users')
//         .doc(user.uid)
//         .get();

//     final health = doc.data()?['healthData'];
//     if (health == null || health.isEmpty) {
//       throw Exception('Health data missing');
//     }

//     final uri = Uri.parse('$_baseUrl/analyze');

//     final response = await http.post(
//       uri,
//       headers: const {
//         'Content-Type': 'application/json',
//         'Accept': 'application/json',
//       },
//       body: jsonEncode({
//         "heartRate": health['heartRate'],
//         "bloodPressure": health['bloodPressure'],
//         "bloodSugar": health['bloodSugar'],
//         "bmi": health['bmi'],
//         "temperature": health['temperature'],
//         "oxygen": health['oxygen'],
//         "symptoms": health['symptoms'] ?? [],
//       }),
//     );

//     if (response.statusCode != 200) {
//       throw Exception(
//         'AI server error (${response.statusCode}): ${response.body}',
//       );
//     }

//     final decoded = jsonDecode(response.body);

//     if (decoded is! Map<String, dynamic>) {
//       throw Exception('Invalid AI response format');
//     }

//     return decoded;
//   }
// }



// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class AIAnalysisService {
//   // ⚠️ IMPORTANT: localhost does NOT work on real devices
//   // Web → 127.0.0.1 is OK
//   // Android Emulator → use 10.0.2.2
//   static const String _baseUrl = 'http://127.0.0.1:8000';

//   static Future<Map<String, dynamic>> runAnalysis() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) {
//       throw Exception('User not logged in');
//     }

//     final doc = await FirebaseFirestore.instance
//         .collection('users')
//         .doc(user.uid)
//         .get();

//     final health = doc.data()?['healthData'];
//     if (health == null) {
//       throw Exception('Health data missing');
//     }

//     final response = await http.post(
//       Uri.parse('$_baseUrl/analyze'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         "heartRate": health['heartRate'],
//         "bloodPressure": health['bloodPressure'],
//         "bloodSugar": health['bloodSugar'],
//         "bmi": health['bmi'],
//         "temperature": health['temperature'],
//         "oxygen": health['oxygen'],
//         "symptoms": health['symptoms'] ?? []
//       }),
//     );

//     if (response.statusCode != 200) {
//       throw Exception('AI server error: ${response.body}');
//     }

//     return jsonDecode(response.body);
//   }
// }










import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AIAnalysisService {
  static const String _baseUrl = 'http://127.0.0.1:8000';

  static Future<Map<String, dynamic>> runAnalysis() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    final health = doc.data()?['healthData'];
    if (health == null) {
      throw Exception('Health data missing');
    }

    /// 🔧 FIX: Convert BP object → string "120/85"
    String? bloodPressure;
    if (health['bloodPressure'] != null &&
        health['bloodPressure']['systolic'] != null &&
        health['bloodPressure']['diastolic'] != null) {
      bloodPressure =
          "${health['bloodPressure']['systolic']}/${health['bloodPressure']['diastolic']}";
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/analyze'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "heartRate": health['heartRate'],
        "bloodPressure": bloodPressure,
        "bloodSugar": health['bloodSugar'],
        "bmi": health['bmi'],
        "temperature": health['temperature'],
        "oxygen": health['oxygen'],
        "symptoms": health['symptoms'] ?? []
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('AI server error: ${response.body}');
    }

    return jsonDecode(response.body);
  }
}
