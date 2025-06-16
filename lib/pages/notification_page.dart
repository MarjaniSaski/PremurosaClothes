import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF9F9F9),
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
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TabBar(
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  fontSize: 14,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                ),
                indicatorColor: Colors.pink,
                indicatorWeight: 3,
                indicatorSize: TabBarIndicatorSize.label,
                labelColor: Colors.pink,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(
                    icon: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.local_shipping_outlined, size: 18),
                        SizedBox(width: 6),
                        Text('Status Pesanan'),
                      ],
                    ),
                  ),
                  Tab(
                    icon: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.discount_outlined, size: 18),
                        SizedBox(width: 6),
                        Text('Promo'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            StatusPesananTab(),
            PromoTab(),
          ],
        ),
        bottomNavigationBar: _buildBottomNavBar(context),
      ),
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

class StatusPesananTab extends StatelessWidget {
  StatusPesananTab({super.key});

  final List<Map<String, dynamic>> orders = [
    {
      'title': 'Pesanan Diterima',
      'desc':
          'Paket dengan nomer resi PMC0346891225 sudah diterima oleh orang yang bersangkutan. Silahkan memberikan rating untuk produk tersebut.',
      'time': '2 jam lalu',
      'icon': Icons.check_circle,
      'iconColor': Colors.green,
      'showButton': true,
    },
    {
      'title': 'Pesanan Diantar',
      'desc':
          'Paket dengan nomer resi PMC0346891225 sedang diantarkan menuju lokasimu. Pastikan Anda berada dilokasi tersebut.',
      'time': '5 jam lalu',
      'icon': Icons.local_shipping,
      'iconColor': Colors.blue,
      'showButton': false,
    },
    {
      'title': 'Pesanan Sampai Di Pusat Sortir',
      'desc':
          'Paket dengan nomer resi PMC0346891225 sudah sampai di tempat sortir.',
      'time': '1 hari lalu',
      'icon': Icons.store,
      'iconColor': Colors.orange,
      'showButton': false,
    },
    {
      'title': 'Pesanan Dikirim',
      'desc':
          'Paket dengan nomer resi PMC0346891225 sudah dikirim dan akan diantarkan oleh J&T Express.',
      'time': '2 hari lalu',
      'icon': Icons.inventory_2,
      'iconColor': Colors.purple,
      'showButton': false,
    },
    {
      'title': 'Pesanan Dibuat',
      'desc':
          'Pesanan Anda 5673489DT2MW71390 telah dibuat, pesanan Anda akan segera dikirim. Terima kasih telah berbelanja di platform kami.',
      'time': '3 hari lalu',
      'icon': Icons.shopping_bag,
      'iconColor': Colors.pink,
      'showButton': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return orders.isEmpty
        ? const EmptyNotifications('Belum ada status pesanan')
        : NotificationList(items: orders, type: NotificationType.order);
  }
}

class PromoTab extends StatelessWidget {
  PromoTab({super.key});

  final List<Map<String, dynamic>> promos = [
    {
      'title': 'Namamu Telah Terdaftar!',
      'desc':
          'Premurosa, kamu terdaftar menjadi penerima Diskon s/d 50% 2x dari Premurosa Clothes. Masa berlaku hingga 31 Desember 2024',
      'time': 'Hari ini',
      'icon': Icons.star,
      'iconColor': Colors.amber,
      'imageUrl': 'assets/images/logo2.png',
      'showButton': true,
    },
    {
      'title': 'Diskon-mu Belum Dipakai!',
      'desc': 'Segera ambil Diskon 25% minimal belanja 50RB sebelum hangus!',
      'time': '2 hari lalu',
      'icon': Icons.access_time,
      'iconColor': Colors.red,
      'imageUrl': 'assets/images/logo2.png',
      'showButton': true,
    },
    {
      'title': 'Diskon Kaget',
      'desc':
          'Nikmati potongan harga hingga 70% untuk pembelian minimal 150RB hanya hari ini saja!',
      'time': '3 hari lalu',
      'icon': Icons.bolt,
      'iconColor': Colors.orange,
      'imageUrl': 'assets/images/logo2.png',
      'showButton': true,
    },
    {
      'title': 'Diskon Berkah',
      'desc':
          'Cukup membeli 3 pakaian, Anda bisa mendapatkan 1 pakaian gratis. Masa berlaku hanya malam ini pukul 20:00 sampai 21:00',
      'time': '5 hari lalu',
      'icon': Icons.card_giftcard,
      'iconColor': Colors.green,
      'imageUrl': 'assets/images/logo2.png',
      'showButton': true,
    },
    {
      'title': 'UP TO 80%',
      'desc':
          'Hanya untuk kamu, nikmati potongan harga hingga 80%! Syarat dan ketentuan berlaku.',
      'time': '1 minggu lalu',
      'icon': Icons.local_offer,
      'iconColor': Colors.pink,
      'imageUrl': 'assets/images/logo2.png',
      'showButton': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return promos.isEmpty
        ? const EmptyNotifications('Belum ada promo tersedia')
        : NotificationList(items: promos, type: NotificationType.promo);
  }
}

enum NotificationType { order, promo }

class NotificationList extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final NotificationType type;

  const NotificationList({
    super.key,
    required this.items,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: const Color(0xFFFFA6D6),
      onRefresh: () async {
        // Add refresh logic here
        await Future.delayed(const Duration(seconds: 1));
      },
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 12),
        itemCount: items.length + 1, // +1 for the header
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Text(
                type == NotificationType.order
                    ? 'Aktivitas Pesanan Terbaru'
                    : 'Promo Tersedia',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  color: Color(0xFF333333),
                ),
              ),
            );
          }
          
          final item = items[index - 1];
          return _buildAnimatedNotificationCard(item, index - 1, context);
        },
      ),
    );
  }

  Widget _buildAnimatedNotificationCard(
      Map<String, dynamic> item, int index, BuildContext context) {
    return Hero(
      tag: 'notification_${type.name}_$index',
      child: Material(
        color: Colors.transparent,
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 300 + (index * 100)),
          curve: Curves.easeInOut,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: Opacity(
                opacity: value,
                child: child,
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: NotificationCard(
              imagePath: type == NotificationType.order
                  ? 'assets/images/Pink floral.png'
                  : item['imageUrl'],
              title: item['title'],
              description: item['desc'],
              time: item['time'],
              icon: item['icon'],
              iconColor: item['iconColor'],
              showButton: item['showButton'] ?? false,
              type: type,
            ),
          ),
        ),
      ),
    );
  }
}

class NotificationCard extends StatefulWidget {
  final String imagePath;
  final String title;
  final String description;
  final String time;
  final IconData icon;
  final Color iconColor;
  final bool showButton;
  final NotificationType type;

  const NotificationCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.time,
    required this.icon,
    required this.iconColor,
    required this.showButton,
    required this.type,
  });

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    // Calculate width based on screen size for responsiveness
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final imageSize = isSmallScreen ? 50.0 : 60.0;
    
    return Card(
      elevation: 2,
      // ignore: deprecated_member_use
      shadowColor: Colors.pink.withOpacity(0.3),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          // ignore: deprecated_member_use
          color: const Color(0xFFFFA6D6).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        // ignore: deprecated_member_use
        splashColor: const Color(0xFFFFD8F0).withOpacity(0.5),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                // ignore: deprecated_member_use
                const Color(0xFFFFD8F0).withOpacity(0.7),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left side - Notification Image
                    Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                // ignore: deprecated_member_use
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              widget.imagePath,
                              width: imageSize,
                              height: imageSize,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => 
                                Container(
                                  width: imageSize,
                                  height: imageSize,
                                  color: const Color(0xFFFFA6D6),
                                  child: const Icon(
                                    Icons.image_not_supported, 
                                    color: Colors.white
                                  ),
                                ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  // ignore: deprecated_member_use
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 2,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Icon(
                              widget.icon,
                              size: 16,
                              color: widget.iconColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(width: 12),
                    
                    // Right side - Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title and timestamp row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Flexible title that wraps if needed
                              Flexible(
                                child: Text(
                                  widget.title,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              
                              // Timestamp with smaller font
                              Padding(
                                padding: const EdgeInsets.only(left: 4),
                                child: Text(
                                  widget.time,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Poppins',
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 4),
                          
                          // Description text
                          Text(
                            widget.description,
                            style: const TextStyle(
                              fontSize: 13,
                              fontFamily: 'Poppins',
                              color: Colors.black87,
                            ),
                            maxLines: _isExpanded ? null : 2,
                            overflow: _isExpanded ? null : TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                // Show "Read More" indicator if text is truncated
                if (!_isExpanded && widget.description.length > 100)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          _isExpanded = true;
                        });
                      },
                      style: TextButton.styleFrom(
                        minimumSize: Size.zero,
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        'Baca selengkapnya',
                        style: TextStyle(
                          color: Color(0xFFFFA6D6),
                          fontSize: 12,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                
                // Action Button (for certain notifications)
                if (widget.showButton && _isExpanded)
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Action logic here
                        if (widget.type == NotificationType.order) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Memberikan rating...'),
                              backgroundColor: Color(0xFFFFA6D6),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Menggunakan promo...'),
                              backgroundColor: Color(0xFFFFA6D6),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFA6D6),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      child: Text(
                        widget.type == NotificationType.order
                            ? 'Beri Rating'
                            : 'Gunakan Promo',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EmptyNotifications extends StatelessWidget {
  final String message;

  const EmptyNotifications(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Poppins',
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Refresh action
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Menyegarkan halaman...'),
                  backgroundColor: Color(0xFFFFA6D6),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFA6D6),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              'Segarkan',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}