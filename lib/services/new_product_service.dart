import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:io';
import 'dart:typed_data';

import '../models/new_product_model.dart';

class NewProductService {
  static const String baseUrl = 'http://127.0.0.1:8000/api/new_products';

  static List<ProductCategory> getProductCategories() {
    return [
      ProductCategory(id: 1, name: 'TOPS'),
      ProductCategory(id: 2, name: 'BOTTOMS'),
      ProductCategory(id: 3, name: 'DRESSED'),
    ];
  }

  // --- GET ALL PRODUCTS ---
  static Future<List<NewProduct>> getAllNewProducts() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final List<dynamic> data = jsonResponse['data'];
        return data.map((json) => NewProduct.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load new products: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error loading new products: $e');
    }
  }

  // --- CREATE PRODUCT ---
  static Future<NewProduct> createNewProduct(
    NewProduct newProduct, {
    File? imageFile,
    Uint8List? imageBytes,
  }) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(baseUrl));

      request.fields['kode_produk'] = newProduct.productCode;
      request.fields['nama'] = newProduct.name;
      request.fields['kategori_id'] = newProduct.categoryId.toString();
      request.fields['harga'] = newProduct.price.toString();
      request.fields['stok'] = newProduct.stock.toString();

      if (newProduct.description != null) {
        request.fields['deskripsi'] = newProduct.description!;
      }

      // Handle image
      if (imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'gambar',
          imageFile.path,
          contentType: MediaType('image', 'jpeg'),
        ));
      } else if (imageBytes != null) {
        request.files.add(http.MultipartFile.fromBytes(
          'gambar',
          imageBytes,
          filename: 'upload.jpg',
          contentType: MediaType('image', 'jpeg'),
        ));
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 201) {
        return NewProduct.fromJson(json.decode(responseBody)['data']);
      } else {
        throw Exception('Failed to create product: ${response.statusCode} - $responseBody');
      }
    } catch (e) {
      throw Exception('Error creating product: $e');
    }
  }

  // --- UPDATE PRODUCT ---
  static Future<NewProduct> updateNewProduct(
    int id,
    NewProduct newProduct, {
    File? imageFile,
    Uint8List? imageBytes,
  }) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/$id'));
      request.fields['_method'] = 'PUT';

      request.fields['kode_produk'] = newProduct.productCode;
      request.fields['nama'] = newProduct.name;
      request.fields['kategori_id'] = newProduct.categoryId.toString();
      request.fields['harga'] = newProduct.price.toString();
      request.fields['stok'] = newProduct.stock.toString();

      if (newProduct.description != null) {
        request.fields['deskripsi'] = newProduct.description!;
      }

      if (imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'gambar',
          imageFile.path,
          contentType: MediaType('image', 'jpeg'),
        ));
      } else if (imageBytes != null) {
        request.files.add(http.MultipartFile.fromBytes(
          'gambar',
          imageBytes,
          filename: 'upload.jpg',
          contentType: MediaType('image', 'jpeg'),
        ));
      } else {
        // Untuk gambar lama (tidak diubah)
        request.fields['gambar_url_existing'] = newProduct.imageUrl;
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return NewProduct.fromJson(json.decode(responseBody)['data']);
      } else {
        throw Exception('Failed to update product: ${response.statusCode} - $responseBody');
      }
    } catch (e) {
      throw Exception('Error updating product: $e');
    }
  }

  // --- DELETE PRODUCT ---
  static Future<void> deleteNewProduct(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));

      if (response.statusCode != 204) {
        throw Exception('Failed to delete product: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error deleting product: $e');
    }
  }
}
