// pages/widgets/new_product_form_dialog.dart

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';

import '../../models/new_product_model.dart';
import '../../services/new_product_service.dart';

class NewProductFormDialog extends StatefulWidget {
  final NewProduct? product; // null jika tambah, ada objek jika edit

  // ignore: use_super_parameters
  const NewProductFormDialog({Key? key, this.product}) : super(key: key);

  @override
  State<NewProductFormDialog> createState() => _NewProductFormDialogState();
}

class _NewProductFormDialogState extends State<NewProductFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _productCodeController;
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;

  int? _selectedCategoryId;
  File? _imageFile; // Digunakan di non-web
  Uint8List? _imageBytes; // Digunakan di web
  String? _existingImageUrl; // Untuk menyimpan URL gambar lama saat edit

  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _productCodeController = TextEditingController();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _priceController = TextEditingController();
    _stockController = TextEditingController();

    if (widget.product != null) {
      // Mode Edit: Isi controller dengan data produk yang ada
      _productCodeController.text = widget.product!.productCode;
      _nameController.text = widget.product!.name;
      _descriptionController.text = widget.product!.description ?? '';
      _priceController.text = widget.product!.price.toString();
      _stockController.text = widget.product!.stock.toString();
      _selectedCategoryId = widget.product!.categoryId;
      _existingImageUrl = widget.product!.imageUrl; // Simpan URL gambar yang sudah ada
    }
  }

  @override
  void dispose() {
    _productCodeController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        if (kIsWeb) {
          // Di web, baca bytes dari XFile
          _imageFile = null; // Pastikan File object null
          pickedFile.readAsBytes().then((bytes) {
            setState(() {
              _imageBytes = bytes; // Simpan bytes
              _existingImageUrl = null; // Jika ada gambar baru, batalkan URL lama
            });
          });
        } else {
          // Di non-web (Android/iOS), buat File dari path
          _imageFile = File(pickedFile.path);
          _imageBytes = null; // Pastikan bytes null
          _existingImageUrl = null; // Jika ada gambar baru, batalkan URL lama
        }
      });
    }
  }

  Future<void> _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final productData = NewProduct(
        id: widget.product?.id,
        productCode: _productCodeController.text,
        name: _nameController.text,
        categoryId: _selectedCategoryId ?? 0,
        description: _descriptionController.text,
        price: double.tryParse(_priceController.text) ?? 0.0,
        stock: int.tryParse(_stockController.text) ?? 0,
        // Saat save, imageUrl akan diisi dari respons API.
        // Jika tidak ada gambar baru, gunakan URL lama dari _existingImageUrl
        imageUrl: _imageFile != null || _imageBytes != null ? '' : (_existingImageUrl ?? ''),
      );

      try {
        if (widget.product == null) {
          // Tambah Produk Baru
          if (kIsWeb) {
            await NewProductService.createNewProduct(productData, imageBytes: _imageBytes);
          } else {
            await NewProductService.createNewProduct(productData, imageFile: _imageFile);
          }
        } else {
          // Edit Produk
          if (kIsWeb) {
            await NewProductService.updateNewProduct(widget.product!.id!, productData, imageBytes: _imageBytes);
          } else {
            // Untuk update non-web, jika _imageFile null tapi _existingImageUrl ada,
            // itu berarti pengguna tidak mengupload gambar baru, jadi kirim URL lama.
            // Logika ini ditangani di NewProductService.updateNewProduct
            await NewProductService.updateNewProduct(widget.product!.id!, productData, imageFile: _imageFile);
          }
        }
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop(true); // Tutup dialog dengan hasil true (sukses)
      } catch (e) {
        // Tampilkan snackbar error
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan produk: ${e.toString()}')),
        );
        print('Error saving product: $e');
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop(false); // Tutup dialog dengan hasil false (gagal)
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // List kategori (Anda bisa ambil dari API Laravel jika ada)
    final categories = NewProductService.getProductCategories();

    return AlertDialog(
      title: Text(widget.product == null ? 'Tambah Produk Baru' : 'Edit Produk'),
      content: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Bagian Pemilih Gambar
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey[200],
                        ),
                        child: _imageFile != null // Prioritas 1: Gambar baru dari mobile
                            ? Image.file(_imageFile!, fit: BoxFit.cover)
                            : _imageBytes != null // Prioritas 2: Gambar baru dari web
                                ? Image.memory(_imageBytes!, fit: BoxFit.cover)
                                : (_existingImageUrl != null && _existingImageUrl!.isNotEmpty
                                    // Prioritas 3: Gambar yang sudah ada dari server (saat edit)
                                    ? Image.network(_existingImageUrl!, fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                        return const Icon(Icons.broken_image, size: 40, color: Colors.red);
                                      },)
                                    : const Icon(Icons.add_a_photo, size: 50, color: Colors.grey)), // Placeholder
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ... (lanjutan TextFormField dan DropdownButtonFormField seperti yang sudah Anda miliki)
                    TextFormField(
                      controller: _productCodeController,
                      decoration: const InputDecoration(labelText: 'Kode Produk'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Kode Produk tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Nama Produk'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama Produk tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      value: _selectedCategoryId,
                      decoration: const InputDecoration(labelText: 'kategori_id'),
                      items: categories.map((cat) {
                        return DropdownMenuItem<int>(
                          value: cat.id,
                          child: Text(cat.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategoryId = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Pilih kategori produk';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(labelText: 'Deskripsi'),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(labelText: 'Harga'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Harga tidak boleh kosong';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Masukkan harga yang valid';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _stockController,
                      decoration: const InputDecoration(labelText: 'Stok'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Stok tidak boleh kosong';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Masukkan stok yang valid';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false), // Batal
          child: const Text('Batal'),
        ),
        ElevatedButton(
          onPressed: _saveProduct, // Panggil fungsi simpan
          child: Text(widget.product == null ? 'Tambah' : 'Simpan'),
        ),
      ],
    );
  }
}