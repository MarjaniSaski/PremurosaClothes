import 'package:flutter/material.dart';
import 'package:premurosa_app/pages/admin_products.dart';

// Pages
import 'pages/home_page.dart';
import 'pages/profile_page.dart';
import 'pages/category_page.dart';
import 'pages/cart_page.dart';
import 'pages/checkout_page.dart';
// ignore: unused_import
import 'pages/swap_page.dart';
import 'pages/notification_page.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/dashboard_admin_page.dart';
import 'pages/voucher_page.dart';
import 'pages/admin_swap.dart';
import 'pages/splash_screen.dart';

// Placeholder pages for admin
class AdminProductsPage extends StatelessWidget {
  const AdminProductsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Products')),
      body: const Center(child: Text('Halaman Admin Produk')),
    );
  }
}

class AdminOrdersPage extends StatelessWidget {
  const AdminOrdersPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Orders')),
      body: const Center(child: Text('Halaman Admin Pesanan')),
    );
  }
}

class AdminMessagesPage extends StatelessWidget {
  const AdminMessagesPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Messages')),
      body: const Center(child: Text('Halaman Admin Pesan')),
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Premurosa App',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Colors.pink,
          unselectedItemColor: Colors.grey,
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        // Authentication
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),

        // Admin routes
        '/dashboard_admin_page': (context) => const DashboardAdminPage(),
        '/voucher_page': (context) => const VoucherPage(),
        '/admin_products': (context) => const AdminNewProductPage(),
        '/admin_orders': (context) => const AdminOrdersPage(),
        '/admin_swap': (context) => const AdminProductPage(),
        '/admin_messages': (context) => const AdminMessagesPage(),

        // User routes
        '/home_page': (context) => HomePage(),
        '/category': (context) {
          final args =
              ModalRoute.of(context)?.settings.arguments
                  as Map<String, dynamic>? ??
              {};
          final category = args['category'] ?? 'ALL';
          return CategoryPage(category: category);
        },
        '/cart': (context) => const CartPage(),
        '/checkout_page': (context) => const CheckoutPage(selectedItems: []),
        //'/swap_page': (context) => const SwapPage(),
        '/notification': (context) => const NotificationPage(),
        '/profile': (context) => const ProfilePage(),
      },
    );
  }
}
