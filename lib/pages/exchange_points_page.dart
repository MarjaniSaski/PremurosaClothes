import 'package:flutter/material.dart';

class ExchangePointsPage extends StatefulWidget {
  const ExchangePointsPage({super.key});

  @override
  State<ExchangePointsPage> createState() => _ExchangePointsPageState();
}

class _ExchangePointsPageState extends State<ExchangePointsPage> {
  // Mock data for vouchers
  final List<Map<String, dynamic>> vouchers = [
    {
      'voucher_code': 'DISC10',
      'voucher_name': 'Discount 10%',
      'max_amount': '199.000',
      'max_period': '12.12.24',
      'usage_period': '7 days',
      'points': 50,
    },
    {
      'voucher_code': 'DISC5',
      'voucher_name': 'Discount 5%',
      'max_amount': '399.000',
      'max_period': '12.12.24',
      'usage_period': '7 days',
      'points': 30,
    },
    {
      'voucher_code': 'SHIPFREE',
      'voucher_name': 'Gratis Ongkir',
      'max_amount': '999.000',
      'max_period': '12.12.24',
      'usage_period': '7 days',
      'points': 100,
    },
    {
      'voucher_code': 'DISC10B',
      'voucher_name': 'Discount 10%',
      'max_amount': '199.000',
      'max_period': '12.12.24',
      'usage_period': '7 days',
      'points': 50,
    },
    {
      'voucher_code': 'DISC20',
      'voucher_name': 'Discount 20%',
      'max_amount': '299.000',
      'max_period': '20.12.24',
      'usage_period': '14 days',
      'points': 150,
    },
    {
      'voucher_code': 'SPECIAL',
      'voucher_name': 'Discount 50%',
      'max_amount': '500.000',
      'max_period': '31.12.24',
      'usage_period': '30 days',
      'points': 200,
    },
  ];

  // Mock data for products
  final List<Map<String, dynamic>> products = [
    {
      'id': 1,
      'name': 'White Shirt',
      'points': 200,
      'image': 'assets/images/white_shirt.png',
      'description': 'Comfortable white shirt made from premium cotton',
      'size': 'S',
      'color': 'White',
    },
    {
      'id': 2,
      'name': 'Pink Sweater',
      'points': 450,
      'image': 'assets/images/pink_sweater.png',
      'description': 'Cozy pink sweater perfect for cold weather',
      'size': 'M',
      'color': 'Pink',
    },
    {
      'id': 3,
      'name': 'Blue Shirt',
      'points': 350,
      'image': 'assets/images/blue_shirt.png',
      'description': 'Stylish blue shirt for casual occasions',
      'size': 'L',
      'color': 'Blue',
    },
    {
      'id': 4,
      'name': 'White Formal Shirt',
      'points': 500,
      'image': 'assets/images/white_formal.jpg',
      'description': 'Elegant formal shirt for professional settings',
      'size': 'XL',
      'color': 'White',
    },
    {
      'id': 5,
      'name': 'Dress Midi',
      'points': 600,
      'image': 'assets/images/midi_dress.png',
      'description': 'Elegant blue dress for special occasions',
      'size': 'S',
      'color': 'Black',
    },
    {
      'id': 6,
      'name': 'Denim Jacket',
      'points': 550,
      'image': 'assets/images/denim_jacket.png',
      'description': 'Classic denim jacket that never goes out of style',
      'size': 'XL',
      'color': 'Blue',
    },
  ];

  int totalPoints = 350; // Mock total points

  // Selected voucher/product for popup
  Map<String, dynamic>? selectedItem;

  // Popup visibility controllers
  bool showVoucherPopup = false;
  bool showProductPopup = false;

  // Error status for point checking
  bool insufficientPoints = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
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
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          _buildMainContent(),
          if (showVoucherPopup) _buildVoucherPopup(),
          if (showProductPopup) _buildProductPopup(),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Title
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tukar Poin',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF69B4),
                      ),
                    ),
                    Text(
                      'Get rewarding items with your points',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
                // Points Display
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.pink.shade50,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: Colors.pink.shade100.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.monetization_on,
                        color: Color(0xFFFF69B4),
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$totalPoints',
                        style: TextStyle(
                          color: Color(0xFFFF69B4),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Voucher Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Vouchers',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 14,
                    color:Color(0xFFFF69B4),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Horizontal voucher list
            SizedBox(
              height: 160,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: vouchers.length,
                itemBuilder:
                    (context, index) => Padding(
                      padding: EdgeInsets.only(
                        right: index == vouchers.length - 1 ? 0 : 12,
                      ),
                      child: _buildVoucherCard(vouchers[index]),
                    ),
              ),
            ),

            const SizedBox(height: 24),

            // Product Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Products',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFFFF69B4),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Product Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 12,
                mainAxisSpacing: 16,
              ),
              itemCount: products.length,
              itemBuilder:
                  (context, index) => _buildProductCard(products[index]),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildVoucherCard(Map<String, dynamic> voucher) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedItem = voucher;
          showVoucherPopup = true;
          insufficientPoints = totalPoints < voucher['points'];
        });
      },
      child: Container(
        width: 140,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFF69B4), Color(0xFFFF69B4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Decorative circle elements
            Positioned(
              top: -15,
              right: -15,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // ignore: deprecated_member_use
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
            Positioned(
              bottom: -20,
              left: -20,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // ignore: deprecated_member_use
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
            ),

            // Voucher content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Voucher code
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      // ignore: deprecated_member_use
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      voucher['voucher_code'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Voucher name
                  Text(
                    voucher['voucher_name'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Min spend
                  Text(
                    'Min. pembelian Rp${voucher['max_amount']}',
                    style: const TextStyle(color: Colors.white, fontSize: 11),
                  ),
                  const SizedBox(height: 2),

                  // Valid until
                  Text(
                    'Berlaku s/d ${voucher['max_period']}',
                    style: const TextStyle(color: Colors.white, fontSize: 11),
                  ),

                  const Spacer(),

                  // Points required
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.monetization_on,
                          color: Color(0xFFFF69B4),
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${voucher['points']}',
                          style: TextStyle(
                            color: Color(0xFFFF69B4),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
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

Widget _buildProductCard(Map<String, dynamic> product) {
  return GestureDetector(
    onTap: () {
      setState(() {
        selectedItem = product;
        showProductPopup = true;
        insufficientPoints = totalPoints < product['points'];
      });
    },
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image Container
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Image.asset(
                  product['image'],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback to icon if image fails to load
                    return Center(
                      child: Icon(
                        Icons.checkroom,
                        size: 60,
                        color: Colors.grey.shade400,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          // Product Info
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.monetization_on,
                      color: Color(0xFFFF69B4),
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${product['points']}',
                      style: TextStyle(
                        color: Color(0xFFFF69B4),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
  Widget _buildVoucherPopup() {
    return _buildPopup(
      title: 'Detail Voucher',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Voucher name card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.pink.shade400, Color(0xFFFF69B4)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  selectedItem?['voucher_name'] ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    selectedItem?['voucher_code'] ?? '',
                    style: TextStyle(
                      color: Color(0xFFFF69B4),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Voucher details
          _buildDetailRow(
            'Points Required',
            '${selectedItem?['points'] ?? 0} points',
          ),
          _buildDetailRow(
            'Min. Pembelian',
            'Rp${selectedItem?['max_amount'] ?? 0}',
          ),
          _buildDetailRow('Masa Berlaku', selectedItem?['usage_period'] ?? ''),
          _buildDetailRow('Berlaku Hingga', selectedItem?['max_period'] ?? ''),

          const SizedBox(height: 16),

          // Points status
          if (insufficientPoints)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: Color(0xFFFF69B4)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Poin Anda tidak cukup. Anda membutuhkan ${(selectedItem?['points'] ?? 0) - totalPoints} poin lagi.',
                      style: TextStyle(color: Color(0xFFFF69B4)),
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 24),

          // Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showVoucherPopup = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade200,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Batal'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed:
                      insufficientPoints
                          ? null
                          : () {
                            // Exchange logic
                            setState(() {
                              if (!insufficientPoints) {
                                final int pointValue =
                                    (selectedItem?['points'] ?? 0).toInt();
                                totalPoints -= pointValue;
                              }
                              showVoucherPopup = false;

                              // Show success message
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Row(
                                      children: [
                                        const Icon(
                                          Icons.check_circle,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 8),
                                        const Text('Berhasil menukar voucher!'),
                                      ],
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              });
                            });
                          },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFF69B4),
                    foregroundColor: Colors.white, 
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    disabledBackgroundColor: Colors.pink.shade200,
                  ),
                  child: const Text('Tukar'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductPopup() {
    return _buildPopup(
      title: 'Detail Produk',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                selectedItem?['image'] ?? '',  // Using selectedItem instead of product
                fit: BoxFit.contain,             // Makes the image fill the container properly
                errorBuilder: (context, error, stackTrace) {
                  // Fallback in case image fails to load
                  return Center(
                    child: Icon(
                      Icons.checkroom,
                      size: 80,
                      color: Colors.grey.shade400,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Product name
          Text(
            selectedItem?['name'] ?? '',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          // Points required
          Row(
            children: [
              Icon(Icons.monetization_on, color: Color(0xFFFF69B4)),
              const SizedBox(width: 8),
              Text(
                '${selectedItem?['points'] ?? 0} points',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFFFF69B4),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Product details
          const Text(
            'Description',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            selectedItem?['description'] ?? '',
            style: TextStyle(color: Colors.grey.shade700),
          ),
          const SizedBox(height: 12),

          // Size and Color
          _buildDetailRow('Available Sizes', selectedItem?['size'] ?? ''),
          _buildDetailRow('Color', selectedItem?['color'] ?? ''),

          const SizedBox(height: 16),

          // Points status
          if (insufficientPoints)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: Color(0xFFFF69B4)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Poin Anda tidak cukup. Anda membutuhkan ${(selectedItem?['points'] ?? 0) - totalPoints} poin lagi.',
                      style: TextStyle(color: Color(0xFFFF69B4)),
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 24),

          // Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showProductPopup = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade200,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Batal'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed:
                      insufficientPoints
                          ? null
                          : () {
                            // Exchange logic
                            setState(() {
                              if (!insufficientPoints) {
                                final int pointValue =
                                    (selectedItem?['points'] ?? 0).toInt();
                                totalPoints -= pointValue;
                              }
                              showProductPopup = false;

                              // Show success message
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Row(
                                      children: [
                                        const Icon(
                                          Icons.check_circle,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 8),
                                        const Text('Berhasil menukar produk!'),
                                      ],
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              });
                            });
                          },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFF69B4),
                    foregroundColor: Colors.white, 
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    disabledBackgroundColor: Colors.pink.shade200,
                  ),
                  child: const Text('Tukar'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Generic popup builder
  Widget _buildPopup({required String title, required Widget content}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          showVoucherPopup = false;
          showProductPopup = false;
        });
      },
      child: Container(
        // ignore: deprecated_member_use
        color: Colors.black.withOpacity(0.5),
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: GestureDetector(
            onTap: () {}, // Prevent closing when clicking inside popup
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Popup header
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              showVoucherPopup = false;
                              showProductPopup = false;
                            });
                          },
                          borderRadius: BorderRadius.circular(50),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close, size: 20),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Divider(color: Colors.grey.shade200, height: 1),

                  // Popup content
                  Flexible(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: content,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper method for detail rows
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: TextStyle(color: Colors.grey.shade900)),
          ),
        ],
      ),
    );
  }
}
