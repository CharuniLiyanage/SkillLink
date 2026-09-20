import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Android Emulator → PC localhost
  static const String baseUrl = 'http://10.0.2.2:8080';

  static Future<void> testConnection() async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/api/test'),
    );

    print('Status Code: ${response.statusCode}');
    print('Response: ${response.body}');
  } catch (e) {
    print('API Connection Error: $e');
  }
}
  static Future<bool> registerUser({
  required String name,
  required String email,
  required String password,
  required String phone,
  required String role,
}) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/api/users/register'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
        'role': role,
      }),
    );

    print('Status Code: ${response.statusCode}');
    print('Response: ${response.body}');

    return response.statusCode == 200 || response.statusCode == 201;
  } catch (e) {
    print('Registration Error: $e');
    return false;
  }
}

  static Future<Map<String, dynamic>?> loginUser({
      required String email,
      required String password,
    }) async {
      try {
        final response = await http.post(
          Uri.parse('$baseUrl/api/users/login'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'email': email,
            'password': password,
          }),
        );

        print('Login Status Code: ${response.statusCode}');
        print('Login Response: ${response.body}');

        if (response.statusCode == 200) {
          return jsonDecode(response.body);
        }

        return null;
      } catch (e) {
        print('Login Error: $e');
        return null;
      }
    }
}