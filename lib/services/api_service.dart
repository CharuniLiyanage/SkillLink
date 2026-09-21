import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8080';

  // ==================== TEST CONNECTION ====================

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

  // ==================== REGISTER ====================

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

      return response.statusCode == 200 ||
          response.statusCode == 201;
    } catch (e) {
      print('Registration Error: $e');
      return false;
    }
  }

  // ==================== LOGIN ====================

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

      print(
        'Login Status Code: ${response.statusCode}',
      );

      print(
        'Login Response: ${response.body}',
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }

      return null;
    } catch (e) {
      print('Login Error: $e');
      return null;
    }
  }

  // ==================== ADD ROLE ====================

  static Future<bool> addRole({
    required String email,
    required String role,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(
          '$baseUrl/api/users/add-role'
          '?email=${Uri.encodeComponent(email)}'
          '&role=$role',
        ),
      );

      print(
        'Add Role Status Code: ${response.statusCode}',
      );

      print(
        'Add Role Response: ${response.body}',
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Add Role Error: $e');
      return false;
    }
  }

  // ==================== SAVE PROVIDER PROFILE ====================

  static Future<bool> saveProviderProfile({
    required String email,
    required String location,
    required int experience,
    required String description,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(
          '$baseUrl/api/provider-profile/save'
          '?email=${Uri.encodeComponent(email)}',
        ),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'location': location,
          'experience': experience,
          'description': description,
        }),
      );

      print(
        'Provider Profile Status Code: '
        '${response.statusCode}',
      );

      print(
        'Provider Profile Response: '
        '${response.body}',
      );

      return response.statusCode == 200;
    } catch (e) {
      print(
        'Provider Profile Error: $e',
      );

      return false;
    }
  }

    // ==================== ADD SERVICE ====================

  static Future<bool> addService({
    required String email,
    required String name,
    required String category,
    required String description,
    required double price,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(
          '$baseUrl/api/services/add'
          '?email=${Uri.encodeComponent(email)}',
        ),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'category': category,
          'description': description,
          'price': price,
        }),
      );

      print(
        'Add Service Status Code: '
        '${response.statusCode}',
      );

      print(
        'Add Service Response: '
        '${response.body}',
      );

      return response.statusCode == 200;
    } catch (e) {
      print(
        'Add Service Error: $e',
      );

      return false;
    }
  }

  // ==================== GET PROVIDER SERVICES ====================

  static Future<List<dynamic>?> getProviderServices({
    required String email,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/api/services/provider/'
          '${Uri.encodeComponent(email)}',
        ),
      );

      print(
        'Get Services Status Code: '
        '${response.statusCode}',
      );

      print(
        'Get Services Response: '
        '${response.body}',
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }

      return null;
    } catch (e) {
      print(
        'Get Services Error: '
        '$e',
      );

      return null;
    }
  }

    // ==================== UPDATE SERVICE ====================

static Future<bool> updateService({
  required int id,
  required String email,
  required String name,
  required String category,
  required String description,
  required double price,
}) async {
  print('==============================');
  print('UPDATE SERVICE START');

  try {
    final uri = Uri(
      scheme: 'http',
      host: '10.0.2.2',
      port: 8080,
      path: '/api/services/update/$id',
      queryParameters: {
        'email': email,
      },
    );

    print('URI: $uri');

    final body = jsonEncode({
      'name': name,
      'category': category,
      'description': description,
      'price': price,
    });

    print('BODY: $body');
    print('SENDING PUT REQUEST...');

    final response = await http
        .put(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: body,
        )
        .timeout(
          const Duration(seconds: 10),
        );

    print('RESPONSE RECEIVED!');
    print('STATUS: ${response.statusCode}');
    print('BODY: ${response.body}');

    return response.statusCode == 200;
  } on TimeoutException catch (e) {
    print('!!!!!!!! TIMEOUT !!!!!!!!');
    print(e);
    return false;
  } catch (e, stackTrace) {
    print('!!!!!!!! UPDATE ERROR !!!!!!!!');
    print(e);
    print(stackTrace);
    return false;
  }
}
  // ==================== DELETE SERVICE ====================

  static Future<bool> deleteService({
    required int id,
    required String email,
  }) async {
    try {
      final response = await http.delete(
        Uri.parse(
          '$baseUrl/api/services/delete/$id'
          '?email=${Uri.encodeComponent(email)}',
        ),
      );

      print(
        'Delete Service Status Code: '
        '${response.statusCode}',
      );

      print(
        'Delete Service Response: '
        '${response.body}',
      );

      return response.statusCode == 200;
    } catch (e) {
      print(
        'Delete Service Error: $e',
      );

      return false;
    }
  }

  // ==================== GET PROVIDER PROFILE ====================
  static Future<List<dynamic>> getProviders() async {
  try {
    final response = await http.get(
      Uri.parse('$baseUrl/api/users/providers'),
    );

    print('Get Providers Status Code: ${response.statusCode}');
    print('Get Providers Response: ${response.body}');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    return [];
  } catch (e) {
    print('Get Providers Error: $e');
    return [];
  }
}

//-----------------GetServicesbyCategory-----------------

  static Future<List<dynamic>> getServicesByCategory(
      String category,
    ) async {
      try {
        final response = await http.get(
          Uri.parse(
            '$baseUrl/api/services/category/${Uri.encodeComponent(category)}',
          ),
        );

        print(
          'Get Services By Category Status: ${response.statusCode}',
        );
        print(
          'Get Services By Category Response: ${response.body}',
        );

        if (response.statusCode == 200) {
          return jsonDecode(response.body);
        }

        return [];
      } catch (e) {
        print('Get Services By Category Error: $e');
        return [];
      }
    }

    //---------------GetProviderProfile------------//
    static Future<Map<String, dynamic>?> getProviderProfile(
      String email,
    ) async {
      try {
        final response = await http.get(
          Uri.parse(
            '$baseUrl/api/provider-profile/${Uri.encodeComponent(email)}',
          ),
        );

        print(
          'Get Provider Profile Status: ${response.statusCode}',
        );
        print(
          'Get Provider Profile Response: ${response.body}',
        );

        if (response.statusCode == 200) {
          return jsonDecode(response.body);
        }

        return null;
      } catch (e) {
        print('Get Provider Profile Error: $e');
        return null;
      }
    }
}