import 'package:flutter/material.dart';
import '../../models/voucher_model.dart';

class VoucherFormDialog extends StatefulWidget {
  final Voucher? voucher;
  final Function(Voucher) onSave;
  final VoidCallback onCancel;

  const VoucherFormDialog({
    super.key,
    this.voucher,
    required this.onSave,
    required this.onCancel,
  });

  @override
  State<VoucherFormDialog> createState() => _VoucherFormDialogState();
}

class _VoucherFormDialogState extends State<VoucherFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _voucherNameController = TextEditingController();
  final _voucherCodeController = TextEditingController();
  final _discountController = TextEditingController();
  final _pointsController = TextEditingController();
  final _usageQuotaController = TextEditingController();
  final _maxAmountController = TextEditingController();
  DateTime? _usagePeriod;
  DateTime? _maxPeriod;
  String? _usagePeriodError;
  String? _maxPeriodError;

  bool get isEdit => widget.voucher != null;

  @override
  void initState() {
    super.initState();
    if (isEdit) _populateFormFields();
  }

  void _populateFormFields() {
    final voucher = widget.voucher!;
    _voucherNameController.text = voucher.voucherName;
    _voucherCodeController.text = voucher.voucherCode;
    _discountController.text = voucher.discount.toString();
    _pointsController.text = voucher.points.toString();
    _usageQuotaController.text = voucher.usageQuota.toString();
    _maxAmountController.text = voucher.maxAmount.toString();
    _usagePeriod = voucher.usagePeriod;
    _maxPeriod = voucher.maxPeriod;
  }

  @override
  void dispose() {
    _voucherNameController.dispose();
    _voucherCodeController.dispose();
    _discountController.dispose();
    _pointsController.dispose();
    _usageQuotaController.dispose();
    _maxAmountController.dispose();
    super.dispose();
  }

  bool _validateDates() {
    setState(() {
      _usagePeriodError = null;
      _maxPeriodError = null;
    });

    bool isValid = true;
    final now = DateTime.now();

    if (_usagePeriod != null && _usagePeriod!.isBefore(now)) {
      setState(() => _usagePeriodError = 'Periode penggunaan tidak boleh tanggal yang sudah lewat');
      isValid = false;
    }

    if (_usagePeriod != null && _maxPeriod != null && _maxPeriod!.isBefore(_usagePeriod!)) {
      setState(() => _maxPeriodError = 'Batas pemakaian tidak boleh kurang dari masa pemakaian');
      isValid = false;
    }

    return isValid;
  }

  void _handleSave() {
    if (!_formKey.currentState!.validate() || !_validateDates()) return;

    if (_usagePeriod == null || _maxPeriod == null) {
      _showError('Periode penggunaan dan maksimum penggunaan harus dipilih');
      return;
    }

    final voucher = Voucher(
      id: isEdit ? widget.voucher!.id : null,
      voucherName: _voucherNameController.text,
      voucherCode: _voucherCodeController.text,
      discount: double.parse(_discountController.text),
      points: int.parse(_pointsController.text),
      usagePeriod: _usagePeriod!,
      maxPeriod: _maxPeriod!,
      usageQuota: int.parse(_usageQuotaController.text),
      maxAmount: double.parse(_maxAmountController.text),
    );

    widget.onSave(voucher);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Future<void> _selectDateTime(bool isUsagePeriod) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (date != null) {
      // ignore: use_build_context_synchronously
      final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
      if (time != null) {
        setState(() {
          final selectedDateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
          if (isUsagePeriod) {
            _usagePeriod = selectedDateTime;
          } else {
            _maxPeriod = selectedDateTime;
          }
        });
      }
    }
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'Pilih tanggal & waktu';
    return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildTextField(TextEditingController controller, String label, String? Function(String?) validator,
      {TextInputType? keyboardType, String? prefix, String? suffix, IconData? icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            prefixIcon: icon != null ? Icon(icon, color: Colors.purple) : null,
            prefixText: prefix,
            suffixText: suffix,
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.purple, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField(String label, DateTime? dateTime, VoidCallback onTap, String? error, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border.all(color: error != null ? Colors.red : Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.purple, size: 20),
                const SizedBox(width: 8),
                Expanded(child: Text(_formatDateTime(dateTime))),
                const Icon(Icons.arrow_drop_down, color: Colors.grey),
              ],
            ),
          ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(error, style: const TextStyle(color: Colors.red, fontSize: 12)),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 500,
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.purple,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
              ),
              child: Row(
                children: [
                  Icon(isEdit ? Icons.edit : Icons.add, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      isEdit ? 'Edit Voucher' : 'Tambah Voucher',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  IconButton(
                    onPressed: widget.onCancel,
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),

            // Form
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildTextField(
                        _voucherNameController,
                        'Nama Voucher',
                        (v) => v?.isEmpty == true ? 'Nama voucher tidak boleh kosong' : null,
                        icon: Icons.card_giftcard,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        _voucherCodeController,
                        'Kode Voucher',
                        (v) => v?.isEmpty == true ? 'Kode voucher tidak boleh kosong' : null,
                        icon: Icons.qr_code,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              _discountController,
                              'Diskon (%)',
                              (v) {
                                if (v?.isEmpty == true) return 'Diskon tidak boleh kosong';
                                final discount = double.tryParse(v!);
                                return (discount == null || discount < 0 || discount > 100) ? 'Diskon 0-100' : null;
                              },
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildTextField(
                              _pointsController,
                              'Poin Required',
                              (v) {
                                if (v?.isEmpty == true) return 'Poin tidak boleh kosong';
                                final points = double.tryParse(v!);
                                return (points == null || points < 0) ? 'Poin harus positif' : null;
                              },
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              _usageQuotaController,
                              'Kuota Penggunaan',
                              (v) {
                                if (v?.isEmpty == true) return 'Kuota tidak boleh kosong';
                                final quota = double.tryParse(v!);
                                return (quota == null || quota < 1) ? 'Kuota harus > 0' : null;
                              },
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildTextField(
                              _maxAmountController,
                              'Max Amount',
                              (v) {
                                if (v?.isEmpty == true) return 'Max amount tidak boleh kosong';
                                final amount = double.tryParse(v!);
                                return (amount == null || amount < 0) ? 'Amount harus positif' : null;
                              },
                              keyboardType: TextInputType.number,
                              prefix: 'Rp ',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildDateField('Mulai Berlaku', _usagePeriod, () => _selectDateTime(true), _usagePeriodError, Icons.calendar_today),
                      const SizedBox(height: 16),
                      _buildDateField('Berakhir Pada', _maxPeriod, () => _selectDateTime(false), _maxPeriodError, Icons.event_busy),
                    ],
                  ),
                ),
              ),
            ),

            // Buttons
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: widget.onCancel,
                      child: const Text('Batal'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _handleSave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(isEdit ? 'Update' : 'Simpan'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}