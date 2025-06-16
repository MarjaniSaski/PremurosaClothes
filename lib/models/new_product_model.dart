class NewProduct {
  final int? id;
  final String productCode; // Akan menjadi 'kode_produk' di JSON
  final String name; // Akan menjadi 'nama' di JSON
  final int categoryId; // Akan menjadi 'kategori' di JSON
  final String? description; // Akan menjadi 'deskripsi' di JSON
  final double price; // Akan menjadi 'harga' di JSON
  final int stock; // Akan menjadi 'stok' di JSON
  final String imageUrl; // Akan menjadi 'gambar' di JSON (URL)
  final DateTime? createdAt;
  final DateTime? updatedAt;

  NewProduct({
    this.id,
    required this.productCode,
    required this.name,
    required this.categoryId,
    this.description,
    required this.price,
    required this.stock,
    required this.imageUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory NewProduct.fromJson(Map<String, dynamic> json) {
    return NewProduct(
      id: json['id'],
      productCode: json['kode_produk'] ?? '', // Match Laravel's 'kode_produk'
      name: json['nama'] ?? '',
      categoryId: json['kategori_id'] ?? 0, // Match Laravel's 'kategori' (integer)
      description: json['deskripsi'],
      price: (json['harga'] as num?)?.toDouble() ?? 0.0,
      stock: (json['stok'] as num?)?.toInt() ?? 0, // Ensure it's an int
      imageUrl: json['gambar'] ?? '', // Match Laravel's 'gambar' (URL)
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  // toJson ini digunakan di NewProductService saat mengirim data ke Laravel
  // Melalui http.MultipartRequest, field akan dikirim secara terpisah
  // tapi kunci di sini tetap harus cocok dengan yang diharapkan Laravel
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kode_produk': productCode, // Match Laravel's 'kode_produk'
      'nama': name,
      'kategori_id': categoryId, // Match Laravel's 'kategori'
      'deskripsi': description,
      'harga': price,
      'stok': stock,
      // 'gambar' tidak disertakan di sini karena akan dikirim sebagai MultipartFile
      // dan 'gambar_url_existing' di update method
    };
  }
}

// ProductCategory (Tetap sama)
class ProductCategory {
  final int id;
  final String name;

  ProductCategory({required this.id, required this.name});
}