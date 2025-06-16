import 'package:flutter/material.dart';
import '/pages/exchange_clothes_page.dart';
import '/pages/exchange_points_page.dart';

class SwapPage extends StatefulWidget {
  const SwapPage({super.key});

  @override
  State<SwapPage> createState() => _SwapPageState();
}

class _SwapPageState extends State<SwapPage> {
  final int totalPoinTersisa = 350;
  final int jumlahPenukaran = 5;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;

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
      backgroundColor: Colors.grey[50],
      bottomNavigationBar: _buildBottomNavBar(context),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Column(
              children: [
                const SizedBox(height: 8),
                isSmallScreen
                    ? Column(
                        children: [
                          _buildPointsCard(context),
                          const SizedBox(height: 12),
                          _buildExchangesCard(context),
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(child: _buildPointsCard(context)),
                          const SizedBox(width: 12),
                          Expanded(child: _buildExchangesCard(context)),
                        ],
                      ),
                const SizedBox(height: 16),
                _buildTermsCard(),
                const SizedBox(height: 72),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPointsCard(BuildContext context) {
    return Card(
      elevation: 8,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: Image.asset(
              'assets/images/jml.poin.png',
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 120,
                color: Colors.pink[100],
                child: const Center(child: Icon(Icons.image_not_supported, size: 40)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Text(
                  totalPoinTersisa.toString(),
                  style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                Text(
                  'JUMLAH POIN',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                const SizedBox(height: 16),
                _buildActionButton(
                  label: 'Tukar Poin',
                  icon: Icons.arrow_right_alt,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ExchangePointsPage()),
                    );
                  },
                ),
                _buildActionButton(
                  label: 'Riwayat Poin',
                  icon: Icons.history,
                  onPressed: () {
                    Navigator.pushNamed(context, '/points-history');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExchangesCard(BuildContext context) {
    return Card(
      elevation: 8,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: Image.asset(
              'assets/images/jml.baju.png',
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 120,
                color: Colors.pink[100],
                child: const Center(child: Icon(Icons.image_not_supported, size: 40)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Text(
                  jumlahPenukaran.toString(),
                  style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                Text(
                  'JUMLAH PENUKARAN',
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                const SizedBox(height: 16),
                _buildActionButton(
                  label: 'Tukar Pakaian',
                  icon: Icons.arrow_right_alt,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ExchangeClothesPage()),
                    );
                  },
                ),
                _buildActionButton(
                  label: 'Riwayat Penukaran',
                  icon: Icons.history,
                  onPressed: () {
                    Navigator.pushNamed(context, '/exchanges-history');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF69B4),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16),
              const SizedBox(width: 6),
              Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTermsCard() {
    final terms = [
      'Pastikan produk yang ditukarkan dalam kondisi sudah dicuci.',
      'Pastikan produk yang ditukarkan tidak bernjamur dan masih layak pakai.',
      'Pakaian yang kotor atau rusak tidak dapat ditukar.',
      'Bawalah pakaian yang ingin ditukar dan bukti persetujuan ke toko.',
      'Staf Premurosa akan memeriksa kondisi pakaian dan menyetujui atau menolak penukaran.',
      'Jika penukaran disetujui, Anda dapat memiliki poin yang sudah ditetapkan.',
      'Admin berhak membatalkan penukaran pakaian jika ditemukan indikasi kecurangan atau pelanggaran.',
      'Admin tidak bertanggung jawab atas kerugian yang timbul akibat kesalahan dalam proses penukaran pakaian.',
    ];

    return Card(
      elevation: 8,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.star, color: Color(0xFFD5006D)),
                SizedBox(width: 8),
                Text(
                  'Syarat dan Ketentuan',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFD5006D)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Pastikan Anda Membaca dan Memahami Seluruh Ketentuan Berikut Sebelum Melakukan Penukaran!',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
            ...terms.asMap().entries.map((entry) {
              final index = entry.key + 1;
              final term = entry.value;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$index. ', style: const TextStyle(fontSize: 14)),
                    Expanded(child: Text(term, style: const TextStyle(fontSize: 14))),
                  ],
                ),
              );
            }),
            const SizedBox(height: 16),
            const Text(
              'Dengan melakukan penukaran ini, Anda dianggap telah menyetujui semua syarat dan ketentuan yang berlaku.',
              style: TextStyle(fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 2,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.pink,
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushNamed(context, '/');
            break;
          case 1:
            break;
          case 2:
            break;
          case 3:
            Navigator.pushNamed(context, '/wishlist');
            break;
          case 4:
            Navigator.pushNamed(context, '/cart');
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
