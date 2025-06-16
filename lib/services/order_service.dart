import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/order_model.dart';

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000/api';
  static String? _token;

  // Set token untuk autentikasi
  static void setToken(String token) {
    _token = token;
  }

  // Clear token saat logout
  static void clearToken() {
    _token = null;
  }

  // Get headers dengan auth token
  static Map<String, String> get _headers {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (_token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }

    return headers;
  }

  // Clean base64 string dari data URI prefix
  static String _cleanBase64(String base64String) {
    // Remove data URI prefix jika ada (contoh: "data:image/jpeg;base64,")
    if (base64String.startsWith('data:')) {
      final commaIndex = base64String.indexOf(',');
      if (commaIndex != -1) {
        return base64String.substring(commaIndex + 1);
      }
    }

    // Remove whitespace
    return base64String.trim();
  }

  // Validasi Base64 image - disesuaikan dengan Laravel
  static String? _validateBase64Image(String base64String, {int? index}) {
    try {
      if (base64String.isEmpty) {
        final position = index != null ? " ke-${index + 1}" : "";
        return "Foto$position tidak boleh kosong";
      }

      // Clean base64 string terlebih dahulu
      final cleanBase64 = _cleanBase64(base64String);

      // Decode untuk validasi
      final Uint8List? bytes;
      try {
        bytes = base64Decode(cleanBase64);
      } catch (e) {
        final position = index != null ? " ke-${index + 1}" : "";
        return "Foto$position format base64 tidak valid";
      }

      // Cek minimal size (1KB) dan maksimal size (5MB)
      if (bytes.length < 1024) {
        final position = index != null ? " ke-${index + 1}" : "";
        return "Foto$position terlalu kecil (minimal 1KB)";
      }

      if (bytes.length > 5 * 1024 * 1024) {
        final position = index != null ? " ke-${index + 1}" : "";
        return "Foto$position terlalu besar (maksimal 5MB)";
      }

      // Cek signature file untuk memastikan ini adalah gambar
      if (bytes.length >= 4) {
        // PNG signature
        if (bytes[0] == 0x89 &&
            bytes[1] == 0x50 &&
            bytes[2] == 0x4E &&
            bytes[3] == 0x47) {
          return null; // Valid PNG
        }
        // JPEG signature
        if (bytes[0] == 0xFF && bytes[1] == 0xD8 && bytes[2] == 0xFF) {
          return null; // Valid JPEG
        }
        // WebP signature
        if (bytes.length >= 12 &&
            bytes[0] == 0x52 &&
            bytes[1] == 0x49 &&
            bytes[2] == 0x46 &&
            bytes[3] == 0x46 &&
            bytes[8] == 0x57 &&
            bytes[9] == 0x45 &&
            bytes[10] == 0x42 &&
            bytes[11] == 0x50) {
          return null; // Valid WebP
        }
      }

      final position = index != null ? " ke-${index + 1}" : "";
      return "Foto$position bukan format gambar yang valid (hanya PNG, JPEG, WebP)";
    } catch (e) {
      final position = index != null ? " ke-${index + 1}" : "";
      return "Foto$position gagal divalidasi: ${e.toString()}";
    }
  }

  // Initialize token from SharedPreferences
  static Future<void> initializeToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      if (token != null) {
        setToken(token);
      }
    } catch (e) {
      print('Error initializing token: $e');
    }
  }

  // Mendapatkan semua order user
  static Future<List<Order>> getUserOrders() async {
    try {
      // Pastikan token tersedia
      if (_token == null) {
        await initializeToken();
      }

      final response = await http.get(
        Uri.parse('$baseUrl/orders'),
        headers: _headers,
      );

      print('📥 Get Orders Response status: ${response.statusCode}');
      print('📥 Get Orders Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse['success'] == true) {
          final List<dynamic> ordersData = jsonResponse['data'];
          return ordersData.map((json) => Order.fromJson(json)).toList();
        } else {
          throw Exception(
            'Failed to load orders: ${jsonResponse['message'] ?? 'Unknown error'}',
          );
        }
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please login again');
      } else {
        try {
          final Map<String, dynamic> errorResponse = json.decode(response.body);
          throw Exception(
            'HTTP Error: ${response.statusCode} - ${errorResponse['message'] ?? response.body}',
          );
        } catch (e) {
          throw Exception(
            'HTTP Error: ${response.statusCode} - ${response.body}',
          );
        }
      }
    } catch (e) {
      throw Exception('Error fetching orders: $e');
    }
  }

  // Membuat order baru dengan Base64 images - disesuaikan dengan Laravel
  static Future<Order> createOrderWithBase64Images({
    required List<String> base64Images,
    required String jenisBarang,
    required String jenisBahan,
    required String details,
    required String namaLengkap,
    required String alamatLengkap,
    required String tanggalPenjemputan,
    required int beratKg,
    String? catatan,
    required String jenisKurir,
    required String waktuPenjemputan,
  }) async {
    try {
      // Pastikan token tersedia
      if (_token == null) {
        await initializeToken();
      }

      // Validasi input dasar
      if (base64Images.isEmpty) {
        throw Exception('Minimal 1 foto harus diunggah');
      }

      if (base64Images.length > 3) {
        throw Exception('Maksimal 3 foto yang dapat diunggah');
      }

      // Validasi setiap image dan kumpulkan error
      List<String> imageErrors = [];
      List<String> cleanedImages = [];

      for (int i = 0; i < base64Images.length; i++) {
        final error = _validateBase64Image(base64Images[i], index: i);
        if (error != null) {
          imageErrors.add(error);
        } else {
          cleanedImages.add(_cleanBase64(base64Images[i]));
        }
      }

      // Jika ada error validasi gambar, lempar exception
      if (imageErrors.isNotEmpty) {
        throw Exception('Validasi gambar gagal: ${imageErrors.join(', ')}');
      }

      // Validasi tanggal - sesuaikan dengan Laravel rule 'after:today'
      final DateTime selectedDate = DateTime.parse(tanggalPenjemputan);
      final DateTime today = DateTime.now();
      final DateTime todayOnly = DateTime(today.year, today.month, today.day);
      final DateTime selectedDateOnly = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
      );

      if (selectedDateOnly.isBefore(todayOnly.add(Duration(days: 1)))) {
        throw Exception('Tanggal penjemputan harus setelah hari ini');
      }

      // Validasi berat sesuai Laravel
      if (beratKg < 1 || beratKg > 1000) {
        throw Exception('Berat harus antara 1-1000 kg');
      }

      // Validasi jenis kurir sesuai Laravel
      const validKurir = [
        'JNE Express',
        'SiCepat REG',
        'AnterAja',
        'Grab Same Day',
        'GoSend',
      ];
      if (!validKurir.contains(jenisKurir)) {
        throw Exception('Jenis kurir tidak valid');
      }

      // Validasi waktu penjemputan sesuai Laravel
      const validWaktu = [
        'Pagi (08:00 - 12:00)',
        'Siang (12:00 - 15:00)',
        'Sore (15:00 - 18:00)',
        'Malam (18:00 - 21:00)',
      ];
      if (!validWaktu.contains(waktuPenjemputan)) {
        throw Exception('Waktu penjemputan tidak valid');
      }

      // Prepare request body sesuai dengan Laravel controller
      final Map<String, dynamic> body = {
        'base64_images': cleanedImages, // Kirim base64 yang sudah dibersihkan
        'jenis_barang': jenisBarang,
        'jenis_bahan': jenisBahan,
        'details': details,
        'nama_lengkap': namaLengkap,
        'alamat_lengkap': alamatLengkap,
        'tanggal_penjemputan': tanggalPenjemputan,
        'berat_kg': beratKg,
        'jenis_kurir': jenisKurir,
        'waktu_penjemputan': waktuPenjemputan,
      };

      // Tambahkan catatan hanya jika ada dan tidak kosong
      if (catatan != null && catatan.trim().isNotEmpty) {
        body['catatan'] = catatan.trim();
      }

      print('📤 Sending request to: $baseUrl/orders');
      print('📤 Request body keys: ${body.keys.toList()}');
      print('📤 Headers: $_headers');

      final response = await http.post(
        Uri.parse('$baseUrl/orders'),
        headers: _headers,
        body: json.encode(body),
      );

      print('📥 Create Order Response status: ${response.statusCode}');
      print('📥 Create Order Response body: ${response.body}');

      if (response.statusCode == 201) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse['success'] == true) {
          return Order.fromJson(jsonResponse['data']);
        } else {
          throw Exception(
            'Failed to create order: ${jsonResponse['message'] ?? 'Unknown error'}',
          );
        }
      } else if (response.statusCode == 422) {
        // Handle validation errors sesuai Laravel response
        final Map<String, dynamic> errorResponse = json.decode(response.body);

        if (errorResponse.containsKey('errors')) {
          final dynamic errors = errorResponse['errors'];
          List<String> allErrors = [];

          if (errors is Map<String, dynamic>) {
            errors.forEach((key, value) {
              if (value is List) {
                allErrors.addAll(value.map((e) => e.toString()));
              } else {
                allErrors.add(value.toString());
              }
            });
          } else if (errors is List) {
            allErrors.addAll(errors.map((e) => e.toString()));
          } else {
            allErrors.add(errors.toString());
          }

          final errorMessage =
              allErrors.isNotEmpty
                  ? allErrors.join(', ')
                  : 'Unknown validation error';
          throw Exception('Validasi gagal: $errorMessage');
        } else {
          throw Exception(
            'Validasi gagal: ${errorResponse['message'] ?? 'Unknown validation error'}',
          );
        }
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please login again');
      } else if (response.statusCode == 500) {
        final Map<String, dynamic> errorResponse = json.decode(response.body);
        throw Exception(
          'Server Error: ${errorResponse['message'] ?? 'Internal server error'}',
        );
      } else {
        try {
          final Map<String, dynamic> errorResponse = json.decode(response.body);
          throw Exception(
            'HTTP Error: ${response.statusCode} - ${errorResponse['message'] ?? response.body}',
          );
        } catch (e) {
          throw Exception(
            'HTTP Error: ${response.statusCode} - ${response.body}',
          );
        }
      }
    } catch (e) {
      print('❌ Error creating order: $e');
      // Re-throw dengan pesan yang lebih user-friendly jika memungkinkan
      if (e.toString().contains('Exception:')) {
        rethrow;
      } else {
        throw Exception('Error creating order: $e');
      }
    }
  }

  // Mendapatkan detail order by ID
  static Future<Order> getOrderById(int id) async {
    try {
      // Pastikan token tersedia
      if (_token == null) {
        await initializeToken();
      }

      final response = await http.get(
        Uri.parse('$baseUrl/orders/$id'),
        headers: _headers,
      );

      print('📥 Get Order Detail Response status: ${response.statusCode}');
      print('📥 Get Order Detail Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse['success'] == true) {
          return Order.fromJson(jsonResponse['data']);
        } else {
          throw Exception(
            'Failed to load order: ${jsonResponse['message'] ?? 'Unknown error'}',
          );
        }
      } else if (response.statusCode == 404) {
        throw Exception('Order tidak ditemukan');
      } else if (response.statusCode == 403) {
        throw Exception('Anda tidak memiliki akses ke order ini');
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please login again');
      } else {
        try {
          final Map<String, dynamic> errorResponse = json.decode(response.body);
          throw Exception(
            'HTTP Error: ${response.statusCode} - ${errorResponse['message'] ?? response.body}',
          );
        } catch (e) {
          throw Exception(
            'HTTP Error: ${response.statusCode} - ${response.body}',
          );
        }
      }
    } catch (e) {
      throw Exception('Error fetching order: $e');
    }
  }

  // Update status order (admin only)
  static Future<Order> updateOrderStatus(int id, String status) async {
    try {
      // Pastikan token tersedia
      if (_token == null) {
        await initializeToken();
      }

      // Validasi status sesuai Laravel
      const validStatuses = ['menunggu', 'diproses', 'selesai', 'ditolak'];
      if (!validStatuses.contains(status)) {
        throw Exception('Status tidak valid');
      }

      final response = await http.put(
        Uri.parse('$baseUrl/orders/$id'),
        headers: _headers,
        body: json.encode({'status': status}),
      );

      print('📥 Update Order Status Response status: ${response.statusCode}');
      print('📥 Update Order Status Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse['success'] == true) {
          return Order.fromJson(jsonResponse['data']);
        } else {
          throw Exception(
            'Failed to update order: ${jsonResponse['message'] ?? 'Unknown error'}',
          );
        }
      } else if (response.statusCode == 404) {
        throw Exception('Order tidak ditemukan');
      } else if (response.statusCode == 403) {
        throw Exception('Anda tidak memiliki izin untuk mengupdate order');
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please login again');
      } else if (response.statusCode == 422) {
        final Map<String, dynamic> errorResponse = json.decode(response.body);
        throw Exception(
          'Validasi gagal: ${errorResponse['message'] ?? 'Status tidak valid'}',
        );
      } else {
        try {
          final Map<String, dynamic> errorResponse = json.decode(response.body);
          throw Exception(
            'HTTP Error: ${response.statusCode} - ${errorResponse['message'] ?? response.body}',
          );
        } catch (e) {
          throw Exception(
            'HTTP Error: ${response.statusCode} - ${response.body}',
          );
        }
      }
    } catch (e) {
      throw Exception('Error updating order status: $e');
    }
  }

  // Delete order (admin atau owner)
  static Future<void> deleteOrder(int id) async {
    try {
      // Pastikan token tersedia
      if (_token == null) {
        await initializeToken();
      }

      final response = await http.delete(
        Uri.parse('$baseUrl/orders/$id'),
        headers: _headers,
      );

      print('📥 Delete Order Response status: ${response.statusCode}');
      print('📥 Delete Order Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse['success'] != true) {
          throw Exception(
            'Failed to delete order: ${jsonResponse['message'] ?? 'Unknown error'}',
          );
        }
        // Success, tidak perlu return apa-apa
      } else if (response.statusCode == 404) {
        throw Exception('Order tidak ditemukan');
      } else if (response.statusCode == 403) {
        throw Exception('Anda tidak memiliki izin untuk menghapus order ini');
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Please login again');
      } else {
        try {
          final Map<String, dynamic> errorResponse = json.decode(response.body);
          throw Exception(
            'HTTP Error: ${response.statusCode} - ${errorResponse['message'] ?? response.body}',
          );
        } catch (e) {
          throw Exception(
            'HTTP Error: ${response.statusCode} - ${response.body}',
          );
        }
      }
    } catch (e) {
      throw Exception('Error deleting order: $e');
    }
  }

  static getAllSwapOrders() {}

  static deleteSwapOrder(String orderId) {}

  static updateSwapOrderStatus(String orderId, String newStatus) {}
}
