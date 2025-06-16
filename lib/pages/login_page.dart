// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/user.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscurePassword = true;
  bool _isLoading = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    setState(() => _isLoading = true);

    try {
      final result = await AuthService.login(username, password);
      // ignore: avoid_print
      print('Login result: $result');

      setState(() => _isLoading = false);

      if (!mounted) return;

      // ✅ PERBAIKAN: Cek berbagai kondisi success
      if (result['success'] == true || result['status'] == 'success') {
        final userData = result['user'];
        
        if (userData == null) {
          _showError('Data user tidak ditemukan');
          return;
        }

        try {
          final user = User.fromJson(userData);
          
          // ✅ PERBAIKAN: Gunakan properti isAdmin dari User model
          String route = user.isAdmin ? '/dashboard_admin_page' : '/home_page';

          Navigator.pushReplacementNamed(context, route);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Selamat datang, ${user.fullName}! 🎉'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );
        } catch (userError) {
          // ignore: avoid_print
          print('User parsing error: $userError');
          _showError('Gagal memproses data user: $userError');
        }
      } else {
        // ✅ PERBAIKAN: Tampilkan pesan error yang lebih informatif
        String errorMessage = result['message'] ?? 'Login gagal';
        
        // Cek jika ada error spesifik
        if (result['errors'] != null) {
          final errors = result['errors'] as Map<String, dynamic>;
          errorMessage = errors.values.first.toString();
        }
        
        _showError(errorMessage);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      
      if (!mounted) return;
      
      // ✅ PERBAIKAN: Pesan error yang lebih user-friendly
      String errorMessage = 'Terjadi kesalahan koneksi';
      if (e.toString().contains('Connection refused')) {
        errorMessage = 'Server tidak dapat dijangkau. Pastikan server Laravel berjalan.';
      } else if (e.toString().contains('TimeoutException')) {
        errorMessage = 'Koneksi timeout. Periksa jaringan internet Anda.';
      } else if (e.toString().contains('SocketException')) {
        errorMessage = 'Tidak dapat terhubung ke server. Periksa koneksi internet.';
      }
      
      _showError(errorMessage);
    }
  }

  // ✅ TAMBAHAN: Helper method untuk menampilkan error
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 400,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Logo
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.pink[100],
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Image.asset(
                        'assets/images/logoPremurosa.png',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.store,
                            size: 60,
                            color: Colors.pink,
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Selamat Datang di'),
                  const Text(
                    'Premurosa Clothes!',
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink),
                  ),
                  const SizedBox(height: 32),
                  
                  // ✅ TAMBAHAN: Info untuk testing
                  if (_isLoading) ...[
                    const LinearProgressIndicator(color: Colors.pink),
                    const SizedBox(height: 16),
                    const Text(
                      'Menghubungkan ke server...',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                  ],
                  
                  // Username
                  TextFormField(
                    controller: _usernameController,
                    enabled: !_isLoading,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                      hintText: 'Masukkan username',
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Username tidak boleh kosong'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  
                  // Password
                  TextFormField(
                    controller: _passwordController,
                    enabled: !_isLoading,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Kata Sandi',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.lock),
                      hintText: 'Masukkan password',
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Password tidak boleh kosong'
                        : null,
                  ),
                  const SizedBox(height: 24),
                  
                  // Login Button
                  ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                      disabledBackgroundColor: Colors.pink[200],
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Masuk',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                  ),
                  const SizedBox(height: 16),
                  
                  TextButton(
                    onPressed: _isLoading
                        ? null
                        : () => Navigator.pushNamed(context, '/register'),
                    child: const Text(
                      'Belum punya akun? Daftar',
                      style: TextStyle(color: Colors.pink),
                    ),
                  ),
                  
                  // // info
                  // if (!_isLoading) ...[
                  //   const SizedBox(height: 20),
                  //   Container(
                  //     padding: const EdgeInsets.all(12),
                  //     decoration: BoxDecoration(
                  //       color: Colors.grey[100],
                  //       borderRadius: BorderRadius.circular(8),
                  //     ),
                  //     child: const Column(
                  //       children: [
                  //         Text(
                  //           'Testing Info:',
                  //           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  //         ),
                  //         SizedBox(height: 4),
                  //         Text(
                  //           'URL: http://127.0.0.1:8000/api/login',
                  //           style: TextStyle(fontSize: 10, color: Colors.grey),
                  //         ),
                  //         Text(
                  //           'Pastikan Laravel server berjalan dengan: php artisan serve',
                  //           style: TextStyle(fontSize: 10, color: Colors.grey),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}