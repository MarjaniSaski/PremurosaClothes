import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = 'http://127.0.0.1:8000/api';
  
  // Login function - DIPERBAIKI
  static Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      print('🔍 Attempting login to: $baseUrl/login');
      print('📤 Username: $username');
      
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'username': username,
          'password': password,
        }),
      ).timeout(Duration(seconds: 10)); // Tambah timeout

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // PERBAIKAN: Cek struktur response yang benar
        if (data['status'] == 'success') {
          // Simpan token dan user data
          final prefs = await SharedPreferences.getInstance();
          
          // PERBAIKAN: Sesuaikan dengan response Laravel
          String token = data['access_token'] ?? data['token'] ?? '';
          await prefs.setString('auth_token', token);
          await prefs.setString('user_data', json.encode(data['user']));
          
          return {
            'success': true,
            'token': token,
            'user': data['user'],
            'message': data['message'] ?? 'Login berhasil'
          };
        } else {
          return {
            'success': false,
            'message': data['message'] ?? 'Login gagal - status tidak success'
          };
        }
      } else {
        // Handle error response
        try {
          final errorData = json.decode(response.body);
          return {
            'success': false,
            'message': errorData['message'] ?? 'Login gagal - HTTP ${response.statusCode}'
          };
        } catch (e) {
          return {
            'success': false,
            'message': 'Login gagal - HTTP ${response.statusCode}: ${response.body}'
          };
        }
      }
      
    } on http.ClientException catch (e) {
      // ignore: avoid_print
      print('❌ ClientException: $e');
      return {
        'success': false,
        'message': 'Tidak dapat terhubung ke server. Pastikan server Laravel berjalan di $baseUrl'
      };
    } on FormatException catch (e) {
      print('❌ FormatException: $e');
      return {
        'success': false,
        'message': 'Server mengembalikan response yang tidak valid'
      };
    } catch (e) {
      // ignore: avoid_print
      print('❌ Login error: $e');
      String errorMessage = 'Koneksi gagal';
      
      if (e.toString().contains('Connection refused')) {
        errorMessage = 'Server tidak dapat dijangkau. Pastikan Laravel server berjalan dengan: php artisan serve';
      } else if (e.toString().contains('TimeoutException')) {
        errorMessage = 'Koneksi timeout. Periksa jaringan internet Anda.';
      } else if (e.toString().contains('SocketException')) {
        errorMessage = 'Tidak dapat terhubung ke server. Periksa koneksi internet.';
      }
      
      return {
        'success': false,
        'message': errorMessage
      };
    }
  }

  // Register function - DIPERBAIKI
  static Future<Map<String, dynamic>> register({
    required String firstName,
    required String lastName,
    required String gender,
    required String username,
    required String email,
    required String phone,
    required String password,
    String role = 'user'
  }) async {
    try {
      // ignore: avoid_print
      print('🔍 Register attempt to: $baseUrl/register');
      
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'first_name': firstName,
          'last_name': lastName,
          'gender': gender,
          'username': username,
          'email': email,
          'phone': phone,
          'password': password,
          'role': role,
        }),
      ).timeout(Duration(seconds: 10));

      // ignore: avoid_print
      print('📥 Register Response status: ${response.statusCode}');
      // ignore: avoid_print
      print('📥 Register Response body: ${response.body}');

      final data = json.decode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        if (data['status'] == 'success') {
          return {
            'success': true,
            'message': data['message'] ?? 'Registrasi berhasil'
          };
        }
      }
      
      return {
        'success': false,
        'message': data['message'] ?? 'Registrasi gagal',
        'errors': data['errors'] ?? {}
      };
      
    } catch (e) {
      print('❌ Register error: $e');
      return {
        'success': false,
        'message': 'Koneksi gagal. Periksa internet Anda: $e'
      };
    }
  }

  // Logout function
  static Future<bool> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token != null) {
        await http.post(
          Uri.parse('$baseUrl/logout'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      }

      // Hapus data lokal
      await prefs.remove('auth_token');
      await prefs.remove('user_data');
      
      return true;
    } catch (e) {
      // Tetap hapus data lokal meskipun API call gagal
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('user_data');
      return true;
    }
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    return token != null && token.isNotEmpty;
  }

  // Get user data
  static Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user_data');
    if (userData != null) {
      return json.decode(userData);
    }
    return null;
  }

  // Get auth token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // HTTP helper dengan auto token
  static Future<http.Response> authenticatedGet(String endpoint) async {
    final token = await getToken();
    return await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
  }

  static Future<http.Response> authenticatedPost(String endpoint, Map<String, dynamic> data) async {
    final token = await getToken();
    return await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(data),
    );
  }
}