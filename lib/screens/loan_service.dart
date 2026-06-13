import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';

class LoanService {
  static String get baseUrl => AppConstants.apiBaseUrl;

  static String get createLoanUrl => '$baseUrl/loans';

  static Future<Map<String, String>> _authHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

 
  static Future<List<dynamic>> getLoans() async {
    final headers = await _authHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/loans'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['loans'] ?? [];
    }
    throw Exception('Failed to load loans: ${response.statusCode}');
  }

 
  static Future<Map<String, dynamic>> getLoan(int id) async {
    final headers = await _authHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/loans/$id'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['loan'];
    }
    throw Exception('Failed to load loan: ${response.statusCode}');
  }

  
  static Future<Map<String, dynamic>> updateLoan(
      int id, Map<String, dynamic> fields) async {
    final headers = await _authHeaders();
    final response = await http.put(
      Uri.parse('$baseUrl/loans/$id'),
      headers: headers,
      body: jsonEncode(fields),
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return {'success': true, 'loan': data['loan']};
    }
    return {
      'success': false,
      'message': data['message'] ?? 'Update failed.'
    };
  }
  static Future<Map<String, dynamic>> makeRepayment(
      int loanId, double amount, String paymentMethod) async {
    final headers = await _authHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/loans/$loanId/repay'),
      headers: headers,
      body: jsonEncode({
        'amount': amount,
        'payment_method': paymentMethod,
      }),
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return {'success': true, 'repayment': data['repayment']};
    }
    return {
      'success': false,
      'message': data['message'] ?? 'Repayment failed.'
    };
  }

  static Future<List<dynamic>> getRepayments(int loanId) async {
    final headers = await _authHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/loans/$loanId/repayments'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['repayments'] ?? [];
    }
    throw Exception('Failed to load repayments: ${response.statusCode}');
  }
}