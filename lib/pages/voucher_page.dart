import 'package:flutter/material.dart';
import '../services/voucher_service.dart';
import '../models/voucher_model.dart';
import 'widgets/voucher_card.dart';
import 'widgets/voucher_form_dialog.dart';
import 'widgets/sidebar_widget.dart';
import 'package:intl/intl.dart';

class VoucherPage extends StatefulWidget {
  const VoucherPage({super.key});

  @override
  State<VoucherPage> createState() => _VoucherPageState();
}

class _VoucherPageState extends State<VoucherPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 4; // Vouchers is at index 4

  // State management
  List<Voucher> vouchers = [];
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadVouchers();
  }

  // Load vouchers from API
  Future<void> _loadVouchers() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final loadedVouchers = await VoucherService.getAllVouchers();
      setState(() {
        vouchers = loadedVouchers;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
      _showErrorSnackBar('Gagal memuat voucher: ${e.toString()}');
    }
  }

  // Refresh vouchers
  Future<void> _refreshVouchers() async {
    await _loadVouchers();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to different pages based on index
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/dashboard_admin_page');
        break;
      case 1:
        Navigator.pushNamed(context, '/admin_products');
        break;
      case 2:
        Navigator.pushNamed(context, '/admin_orders');
        break;
      case 3:
        Navigator.pushNamed(context, '/admin_swap');
        break;
      case 4:
        // Current page - do nothing
        break;
    }
  }

  void _onSidebarItemTapped(int index) {
    // Handle sidebar navigation
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/dashboard_admin_page');
        break;
      case 1:
        Navigator.pushNamed(context, '/admin_products');
        break;
      case 2:
        Navigator.pushNamed(context, '/admin_orders');
        break;
      case 3:
        Navigator.pushNamed(context, '/admin_swap');
        break;
      case 4:
        // Current page - do nothing
        break;
      case 5:
        Navigator.pushNamed(context, '/admin_messages');
        break;
    }
  }

  void _showAddVoucherPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return VoucherFormDialog(
          onSave: _handleSaveVoucher,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  void _showEditVoucherDialog(Voucher voucher) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return VoucherFormDialog(
          voucher: voucher,
          onSave: (updatedVoucher) => _handleUpdateVoucher(voucher.id!, updatedVoucher),
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  // Save voucher to API
  Future<void> _handleSaveVoucher(Voucher voucher) async {
    setState(() {
      isLoading = true;
    });

    try {
      await VoucherService.createVoucher(voucher);
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
      await _loadVouchers();
      _showSuccessSnackBar('Voucher berhasil ditambahkan');
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showErrorSnackBar('Gagal menambahkan voucher: ${e.toString()}');
    }
  }

  // Update voucher via API - FIXED: Proper type handling
  Future<void> _handleUpdateVoucher(dynamic voucherId, Voucher voucher) async {
    setState(() {
      isLoading = true;
    });

    try {
      // Convert voucherId to int if it's a String
      int id;
      if (voucherId is String) {
        id = int.parse(voucherId);
      } else if (voucherId is int) {
        id = voucherId;
      } else {
        throw Exception('Invalid voucher ID type');
      }
      
      await VoucherService.updateVoucher(id, voucher);
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
      await _loadVouchers();
      _showSuccessSnackBar('Voucher berhasil diperbarui');
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showErrorSnackBar('Gagal memperbarui voucher: ${e.toString()}');
    }
  }

  // Delete voucher via API - FIXED: Proper type handling
  Future<void> _deleteVoucher(Voucher voucher) async {
    setState(() {
      isLoading = true;
    });

    try {
      // Convert voucher.id to int if it's a String
      int id;
      if (voucher.id is String) {
        id = int.parse(voucher.id as String);
      } else if (voucher.id is int) {
        id = voucher.id as int;
      } else {
        throw Exception('Invalid voucher ID type');
      }
      
      await VoucherService.deleteVoucher(id);
      await _loadVouchers();
      _showSuccessSnackBar('Voucher berhasil dihapus');
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showErrorSnackBar('Gagal menghapus voucher: ${e.toString()}');
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

  // Delete confirmation dialog - FIXED: Proper method name and implementation
  void _showDeleteConfirmation(Voucher voucher) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text('Hapus Voucher'),
          content: Text('Apakah Anda yakin ingin menghapus voucher "${voucher.voucherName}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteVoucher(voucher);
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

  // Format DateTime for display
  String _formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }

  // Mobile-optimized voucher content
  Widget _buildVoucherContent() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with mobile-friendly layout
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
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
                  'Daftar Voucher',
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
                    onPressed: isLoading ? null : _showAddVoucherPopup,
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Tambah Voucher Baru'),
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

          // Main content area
          Expanded(
            child: _buildMainContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    if (isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Color(0xFF9333EA)),
            SizedBox(height: 16),
            Text('Memuat voucher...'),
          ],
        ),
      );
    }

    if (errorMessage != null) {
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
              errorMessage!,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _refreshVouchers,
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

    if (vouchers.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _refreshVouchers,
      color: const Color(0xFF9333EA),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: vouchers.length,
        itemBuilder: (context, index) {
          return VoucherCard(
            voucher: vouchers[index],
            onEdit: () => _showEditVoucherDialog(vouchers[index]), // FIXED: Pass correct voucher
            onDelete: () => _showDeleteConfirmation(vouchers[index]), // FIXED: Pass correct voucher
            formatDateTime: _formatDateTime,
          );
        },
      ),
    );
  }

  // Empty state widget
  Widget _buildEmptyState() {
    return RefreshIndicator(
      onRefresh: _refreshVouchers,
      color: const Color(0xFF9333EA),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.6,
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.receipt_long_outlined, size: 80, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'Belum ada voucher',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tambahkan voucher pertama Anda',
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _showAddVoucherPopup,
                icon: const Icon(Icons.add),
                label: const Text('Tambah Voucher'),
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
          height: 40
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
            onPressed: () {},
          ),
          const SizedBox(width: 8),
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              // ignore: deprecated_member_use
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
      body: _buildVoucherContent(),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
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