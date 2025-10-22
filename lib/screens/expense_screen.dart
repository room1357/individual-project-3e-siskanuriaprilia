import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';
import '../utils/expense_manager.dart';

class ExpenseScreen extends StatelessWidget {
  const ExpenseScreen({super.key});

  // 🎨 Warna per kategori (diperbaiki dengan warna yang lebih vibrant dan konsisten)
  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'makanan':
        return const Color(0xFFFFA726); // Orange yang lebih cerah
      case 'transportasi':
        return const Color(0xFF66BB6A); // Green yang lebih segar
      case 'hiburan':
        return const Color(0xFFAB47BC); // Purple yang lebih menarik
      case 'belanja':
        return const Color(0xFFEC407A); // Pink yang lebih bold
      default:
        return const Color(0xFF42A5F5); // Blue yang lebih cerah
    }
  }

  // 🧩 Ikon per kategori (tetap sama, tapi bisa ditambah animasi nanti)
  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'makanan':
        return Icons.fastfood;
      case 'transportasi':
        return Icons.directions_car;
      case 'hiburan':
        return Icons.movie;
      case 'belanja':
        return Icons.shopping_bag;
      default:
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Expense> expenses = ExpenseManager.expenses;
    Expense? highest = ExpenseManager.getHighestExpense(expenses);
    double avgDaily = ExpenseManager.getAverageDaily(expenses);

    return Scaffold(
      // 🎨 Background dengan gradien untuk kesan lebih modern dan menarik
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE3F2FD), Color(0xFFF3E5F5)], // Gradien biru ke ungu lembut
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea( // Menambahkan SafeArea untuk menghindari overlap dengan notch
          child: Column(
            children: [
              // 🏷️ AppBar yang diperbaiki dengan gradien dan ikon
              // 🏷️ AppBar yang diperbaiki dengan gradien, ikon di kiri
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue, Colors.purpleAccent], // Gradien AppBar
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.account_balance_wallet, // Ikon tambahan
                      color: Colors.white,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Catatan Keuangan',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 22,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    const SizedBox(width: 48), // Spacer untuk balance
                  ],
                ),
              ),

              // 📱 Body utama
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 💰 Statistik dengan desain yang lebih menarik: Card dengan gradien dan ikon
                      Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Colors.white, Color(0xFFF8F9FA)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // Rata-rata Harian dengan ikon
                              Expanded(
                                child: Column(
                                  children: [
                                    const Icon(Icons.trending_up, color: Colors.blueAccent, size: 28),
                                    const SizedBox(height: 8),
                                    const Text(
                                      "Rata-rata Harian",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      "Rp ${avgDaily.toStringAsFixed(0)}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Divider vertikal
                              Container(
                                height: 60,
                                width: 1,
                                color: Colors.grey.shade300,
                              ),
                              // Pengeluaran Tertinggi dengan ikon
                              if (highest != null)
                                Expanded(
                                  child: Column(
                                    children: [
                                      const Icon(Icons.arrow_upward, color: Colors.redAccent, size: 28),
                                      const SizedBox(height: 8),
                                      const Text(
                                        "Pengeluaran Tertinggi",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        "Rp ${highest.amount.toStringAsFixed(0)}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // 📋 Judul daftar dengan ikon dan styling yang lebih menarik
                      Row(
                        children: [
                          const Icon(Icons.list_alt, color: Colors.black87, size: 28),
                          const SizedBox(width: 8),
                          Text(
                            "Daftar Pengeluaran",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.1),
                                  offset: const Offset(1, 1),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // 📋 Daftar pengeluaran dengan animasi fade-in sederhana
                      Expanded(
                        child: ListView.builder(
                          itemCount: expenses.length,
                          itemBuilder: (context, index) {
                            final e = expenses[index];
                            return TweenAnimationBuilder(
                              tween: Tween<double>(begin: 0, end: 1),
                              duration: Duration(milliseconds: 300 + (index * 50)), // Animasi bertahap
                              builder: (context, double value, child) {
                                return Opacity(
                                  opacity: value,
                                  child: Transform.translate(
                                    offset: Offset(0, 20 * (1 - value)), // Slide dari bawah
                                    child: child,
                                  ),
                                );
                              },
                              child: Card(
                                color: Colors.white,
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                  leading: CircleAvatar(
                                    radius: 28,
                                    backgroundColor: _getCategoryColor(e.category).withOpacity(0.9),
                                    child: Icon(
                                      _getCategoryIcon(e.category),
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                  title: Text(
                                    e.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "${e.category} • ${DateFormat('dd MMM yyyy').format(e.date)}",
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                  trailing: Text(
                                    "Rp ${e.amount.toStringAsFixed(0)}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}