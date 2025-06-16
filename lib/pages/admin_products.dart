
import 'package:flutter/material.dart';
import '../models/new_product_model.dart';
import '../services/new_product_service.dart';
import '../pages/widgets/new_product_card.dart';
import '../pages/widgets/new_product_form_dialog.dart';
import 'widgets/sidebar_widget.dart';
import 'add_product_page.dart'; // Import halaman baru

class AdminNewProductPage extends StatefulWidget {
  const AdminNewProductPage({super.key});

  @override
  State<AdminNewProductPage> createState() => _AdminNewProductPageState();
}

class _AdminNewProductPageState extends State<AdminNewProductPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 1; // Products is at index 1 in BottomNavigationBar

  List<NewProduct> _products = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final products = await NewProductService.getAllNewProducts();
      setState(() {
        _products = products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal memuat produk: ${e.toString()}';
        _isLoading = false;
      });
      _showErrorSnackBar('Gagal memuat produk: ${e.toString()}');
    }
  }

  Future<void> _refreshProducts() async {
    await _fetchProducts();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to different pages based on index
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/dashboard_admin_page');
        break;
      case 1:
        // Current page - do nothing, already here
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/admin_orders');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/admin_swap');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/admin_vouchers');
        break;
    }
  }

  void _onSidebarItemTapped(int index) {
    // Handle sidebar navigation - make sure routes match your application
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/dashboard_admin_page');
        break;
      case 1:
        // Current page - do nothing, already here
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/admin_orders');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/admin_swap');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/admin_vouchers');
        break;
      case 5:
        Navigator.pushReplacementNamed(context, '/admin_messages');
        break;
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  // Ubah fungsi ini untuk navigasi ke halaman baru
  Future<void> _navigateToAddProductPage() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddProductPage(),
      ),
    );

    if (result == true) {
      _showSuccessSnackBar('Produk berhasil ditambahkan!');
      _fetchProducts(); // Refresh daftar setelah penambahan
    }
  }

  Future<void> _showEditProductDialog(NewProduct product) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => NewProductFormDialog(product: product),
    );

    if (result == true) {
      _showSuccessSnackBar('Produk berhasil diperbarui!');
      _fetchProducts();
    } else if (result == false) {
      _showErrorSnackBar('Pembaruan produk dibatalkan atau gagal.');
    }
  }

  void _showDeleteConfirmation(NewProduct product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text('Hapus Produk'),
          content: Text('Apakah Anda yakin ingin menghapus produk "${product.name}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (product.id != null) {
                  _deleteProduct(product.id!);
                } else {
                  _showErrorSnackBar('ID produk tidak valid untuk dihapus.');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteProduct(int productId) async {
    setState(() {
      _isLoading = true;
    });
    try {
      await NewProductService.deleteNewProduct(productId);
      _showSuccessSnackBar('Produk berhasil dihapus!');
      _fetchProducts();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar('Gagal menghapus produk: ${e.toString()}');
    }
  }

  // Content for the product list
  Widget _buildProductListContent() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFF9333EA)),
            SizedBox(height: 16),
            Text('Memuat produk...'),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 80, color: Colors.red[400]),
            const SizedBox(height: 16),
            Text(
              'Terjadi kesalahan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.red[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage!,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _refreshProducts,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9333EA),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    if (_products.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _refreshProducts,
      color: const Color(0xFF9333EA),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final product = _products[index];
          return NewProductCard(
            product: product,
            onEdit: () => _showEditProductDialog(product),
            onDelete: () => _showDeleteConfirmation(product),
          );
        },
      ),
    );
  }

  // Empty state widget
  Widget _buildEmptyState() {
    return RefreshIndicator(
      onRefresh: _refreshProducts,
      color: const Color(0xFF9333EA),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.6,
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'Belum ada produk',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tambahkan produk pertama Anda',
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _navigateToAddProductPage, // Ubah ke navigasi halaman baru
                icon: const Icon(Icons.add),
                label: const Text('Tambah Produk'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9333EA),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Image.asset(
          'assets/images/logoPremurosa.png',
          height: 40,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.notifications_outlined),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 12,
                      minHeight: 12,
                    ),
                    child: const Text(
                      '3',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            onPressed: () {
              // Handle notifikasi
            },
          ),
          const SizedBox(width: 8),
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: Colors.purple.withOpacity(0.1),
              child: const Icon(Icons.person, color: Colors.purple),
            ),
          ),
        ],
      ),
      drawer: SidebarWidget(
        selectedIndex: _selectedIndex,
        onItemTapped: _onSidebarItemTapped,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header dengan mobile-friendly layout
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Daftar Produk',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _navigateToAddProductPage, // Ubah ke navigasi halaman baru
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Tambah Produk Baru'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9333EA),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Expanded(
            child: _buildProductListContent(),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.purple,
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag),
              label: 'Products',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt),
              label: 'Orders',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.swap_horiz),
              label: 'Swap',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.card_membership),
              label: 'Voucher',
            ),
          ],
        ),
      ),
    );
  }
}