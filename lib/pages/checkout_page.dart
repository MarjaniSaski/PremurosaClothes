import 'package:flutter/material.dart';

class OrderConfirmationPage extends StatelessWidget {
  const OrderConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {},
        ),
        title: Image.asset('assets/images/logoPremurosa.png', height: 32),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage('assets/images/profile.png'),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 100,
              ),
              const SizedBox(height: 20),
              const Text(
                'Pesanan Anda akan diproses!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                'Terima kasih telah berbelanja di Premurosa. Kami akan segera memproses pesanan Anda.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6FAB),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    foregroundColor: Colors.white, 
                  ),
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: const Text(
                    'Kembali ke Beranda',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      
    );
  }
}

class CheckoutPage extends StatefulWidget {
  final List<Map<String, dynamic>> selectedItems;
  
  const CheckoutPage({super.key, required this.selectedItems});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String? selectedPaymentMethod;
  String selectedShipping = 'Regular';
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController regionController = TextEditingController();
  
  int get totalPrice {
    return widget.selectedItems.fold(0, (sum, item) {
      return sum + (item['price'] as int) * (item['quantity'] as int);
    });
  }
  
  int get productCount {
    return widget.selectedItems.fold(0, (sum, item) {
      return sum + (item['quantity'] as int);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    
    return Scaffold(
appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {},
          ),
          title: Image.asset('assets/images/logoPremurosa.png', height: 32),
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_none, color: Colors.pink),
              onPressed: () {
                Navigator.pushNamed(context, '/notification');
              },
            ),
            IconButton(
              icon: const CircleAvatar(
                radius: 16,
                backgroundImage: AssetImage('assets/images/profile.png'),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
          ],
        ),   
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Alamat Pengiriman
              _buildSectionTitle('Tambahkan Alamat Pengiriman'),
              _buildAddressForm(isSmallScreen),
              const SizedBox(height: 24),
              
              // Metode Pembayaran
              _buildSectionTitle('Metode Pembayaran'),
              _buildPaymentMethods(isSmallScreen),
              const SizedBox(height: 24),
              
              // Produk Dipesan
              _buildSectionTitle('Produk Dipesan'),
              isSmallScreen 
                  ? _buildOrderedProductsMobile()
                  : _buildOrderedProductsDesktop(),
              const SizedBox(height: 24),
              
              // Total Pesanan
              _buildOrderTotal(),
              const SizedBox(height: 24),
              
              // Voucher
              _buildSectionTitle('Pesan & Pengiriman'),
              _buildVoucherSection(),
              const SizedBox(height: 24),
              
              // Panduan Pembayaran
              _buildSectionTitle('Panduan Pembayaran:'),
              _buildPaymentGuide(),
              const SizedBox(height: 24),
              
              // Ringkasan Pesanan
              _buildOrderSummary(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildCheckoutButton(context),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildAddressForm(bool isSmallScreen) {
    return Column(
      children: [
        TextFormField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Nama Lengkap',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Harap masukkan nama lengkap';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: phoneController,
          decoration: const InputDecoration(
            labelText: 'Nomor Telepon',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Harap masukkan nomor telepon';
            }
            if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
              return 'Nomor telepon hanya boleh mengandung angka';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: addressController,
          decoration: const InputDecoration(
            labelText: 'Alamat Lengkap',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Harap masukkan alamat lengkap';
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: regionController,
          decoration: const InputDecoration(
            labelText: 'Provinsi, Kab/Kota, Kecamatan, Kode Pos',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Harap masukkan detail alamat';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6FAB),
              padding: const EdgeInsets.symmetric(vertical: 15),
              foregroundColor: Colors.white, 
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Alamat berhasil disimpan')),
                );
              }
            },
            child: const Text(
              'Simpan Alamat',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethods(bool isSmallScreen) {
    final paymentOptions = {
      'Transfer Bank': ['BCA', 'Mandiri', 'BNI', 'BRI'],
      'E-Wallet': ['OVO', 'Dana', 'Gopay', 'ShopeePay'],
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: paymentOptions.entries.map((entry) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              entry.key,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            if (isSmallScreen)
              Wrap(
                children: entry.value.map((method) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(method),
                      selected: selectedPaymentMethod == method,
                      // ignore: deprecated_member_use
                      selectedColor: const Color(0xFFFF6FAB).withOpacity(0.7),
                      onSelected: (selected) {
                        setState(() {
                          selectedPaymentMethod = selected ? method : null;
                        });
                      },
                    ),
                  );
                }).toList(),
              )
            else
              ...entry.value.map((method) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Radio<String>(
                    value: method,
                    groupValue: selectedPaymentMethod,
                    activeColor: const Color(0xFFFF6FAB),
                    onChanged: (value) {
                      setState(() {
                        selectedPaymentMethod = value;
                      });
                    },
                  ),
                  title: Text(method),
                );
              }),
            const SizedBox(height: 8),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildOrderedProductsMobile() {
    return Column(
      children: widget.selectedItems.map((item) {
        final itemTotal = (item['price'] as int) * (item['quantity'] as int);
        
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title'] as String,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('Variasi: ${item['variant']}'),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Rp${item['price']}'),
                    Text('Qty: ${item['quantity']}'),
                    Text(
                      'Rp$itemTotal', 
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildOrderedProductsDesktop() {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(4),
        1: FlexColumnWidth(2),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(2),
      },
      children: [
        for (var item in widget.selectedItems) ...[
          TableRow(
            children: [
              Text(item['title'] as String),
              Text('Rp${item['price']}'),
              Text('${item['quantity']}'),
              Text('Rp${(item['price'] as int) * (item['quantity'] as int)}'),
            ],
          ),
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text('Variasi: ${item['variant']}'),
              ),
              const SizedBox(),
              const SizedBox(),
              const SizedBox(),
            ],
          ),
          const TableRow(
            children: [SizedBox(height: 8), SizedBox(), SizedBox(), SizedBox()],
          ),
        ]
      ],
    );
  }

  Widget _buildOrderTotal() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Total pesanan ($productCount Produk):',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          'Rp$totalPrice',
          style: const TextStyle(
            fontWeight: FontWeight.bold, 
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  Widget _buildVoucherSection() {
    // Opsi pengiriman dengan gambar
    final shippingOptions = [
      {
        'name': 'Regular', 
        'icon': Icons.local_shipping,
        'duration': '2-3 hari',
        'price': 'Rp10.000'
      },
      {
        'name': 'Express', 
        'icon': Icons.delivery_dining,
        'duration': '1 hari',
        'price': 'Rp20.000'
      },
      {
        'name': 'Same Day', 
        'icon': Icons.rocket_launch,
        'duration': 'Hari ini',
        'price': 'Rp30.000'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('(Opsional) Tinggalkan pesan ke penjual'),
        const SizedBox(height: 8),
        TextFormField(
          decoration: const InputDecoration(
            hintText: 'Tulis pesan untuk penjual',
            border: OutlineInputBorder(),
          ),
          maxLines: 2,
        ),
        const SizedBox(height: 16),
        const Text(
          'Opsi pengiriman:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        
        // Opsi pengiriman dengan gambar
        Column(
          children: shippingOptions.map((option) {
            final bool isSelected = selectedShipping == option['name'];
            
            return InkWell(
              onTap: () {
                setState(() {
                  selectedShipping = option['name'] as String;
                });
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected ? const Color(0xFFFFA6D6) : Colors.grey.shade300,
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Radio<String>(
                      value: option['name'] as String,
                      groupValue: selectedShipping,
                      activeColor: const Color(0xFFFFA6D6),
                      onChanged: (value) {
                        setState(() {
                          selectedShipping = value!;
                        });
                      },
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        // ignore: deprecated_member_use
                        color: const Color(0xFFFFA6D6).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        option['icon'] as IconData,
                        color: const Color(0xFFFFA6D6),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            option['name'] as String,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text('Estimasi: ${option['duration']}'),
                        ],
                      ),
                    ),
                    Text(
                      option['price'] as String,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPaymentGuide() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('- Mohon membayar dalam 1×24 jam, jika tidak maka transaksi akan dibatalkan.'),
        Text('- Mohon transfer tanpa pembulatan, sesuai angka yang tertera pada tagihan.'),
        Text('- Mohon cantumkan Kode Pembelian pada keterangan berita transfer.'),
        Text('- Pembayaran untuk Kode Pembelian berbeda harus dilakukan secara terpisah.'),
        Text('- Mohon lakukan konfirmasi setelah melakukan pembayaran.'),
      ],
    );
  }

  Widget _buildOrderSummary() {
    const shippingCost = 10000;
    const voucherDiscount = 75000;
    final totalPayment = totalPrice + shippingCost - voucherDiscount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ringkasan Pesanan',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Subtotal Produk:'),
            Text('Rp$totalPrice'),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Total Ongkos Kirim:'),
            Text('Rp$shippingCost'),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Voucher:'),
            Text('-Rp$voucherDiscount', style: const TextStyle(color: Colors.green)),
          ],
        ),
        const Divider(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Total Pembayaran:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Rp$totalPayment',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCheckoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF6FAB),
          minimumSize: const Size(double.infinity, 50),
          foregroundColor: Colors.white, 
        ),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            if (selectedPaymentMethod == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Harap pilih metode pembayaran')),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const OrderConfirmationPage(),
                ),
              );
            }
          }
        },
        child: const Text(
          'Proses Pembayaran',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    regionController.dispose();
    super.dispose();
  }
}