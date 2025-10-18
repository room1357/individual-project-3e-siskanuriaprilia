import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';
import '../utils/expense_manager.dart';

class ExpenseScreen extends StatelessWidget {
  const ExpenseScreen({super.key});

  // 🎨 Warna per kategori
  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'makanan':
        return Colors.orangeAccent;
      case 'transportasi':
        return Colors.green;
      case 'hiburan':
        return Colors.purple;
      case 'belanja':
        return Colors.pinkAccent;
      default:
        return Colors.blueAccent;
    }
  }

  // 🧩 Ikon per kategori
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
      backgroundColor: const Color(0xFFF7F2FA), // warna lembut
      appBar: AppBar(
  title: const Text(
    "Expense Tracker",
    style: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
  ),
  backgroundColor: Colors.blueAccent,
  elevation: 3,
  centerTitle: false,
  iconTheme: const IconThemeData(color: Colors.white),
  foregroundColor: Colors.white, // 🩵 penting agar icon ikut warna putih
),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 💰 Statistik kecil di atas
            Card(
              color: Colors.white,
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Rata-rata Harian",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Rp ${avgDaily.toStringAsFixed(0)}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ],
                    ),
                    if (highest != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            "Pengeluaran Tertinggi",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Rp ${highest.amount.toStringAsFixed(0)}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.redAccent,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              "Daftar Pengeluaran",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),

            // 📋 Daftar pengeluaran
            Expanded(
              child: ListView.builder(
                itemCount: expenses.length,
                itemBuilder: (context, index) {
                  final e = expenses[index];
                  return Card(
                    color: Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            _getCategoryColor(e.category).withOpacity(0.9),
                        child: Icon(
                          _getCategoryIcon(e.category),
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        e.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      subtitle: Text(
                        "${e.category} • ${DateFormat('dd MMM yyyy').format(e.date)}",
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      trailing: Text(
                        "Rp ${e.amount.toStringAsFixed(0)}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
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
    );
  }
}
