import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/expense.dart';
import 'profile_screen.dart';
import 'login_screen.dart';
import 'expense_screen.dart';
import 'advance_expense_list_screen.dart';
import 'setting_screen.dart';
import 'statistics_screen.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  List<Expense> expenses = [];

  final List<String> _titles = [
    'Home',
    'Expenses',
    'Advanced Expenses',
    'Statistik',
  ];

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final String? expenseData = prefs.getString('expenses');

    if (expenseData != null) {
      List<dynamic> decoded = jsonDecode(expenseData);
      setState(() {
        expenses = decoded.map((e) => Expense.fromJson(e)).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildBody() {
      switch (_currentIndex) {
        case 1:
          return const ExpenseScreen();
        case 2:
          return const AdvancedExpenseListScreen();
        case 3:
          return StatisticsScreen();
        default:
          return _buildHomeContent();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      // 🔹 Sidebar berisi hanya 3 menu (Profile, Settings, Logout)
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.blue),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: const Icon(Icons.person, size: 40, color: Colors.blue),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Welcome ${widget.user.fullName}!',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.user.email,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),

            // 🔸 Profile
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () async {
                Navigator.pop(context);
                User? updatedUser = await Navigator.push<User>(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen(user: widget.user)),
                );
                if (updatedUser != null) {
                  setState(() {
                    widget.user.fullName = updatedUser.fullName;
                    widget.user.username = updatedUser.username;
                    widget.user.email = updatedUser.email;
                  });
                }
              },
            ),

            // 🔸 Settings
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsScreen()),
                );
              },
            ),

            const Divider(),

            // 🔸 Logout
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE3F2FD), Color(0xFFF3E5F5)], // Gradien latar belakang
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: _buildBody(),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) async {
          setState(() => _currentIndex = index);
          if (index == 3) await _loadExpenses(); // refresh data sebelum buka statistik
        },
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.money), label: 'Expenses'),
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Advanced'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Statistik'),
        ],
      ),
    );
  }

  // 🔹 Halaman Home
  Widget _buildHomeContent() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: List.generate(
        6,
        (index) => _buildProductCard(
          'Produk ${index + 1}',
          _getProductIcon(index),
          Colors.primaries[index % Colors.primaries.length],
        ),
      ),
    );
  }

  IconData _getProductIcon(int index) {
    switch (index) {
      case 0:
        return Icons.shopping_cart; // Ikon keranjang belanja
      case 1:
        return Icons.local_grocery_store; // Ikon toko
      case 2:
        return Icons.fastfood; // Ikon makanan
      case 3:
        return Icons.local_drink; // Ikon minuman
      case 4:
        return Icons.laptop; // Ikon laptop
      case 5:
        return Icons.phone_android; // Ikon ponsel
      default:
        return Icons.category; // Ikon kategori default
    }
  }

  Widget _buildProductCard(String title, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), // Rounded corners
      child: InkWell(
        onTap: () {
          // Action saat card ditekan
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$title tapped!')),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [color.withOpacity(0.7), color], // Gradien untuk card
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: Colors.white),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}