import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';

class AuthService {
  static String get baseUrl => AppConstants.apiBaseUrl;
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
  
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', data['token']);
      await prefs.setString('user', jsonEncode(data['user']));
      return {'success': true, 'user': data['user']};
    } else {
      return {
        'success': false,
        'message': data['message'] ?? 'Login failed. Please try again.'
      };
    }
  }


  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    
    if (token != null) {
      await http.post(
        Uri.parse('$baseUrl/logout'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
    }

    await prefs.remove('auth_token');
    await prefs.remove('user');
  }

  static Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userStr = prefs.getString('user');
    if (userStr == null) return null;
    return jsonDecode(userStr);
  }

  
  static Future<String?> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('token'); 
}

  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }
}