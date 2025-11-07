import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class ApiService {
  // Mock API - Load from JSON files
  // TODO: Replace with actual API calls using Dio when backend is ready
  
  Future<Map<String, dynamic>> loadJsonAsset(String path) async {
    try {
      final jsonString = await rootBundle.loadString(path);
      return json.decode(jsonString);
    } catch (e) {
      throw Exception('Failed to load $path: $e');
    }
  }

  Future<List<dynamic>> loadJsonListAsset(String path) async {
    try {
      final jsonString = await rootBundle.loadString(path);
      return json.decode(jsonString) as List<dynamic>;
    } catch (e) {
      throw Exception('Failed to load $path: $e');
    }
  }

  // Simulate API delay
  Future<void> _simulateDelay() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }

  // TODO: Replace with actual Dio-based API calls
  // Example:
  // Future<Response> get(String endpoint) async {
  //   final dio = Dio();
  //   return await dio.get('$baseUrl$endpoint');
  // }
}
