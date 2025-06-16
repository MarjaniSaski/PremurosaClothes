import 'package:flutter/material.dart';

class ProductFormScreen extends StatefulWidget {
  final Map<String, dynamic>? produk;
  final Function(Map<String, dynamic>) onSubmit;

  const ProductFormScreen({super.key, this.produk, required this.onSubmit});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _kdController;
  late TextEditingController _namaController;
  late TextEditingController _poinController;
  late TextEditingController _detailController;
  String _status = 'Belum Terjual';
  String _fotoUrl = 'https://via.placeholder.com/150';

  @override
  void initState() {
    super.initState();
    _kdController = TextEditingController(text: widget.produk?['kd_produk'] ?? '');
    _namaController = TextEditingController(text: widget.produk?['nama'] ?? '');
    _poinController = TextEditingController(text: widget.produk?['poin']?.toString() ?? '');
    _detailController = TextEditingController(text: widget.produk?['detail'] ?? '');
    _status = widget.produk?['status'] ?? 'Belum Terjual';
    _fotoUrl = widget.produk?['foto'] ?? _fotoUrl;
  }

  @override
  void dispose() {
    _kdController.dispose();
    _namaController.dispose();
    _poinController.dispose();
    _detailController.dispose();
    super.dispose();
  }

  void simpanProduk() {
    if (_formKey.currentState!.validate()) {
      final newProduk = {
        'kd_produk': _kdController.text,
        'nama': _namaController.text,
        'poin': int.parse(_poinController.text),
        'detail': _detailController.text,
        'status': _status,
        'foto': _fotoUrl,
      };
      widget.onSubmit(newProduk);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.produk != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Produk' : 'Tambah Produk'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if (!isEditing)
                TextFormField(
                  controller: _kdController,
                  decoration: const InputDecoration(labelText: 'Kode Produk'),
                  validator: (value) => value == null || value.isEmpty ? 'Wajib diisi' : null,
                ),
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(labelText: 'Nama Produk'),
                validator: (value) => value == null || value.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: _poinController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Poin'),
                validator: (value) => value == null || value.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: _detailController,
                decoration: const InputDecoration(labelText: 'Detail Produk'),
                validator: (value) => value == null || value.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: simpanProduk,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                child: Text(isEditing ? 'Update' : 'Simpan'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
