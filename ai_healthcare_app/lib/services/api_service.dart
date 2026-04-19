import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class ApiService {
  static String get baseUrl => ApiConfig.baseUrl;

  /// Unified analyze endpoint - recommended
  static Future<Map<String, dynamic>> analyze(
      Map<String, dynamic> payload) async {
    final response = await http.post(
      Uri.parse("$baseUrl/analyze"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(payload),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> predictHeart(
      List<double> features) async {
    final response = await http.post(
      Uri.parse("$baseUrl/predict/heart"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"features": features}),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> predictDiabetes(
      List<double> features) async {
    final response = await http.post(
      Uri.parse("$baseUrl/predict/diabetes"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"features": features}),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> predictKidney(
      List<double> features) async {
    final response = await http.post(
      Uri.parse("$baseUrl/predict/kidney"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"features": features}),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> predictThyroid(
      List<double> features) async {
    final response = await http.post(
      Uri.parse("$baseUrl/predict/thyroid"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"features": features}),
    );
    return jsonDecode(response.body);
  }
}
