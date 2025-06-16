import 'package:flutter/material.dart';
import 'checkout_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final List<Map<String, dynamic>> cartItems = [
    {
      'image': 'assets/images/floral_dress.jpg',
      'title': 'Floral Puff Midi Dress',
      'variant': 'White, S',
      'price': 359000,
      'isSelected': false,
      'quantity': 1,
    },
    {
      'image': 'assets/images/unisex_shirt.jpg',
      'title': 'Unisex Shirt',
      'variant': 'White, L',
      'price': 199000,
      'isSelected': false,
      'quantity': 1,
    },
    {
      'image': 'assets/images/Pink floral.png',
      'title': 'Pink Floral Blouse',
      'variant': 'Pink, S',
      'price': 239000,
      'isSelected': false,
      'quantity': 1,
    },
  ];

  bool _allSelected = false;

  int get totalPrice {
    int total = 0;
    for (var item in cartItems) {
      if (item['isSelected'] == true) {
        total += (item['price'] as int) * (item['quantity'] as int);
      }
    }
    return total;
  }

  void _toggleSelectAll(bool? value) {
    if (value == null) return;
    setState(() {
      _allSelected = value;
      for (var item in cartItems) {
        item['isSelected'] = value;
      }
    });
  }

  void _toggleSelectItem(int index, bool? value) {
    if (value == null) return;
    setState(() {
      cartItems[index]['isSelected'] = value;
      _allSelected = cartItems.every((item) => item['isSelected'] == true);
    });
  }

  void _increaseQuantity(int index) {
    setState(() {
      cartItems[index]['quantity'] += 1;
    });
  }

  void _decreaseQuantity(int index) {
    if (cartItems[index]['quantity'] > 1) {
      setState(() {
        cartItems[index]['quantity'] -= 1;
      });
    }
  }

  void _removeItem(int index) {
    setState(() {
      cartItems.removeAt(index);
      _allSelected = cartItems.isNotEmpty && cartItems.every((item) => item['isSelected'] == true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: const Color(0xFFFFC3E1),
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
        body: Column(
          children: [
            Container(
              color: Colors.white,
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: isSmallScreen
                  ? Row(
                      children: [
                        Checkbox(
                          value: _allSelected,
                          onChanged: _toggleSelectAll,
                        ),
                        const Expanded(child: Text("Produk")),
                        const Text("Total"),
                      ],
                    )
                  : Row(
                      children: [
                        Checkbox(
                          value: _allSelected,
                          onChanged: _toggleSelectAll,
                        ),
                        const Expanded(child: Text("Produk")),
                        const Text("Harga Satuan"),
                        const SizedBox(width: 20),
                        const Text("Kuantitas"),
                        const SizedBox(width: 20),
                        const Text("Total Harga"),
                        const SizedBox(width: 10),
                        const Text("Aksi"),
                      ],
                    ),
            ),
            Expanded(
              child: cartItems.isEmpty
                  ? const Center(child: Text("Keranjang kosong"))
                  : ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final item = cartItems[index];
                        final itemTotalPrice = item['price'] * item['quantity'];

                        return Container(
                          color: Colors.white,
                          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          padding: const EdgeInsets.all(10),
                          child: isSmallScreen
                              ? _buildMobileCartItem(item, index, itemTotalPrice)
                              : _buildDesktopCartItem(item, index, itemTotalPrice),
                        );
                      },
                    ),
            ),
            Container(
              color: Colors.white,
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: const [
                      Icon(Icons.card_giftcard_outlined),
                      SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Gunakan/ masukkan voucher',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Total", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("Rp$totalPrice", style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF6FAB),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: totalPrice > 0
                          ? () {
                              final selectedItems = cartItems.where((item) => item['isSelected']).toList();
                              if (selectedItems.isNotEmpty) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CheckoutPage(selectedItems: selectedItems),
                                  ),
                                );
                              }
                            }
                          : null,
                      child: const Text("CHECKOUT"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: _buildBottomNavBar(context),
      );
    }

    Widget _buildMobileCartItem(Map<String, dynamic> item, int index, int itemTotalPrice) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Checkbox(
                value: item['isSelected'],
                onChanged: (value) => _toggleSelectItem(index, value),
              ),
              Image.asset(item['image'], width: 60, height: 80, fit: BoxFit.cover),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text('Variasi: ${item['variant']}'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => _decreaseQuantity(index),
                          icon: const Icon(Icons.remove, size: 16),
                        ),
                        Text("${item['quantity']}"),
                        IconButton(
                          onPressed: () => _increaseQuantity(index),
                          icon: const Icon(Icons.add, size: 16),
                        ),
                        const Spacer(),
                        Text("Rp$itemTotalPrice", style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () => _removeItem(index),
              icon: const Icon(Icons.delete_outline),
            ),
          ),
        ],
      );
    }

    Widget _buildDesktopCartItem(Map<String, dynamic> item, int index, int itemTotalPrice) {
      return Row(
        children: [
          Checkbox(
            value: item['isSelected'],
            onChanged: (value) => _toggleSelectItem(index, value),
          ),
          Image.asset(item['image'], width: 60, height: 80, fit: BoxFit.cover),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['title'], style: const TextStyle(fontWeight: FontWeight.bold)),
                const Text('s&k berlaku', style: TextStyle(fontSize: 10)),
                Text('Variasi: ${item['variant']}'),
              ],
            ),
          ),
          Text("Rp${item['price']}"),
          const SizedBox(width: 20),
          Row(
            children: [
              IconButton(
                onPressed: () => _decreaseQuantity(index),
                icon: const Icon(Icons.remove, size: 16),
              ),
              Text("${item['quantity']}"),
              IconButton(
                onPressed: () => _increaseQuantity(index),
                icon: const Icon(Icons.add, size: 16),
              ),
            ],
          ),
          const SizedBox(width: 20),
          Text("Rp$itemTotalPrice"),
          const SizedBox(width: 10),
          IconButton(
            onPressed: () => _removeItem(index),
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      );
    }

    Widget _buildBottomNavBar(BuildContext context) {
      return BottomNavigationBar(
        currentIndex: 4,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/');
              break;
            case 1:
              // Tambahkan navigasi ke pencarian jika ada
              break;
            case 2:
              Navigator.pushNamed(context, '/swap_page');
              break;
            case 3:
              Navigator.pushNamed(context, '/wishlist');
              break;
            case 4:
              Navigator.pushNamed(context, '/cart_page');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Cari'),
          BottomNavigationBarItem(icon: Icon(Icons.swap_horiz), label: 'Swap'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Wishlist'),
          BottomNavigationBarItem(icon: Icon(Icons.add_shopping_cart), label: 'Keranjang'),
        ],
      );
    }
  }