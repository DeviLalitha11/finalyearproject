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

//     /// 🔧 FIX: Convert BP object → string "120/85"
//     String? bloodPressure;
//     if (health['bloodPressure'] != null &&
//         health['bloodPressure']['systolic'] != null &&
//         health['bloodPressure']['diastolic'] != null) {
//       bloodPressure =
//           "${health['bloodPressure']['systolic']}/${health['bloodPressure']['diastolic']}";
//     }

//     final response = await http.post(
//       Uri.parse('$_baseUrl/analyze'),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         "heartRate": health['heartRate'],
//         "bloodPressure": bloodPressure,
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
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AIAnalysisService {
  static const String baseUrl = 'http://127.0.0.1:8000'; // Replace with your actual backend URL

  static Future<Map<String, dynamic>> runAnalysis() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not logged in');

      // Fetch user's health data from Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!userDoc.exists) throw Exception('User data not found');

      final userData = userDoc.data() as Map<String, dynamic>;
      final healthData = userData['healthData'] as Map<String, dynamic>? ?? {};

      // Prepare data for AI analysis
      final analysisPayload = {
        'heartRate': healthData['heartRate'] ?? 75,
        'bloodPressure': 
            '${healthData['bloodPressure']?['systolic'] ?? 120}/${healthData['bloodPressure']?['diastolic'] ?? 80}',
        'bloodSugar': healthData['bloodSugar'] ?? 100,
        'bmi': healthData['bmi'] ?? 22,
        'temperature': healthData['temperature'] ?? 98.6,
        'oxygen': healthData['oxygen'] ?? 98,
        'symptoms': healthData['symptoms'] ?? [],
      };

      // Call AI backend
      final response = await http.post(
        Uri.parse('$baseUrl/analyze'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(analysisPayload),
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        
        // Save AI analysis to health_history with suggestions
        await _saveAnalysisToHistory(result, analysisPayload);
        
        return result;
      } else {
        throw Exception('Analysis failed: ${response.statusCode}');
      }
    } catch (e) {
      print('AI Analysis Error: $e');
      // Return a default response if analysis fails
      return {
        'status': 'error',
        'riskLevel': 'Low',
        'diseases': [],
        'suggestions': [
          'Unable to complete AI analysis',
          'Please check your internet connection',
          'Try again later'
        ],
        'explanations': []
      };
    }
  }

  static Future<void> _saveAnalysisToHistory(
    Map<String, dynamic> aiResult,
    Map<String, dynamic> healthData,
  ) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      // Parse blood pressure
      final bpParts = (healthData['bloodPressure'] as String).split('/');
      final systolic = int.tryParse(bpParts[0]) ?? 120;
      final diastolic = int.tryParse(bpParts[1]) ?? 80;

      // Create health history record with AI advice
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('health_history')
          .add({
        'bloodPressure': {
          'systolic': systolic,
          'diastolic': diastolic,
        },
        'oxygen': healthData['oxygen'],
        'bloodSugar': healthData['bloodSugar'],
        'heartRate': healthData['heartRate'],
        'bmi': healthData['bmi'],
        'temperature': healthData['temperature'],
        'symptoms': healthData['symptoms'] ?? [],
        'sugarLevel': _getSugarLevel(healthData['bloodSugar']),
        'aiAdvice': aiResult['suggestions'] ?? [], // Store as list
        'aiRiskLevel': aiResult['riskLevel'],
        'aiDiseases': aiResult['diseases'] ?? [],
        'aiExplanations': aiResult['explanations'] ?? [],
        'updatedAt': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error saving analysis to history: $e');
    }
  }

  static String _getSugarLevel(dynamic bloodSugar) {
    if (bloodSugar == null) return 'Unknown';
    final sugar = bloodSugar is int ? bloodSugar : double.tryParse(bloodSugar.toString()) ?? 0;
    
    if (sugar < 70) return 'Low';
    if (sugar < 100) return 'Normal';
    if (sugar < 125) return 'Pre-diabetic';
    return 'High';
  }
}