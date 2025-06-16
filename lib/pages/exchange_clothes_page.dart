import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:premurosa_app/services/order_service.dart';
import 'package:intl/intl.dart';

class ExchangeClothesPage extends StatefulWidget {
  const ExchangeClothesPage({super.key});

  @override
  State<ExchangeClothesPage> createState() => _ExchangeClothesPageState();
}

class _ExchangeClothesPageState extends State<ExchangeClothesPage> {
  final _formKey = GlobalKey<FormState>();
  late final ScrollController _scrollController;

  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController beratController = TextEditingController();

  String selectedClothingType = '';
  final List<String> clothingTypes = ['Kemeja', 'Kaos', 'Dress', 'Celana', 'Rok', 'Jaket'];

  String selectedCourier = '';
  final List<String> courierOptions = ['JNE Express', 'SiCepat REG', 'AnterAja', 'Grab Same Day', 'GoSend'];

  String selectedPickupTime = '';
  final List<String> pickupTimeOptions = [
    'Pagi (08:00 - 12:00)',
    'Siang (12:00 - 15:00)', 
    'Sore (15:00 - 18:00)',
    'Malam (18:00 - 21:00)'
  ];

  final List<String> _base64Images = [];
  final int maxImages = 3;
  int totalPenukaran = 0;
  bool _isLoading = false;
  bool _isSubmitting = false;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _loadUserOrders();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    descriptionController.dispose();
    categoryController.dispose();
    nameController.dispose();
    addressController.dispose();
    phoneController.dispose();
    noteController.dispose();
    beratController.dispose();
    super.dispose();
  }

  Future<void> _loadUserOrders() async {
    try {
      setState(() => _isLoading = true);
      final orders = await ApiService.getUserOrders();
      setState(() {
        totalPenukaran = orders.length;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorDialog('Gagal memuat riwayat penukaran: ${e.toString()}');
    }
  }

  Future<String> _convertImageToBase64FromBytes(Uint8List bytes) async {
    try {
      if (bytes.length > 5 * 1024 * 1024) {
        throw Exception('Ukuran file terlalu besar (maksimal 5MB)');
      }

      if (bytes.length < 1024) {
        throw Exception('Ukuran file terlalu kecil (minimal 1KB)');
      }

      if (!_isValidImageFile(bytes)) {
        throw Exception('File bukan gambar yang valid (hanya PNG, JPEG, WebP)');
      }

      return base64Encode(bytes);
    } catch (e) {
      throw Exception('Gagal memproses gambar: ${e.toString()}');
    }
  }

  bool _isValidImageFile(Uint8List bytes) {
    if (bytes.length < 4) return false;
    
    // Check PNG signature
    if (bytes[0] == 0x89 && bytes[1] == 0x50 && bytes[2] == 0x4E && bytes[3] == 0x47) {
      return true;
    }
    
    // Check JPEG signature
    if (bytes[0] == 0xFF && bytes[1] == 0xD8 && bytes[2] == 0xFF) {
      return true;
    }
    
    // Check WebP signature
    if (bytes.length >= 12 &&
        bytes[0] == 0x52 && bytes[1] == 0x49 && bytes[2] == 0x46 && bytes[3] == 0x46 &&
        bytes[8] == 0x57 && bytes[9] == 0x45 && bytes[10] == 0x42 && bytes[11] == 0x50) {
      return true;
    }
    
    return false;
  }

  Future<void> _pickImage() async {
    if (_base64Images.length >= maxImages) {
      _showErrorDialog("Maksimal $maxImages foto yang dapat diunggah");
      return;
    }

    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() => _isLoading = true);
        final bytes = await pickedFile.readAsBytes();
        
        try {
          final base64String = await _convertImageToBase64FromBytes(bytes);
          setState(() {
            _base64Images.add(base64String);
            _isLoading = false;
          });
        } catch (e) {
          setState(() => _isLoading = false);
          _showErrorDialog(e.toString());
        }
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorDialog("Gagal memilih gambar: ${e.toString()}");
    }
  }

  void _removeImage(int index) {
    setState(() {
      _base64Images.removeAt(index);
    });
  }

  void _showErrorDialog(String message) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.rightSlide,
      title: 'Terjadi Kesalahan',
      desc: message,
      btnOkOnPress: () {},
      btnOkText: 'Mengerti',
      btnOkColor: Colors.pink[400],
    ).show();
  }

  void _showSuccessDialog(String message) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.rightSlide,
      title: 'Berhasil!',
      desc: message,
      btnOkOnPress: () {
        Navigator.of(context).pop();
      },
      btnOkText: 'Baik',
      btnOkColor: Colors.pink[400],
    ).show();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.pink[400]!,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.pink[400],
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  bool _validateForm() {
    if (!_formKey.currentState!.validate()) {
      return false;
    }

    if (_base64Images.isEmpty) {
      _showErrorDialog("Minimal 1 foto harus diunggah");
      return false;
    }

    if (selectedClothingType.isEmpty) {
      _showErrorDialog("Pilih jenis barang");
      return false;
    }

    if (_selectedDate == null) {
      _showErrorDialog("Pilih tanggal penjemputan");
      return false;
    }

    if (selectedCourier.isEmpty) {
      _showErrorDialog("Pilih jenis kurir");
      return false;
    }

    if (selectedPickupTime.isEmpty) {
      _showErrorDialog("Pilih waktu penjemputan");
      return false;
    }

    return true;
  }

  Future<void> _submitOrder() async {
    if (!_validateForm()) return;

    setState(() => _isSubmitting = true);

    try {
      final order = await ApiService.createOrderWithBase64Images(
        base64Images: _base64Images,
        jenisBarang: selectedClothingType,
        jenisBahan: categoryController.text.trim(),
        details: descriptionController.text.trim(),
        namaLengkap: nameController.text.trim(),
        alamatLengkap: addressController.text.trim(),
        tanggalPenjemputan: DateFormat('yyyy-MM-dd').format(_selectedDate!),
        beratKg: int.parse(beratController.text.trim()),
        catatan: noteController.text.trim().isEmpty ? null : noteController.text.trim(),
        jenisKurir: selectedCourier,
        waktuPenjemputan: selectedPickupTime,
      );

      _showSuccessDialog("Pesanan penukaran berhasil dibuat!\nID Pesanan: ${order.id}");
      _resetForm();
      await _loadUserOrders();
    } catch (e) {
      _showErrorDialog("Gagal membuat pesanan: ${e.toString()}");
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    setState(() {
      _base64Images.clear();
      selectedClothingType = '';
      selectedCourier = '';
      selectedPickupTime = '';
      _selectedDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Tukar Pakaian',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.pink[400],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _isLoading && totalPenukaran == 0
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatisticsCard(),
                    const SizedBox(height: 24),
                    _buildFormSection(),
                    const SizedBox(height: 24),
                    _buildSubmitButton(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildStatisticsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.pink[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.pink[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.recycling,
                color: Colors.pink[700],
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Penukaran',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(
                    '$totalPenukaran',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink[700],
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.refresh, color: Colors.pink[400]),
              onPressed: _loadUserOrders,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Formulir Penukaran',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.pink[700],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Isi formulir berikut untuk menukar pakaian Anda',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 16),
        _buildImageUploadSection(),
        const SizedBox(height: 20),
        _buildClothingInfoSection(),
        const SizedBox(height: 20),
        _buildPickupInfoSection(),
      ],
    );
  }

  Widget _buildImageUploadSection() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Foto Pakaian',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink[700],
                  ),
                ),
                const SizedBox(width: 8),
                Chip(
                  label: Text('${_base64Images.length}/$maxImages'),
                  backgroundColor: Colors.pink[50],
                  labelStyle: TextStyle(color: Colors.pink[700]),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Unggah foto pakaian yang akan ditukar (maks. $maxImages foto)',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            
            if (_base64Images.isNotEmpty)
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1,
                ),
                itemCount: _base64Images.length,
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.memory(
                          base64Decode(_base64Images[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => _removeImage(index),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.red[400],
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            
            if (_base64Images.length < maxImages)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: ElevatedButton.icon(
                  onPressed: _pickImage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink[50],
                    foregroundColor: Colors.pink[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Colors.pink[200]!),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  icon: Icon(Icons.add_photo_alternate, color: Colors.pink[700]),
                  label: const Text('Tambah Foto'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildClothingInfoSection() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Informasi Pakaian',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.pink[700],
              ),
            ),
            const SizedBox(height: 16),
            _buildDropdownField(
              label: 'Jenis Pakaian*',
              value: selectedClothingType,
              items: clothingTypes,
              onChanged: (value) => setState(() => selectedClothingType = value ?? ''),
              validator: (value) => value == null ? 'Pilih jenis pakaian' : null,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: categoryController,
              label: 'Jenis Bahan*',
              hint: 'Contoh: Katun, Polyester, Wol',
              validator: (value) => value!.isEmpty ? 'Masukkan jenis bahan' : null,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: descriptionController,
              label: 'Deskripsi*',
              hint: 'Jelaskan kondisi dan detail pakaian',
              maxLines: 3,
              validator: (value) => value!.isEmpty ? 'Masukkan deskripsi' : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPickupInfoSection() {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Informasi Penjemputan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.pink[700],
              ),
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: nameController,
              label: 'Nama Lengkap*',
              hint: 'Masukkan nama lengkap',
              validator: (value) => value!.isEmpty ? 'Masukkan nama lengkap' : null,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: addressController,
              label: 'Alamat Lengkap*',
              hint: 'Masukkan alamat lengkap untuk penjemputan',
              maxLines: 3,
              validator: (value) => value!.isEmpty ? 'Masukkan alamat lengkap' : null,
            ),
            const SizedBox(height: 16),
            _buildDateField(),
            const SizedBox(height: 16),
            _buildTextField(
              controller: beratController,
              label: 'Perkiraan Berat (kg)*',
              hint: 'Masukkan berat dalam kg (1-1000)',
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value!.isEmpty) return 'Masukkan berat pakaian';
                final weight = int.tryParse(value);
                if (weight == null) return 'Masukkan angka yang valid';
                if (weight < 1 || weight > 1000) return 'Berat harus 1-1000 kg';
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildDropdownField(
              label: 'Kurir*',
              value: selectedCourier,
              items: courierOptions,
              onChanged: (value) => setState(() => selectedCourier = value ?? ''),
              validator: (value) => value == null ? 'Pilih jenis kurir' : null,
            ),
            const SizedBox(height: 16),
            _buildDropdownField(
              label: 'Waktu Penjemputan*',
              value: selectedPickupTime,
              items: pickupTimeOptions,
              onChanged: (value) => setState(() => selectedPickupTime = value ?? ''),
              validator: (value) => value == null ? 'Pilih waktu penjemputan' : null,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: noteController,
              label: 'Catatan Tambahan (Opsional)',
              hint: 'Catatan untuk kurir atau informasi tambahan',
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[400]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.pink[400]!),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value.isEmpty ? null : value,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[400]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.pink[400]!),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
          hint: Text('Pilih $label', style: TextStyle(color: Colors.grey[600])),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
          validator: validator,
          style: TextStyle(color: Colors.grey[800], fontSize: 14),
          dropdownColor: Colors.white,
          icon: Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
          isExpanded: true,
        ),
      ],
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tanggal Penjemputan*',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: _selectDate,
          borderRadius: BorderRadius.circular(8),
          child: InputDecorator(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[400]!),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedDate != null
                      ? DateFormat('dd MMMM yyyy').format(_selectedDate!)
                      : 'Pilih tanggal',
                  style: TextStyle(
                    color: _selectedDate != null ? Colors.grey[800] : Colors.grey[600],
                  ),
                ),
                Icon(
                  Icons.calendar_today,
                  color: Colors.grey[600],
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _submitOrder,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.pink[400],
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          elevation: 2,
        ),
        child: _isSubmitting
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Text(
                'KIRIM PENUKARAN',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}