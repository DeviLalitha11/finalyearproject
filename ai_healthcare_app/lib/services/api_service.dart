import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Change this to your backend IP if using real device
  static const String baseUrl = "http://10.0.2.2:8000";

  static Future<Map<String, dynamic>> predictHeart(
    List<double> features,
  ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/predict/heart"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"features": features}),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> predictDiabetes(
    List<double> features,
  ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/predict/diabetes"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"features": features}),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> predictKidney(
    List<double> features,
  ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/predict/kidney"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"features": features}),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> predictThyroid(
    List<double> features,
  ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/predict/thyroid"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"features": features}),
    );
    return jsonDecode(response.body);
  }
}
