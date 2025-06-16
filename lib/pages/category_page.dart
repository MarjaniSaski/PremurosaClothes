import 'package:flutter/material.dart';
import 'product_detail_page.dart';

class CategoryPage extends StatelessWidget {
  final String category;

  const CategoryPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final allProducts = [
      {
        'name': 'Floral Puff Midi Dress',
        'price': 'Rp 199.000',
        'image': 'assets/images/floral_dress.jpg',
        'rating': 4.8,
        'reviewCount': 87,
        'category': 'DRESSES',
        'description': 'Gaun floral elegan dengan lengan puff untuk tampilan feminin.',
      },
      {
        'name': 'Unisex Shirt Lengan Panjang',
        'price': 'Rp 149.000',
        'image': 'assets/images/unisex_shirt.jpg',
        'rating': 4.5,
        'reviewCount': 62,
        'category': 'TOPS',
        'description': 'Kemeja lengan panjang unisex cocok untuk gaya kasual dan formal.',
      },
      {
        'name': 'Pink Floral Blouse',
        'price': 'Rp 179.000',
        'image': 'assets/images/Pink floral.png',
        'rating': 4.7,
        'reviewCount': 45,
        'category': 'TOPS',
        'description': 'Blouse pink dengan motif bunga yang manis dan trendi.',
      },
      {
        'name': 'Celana Jeans',
        'price': 'Rp 249.000',
        'image': 'assets/images/cargo_jeans.jpg',
        'rating': 4.9,
        'reviewCount': 73,
        'category': 'BUTTOMS',
        'description': 'Celana jeans klasik cocok dipadukan dengan berbagai atasan.',
      },
    ];

    final filtered = allProducts
        .where((product) => product['category'] == category)
        .toList();

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
              onPressed: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: filtered.isEmpty
                    ? const Center(child: Text("Tidak ada produk untuk kategori ini."))
                    : GridView.builder(
                        itemCount: filtered.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.65,
                        ),
                        itemBuilder: (ctx, i) =>
                            _buildProductCard(context, filtered[i]),
                      ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: _buildBottomNavBar(context),
      );
    }

    Widget _buildProductCard(BuildContext context, Map<String, dynamic> product) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductDetailPage(
                name: product['name'],
                price: product['price'],
                image: product['image'],
                rating: product['rating'],
                reviewCount: product['reviewCount'],
                description: product['description'],
              ),
            ),
          );
        },
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.asset(product['image'], fit: BoxFit.cover),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      product['name'],
                      style: const TextStyle(fontWeight: FontWeight.w500),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product['price'],
                      style: TextStyle(
                        color: Colors.pink[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              product['rating'].toString(),
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_shopping_cart, size: 18),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {},
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

    Widget _buildBottomNavBar(BuildContext context) {
      return BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 4) {
            Navigator.pushNamed(context, '/cart');
          }
          // Tambahkan navigasi lainnya jika diperlukan
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Cari'),
          BottomNavigationBarItem(icon: Icon(Icons.swap_horiz), label: 'Swap'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border), label: 'Wishlist'),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_shopping_cart), label: 'Keranjang'),
        ],
      );
    }
  }