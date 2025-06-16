import 'package:flutter/material.dart';

class SidebarWidget extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const SidebarWidget({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 200,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple, Colors.pink],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Image.asset(
                  'assets/images/logoPremurosa.png',
                  width: 60,
                  height: 60,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildSidebarItem(
                  Icons.dashboard,
                  'Dashboard',
                  0,
                ),
                _buildSidebarItem(
                  Icons.add_box,
                  'Product',
                  1,
                ),
                _buildSidebarItem(
                  Icons.list_alt,
                  'Order List',
                  2,
                ),
                _buildSidebarItem(
                  Icons.swap_horiz,
                  'Swap',
                  3,
                ),
                _buildSidebarItem(
                  Icons.card_membership,
                  'Vouchers',
                  4,
                ),
                _buildSidebarItem(
                  Icons.message,
                  'Message',
                  5,
                ),
              ],
            ),
          ),
          const Divider(),
          Container(
            margin: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 206, 54, 244),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(IconData icon, String title, int index) {
    bool isSelected = selectedIndex == index;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        gradient: isSelected
            ? LinearGradient(
                colors: [
                  // ignore: deprecated_member_use
                  Colors.purple.withOpacity(0.1),
                  // ignore: deprecated_member_use
                  Colors.purple.withOpacity(0.05),
                ],
              )
            : null,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? Colors.purple : Colors.grey[600],
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.purple : Colors.grey[800],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        onTap: () {
          onItemTapped(index);
        },
      ),
    );
  }
}