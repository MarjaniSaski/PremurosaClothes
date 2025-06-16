import 'dart:convert';

class Order {
  final int id;
  final int userId;
  final List<String> foto;
  final String jenisBarang;
  final String jenisBahan;
  final String details;
  final String namaLengkap;
  final String alamatLengkap;
  final String tanggalPenjemputan;
  final int beratKg;
  final String status;
  final String? catatan;
  final String? jenisKurir;
  final String? waktuPenjemputan;
  final DateTime createdAt;
  final DateTime updatedAt;

  Order({
    required this.id,
    required this.userId,
    required this.foto,
    required this.jenisBarang,
    required this.jenisBahan,
    required this.details,
    required this.namaLengkap,
    required this.alamatLengkap,
    required this.tanggalPenjemputan,
    required this.beratKg,
    required this.status,
    this.catatan,
    this.jenisKurir,
    this.waktuPenjemputan,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    List<String> photoList = [];
    
    // Handle foto field yang bisa berupa array atau string JSON
    if (json['foto'] != null) {
      if (json['foto'] is List) {
        photoList = List<String>.from(json['foto']);
      } else if (json['foto'] is String) {
        try {
          // Coba parse sebagai JSON array
          var decoded = jsonDecode(json['foto']);
          if (decoded is List) {
            photoList = List<String>.from(decoded);
          } else {
            // Jika bukan JSON array, split by comma (fallback)
            photoList = (json['foto'] as String)
                .split(',')
                .where((s) => s.trim().isNotEmpty)
                .map((s) => s.trim())
                .toList();
          }
        } catch (e) {
          // Jika parsing JSON gagal, coba split by comma
          photoList = (json['foto'] as String)
              .split(',')
              .where((s) => s.trim().isNotEmpty)
              .map((s) => s.trim())
              .toList();
        }
      }
    }

    return Order(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      foto: photoList,
      jenisBarang: json['jenis_barang'] ?? '',
      jenisBahan: json['jenis_bahan'] ?? '',
      details: json['details'] ?? '',
      namaLengkap: json['nama_lengkap'] ?? '',
      alamatLengkap: json['alamat_lengkap'] ?? '',
      tanggalPenjemputan: json['tanggal_penjemputan'] ?? '',
      beratKg: json['berat_kg'] ?? 0,
      status: json['status'] ?? 'menunggu',
      catatan: json['catatan'],
      jenisKurir: json['jenis_kurir'],
      waktuPenjemputan: json['waktu_penjemputan'],
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'foto': foto,
      'jenis_barang': jenisBarang,
      'jenis_bahan': jenisBahan,
      'details': details,
      'nama_lengkap': namaLengkap,
      'alamat_lengkap': alamatLengkap,
      'tanggal_penjemputan': tanggalPenjemputan,
      'berat_kg': beratKg,
      'status': status,
      'catatan': catatan,
      'jenis_kurir': jenisKurir,
      'waktu_penjemputan': waktuPenjemputan,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Order copyWith({
    int? id,
    int? userId,
    List<String>? foto,
    String? jenisBarang,
    String? jenisBahan,
    String? details,
    String? namaLengkap,
    String? alamatLengkap,
    String? tanggalPenjemputan,
    int? beratKg,
    String? status,
    String? catatan,
    String? jenisKurir,
    String? waktuPenjemputan,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Order(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      foto: foto ?? this.foto,
      jenisBarang: jenisBarang ?? this.jenisBarang,
      jenisBahan: jenisBahan ?? this.jenisBahan,
      details: details ?? this.details,
      namaLengkap: namaLengkap ?? this.namaLengkap,
      alamatLengkap: alamatLengkap ?? this.alamatLengkap,
      tanggalPenjemputan: tanggalPenjemputan ?? this.tanggalPenjemputan,
      beratKg: beratKg ?? this.beratKg,
      status: status ?? this.status,
      catatan: catatan ?? this.catatan,
      jenisKurir: jenisKurir ?? this.jenisKurir,
      waktuPenjemputan: waktuPenjemputan ?? this.waktuPenjemputan,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}