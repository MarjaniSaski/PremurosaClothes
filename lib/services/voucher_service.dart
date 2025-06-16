import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/voucher_model.dart';

class VoucherService {
  static const String baseUrl = 'http://127.0.0.1:8000/api/vouchers';

  static Future<List<Voucher>> getAllVouchers() async {
    final response = await http.get(Uri.parse(baseUrl));
    
    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body)['data'];
      return jsonResponse.map((json) => Voucher.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load vouchers');
    }
  }

  static Future<Voucher> createVoucher(Voucher voucher) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(voucher.toJson()),
    );

    if (response.statusCode == 201) {
      return Voucher.fromJson(json.decode(response.body)['data']);
    } else {
      throw Exception('Failed to create voucher');
    }
  }

  static Future<Voucher> updateVoucher(int id, Voucher voucher) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(voucher.toJson()),
    );

    if (response.statusCode == 200) {
      return Voucher.fromJson(json.decode(response.body)['data']);
    } else {
      throw Exception('Failed to update voucher');
    }
  }

  static Future<void> deleteVoucher(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete voucher');
    }
  }
}