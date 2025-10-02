import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../utils/expense_manager.dart';

class ExpenseScreen extends StatelessWidget {
  const ExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Expense> expenses = ExpenseManager.expenses;
    Expense? highest = ExpenseManager.getHighestExpense(expenses);
    double avgDaily = ExpenseManager.getAverageDaily(expenses);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Expense Tracker"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Rata-rata Harian: Rp ${avgDaily.toStringAsFixed(0)}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            if (highest != null)
              Text(
                "Pengeluaran Tertinggi: ${highest.title} - Rp ${highest.amount.toStringAsFixed(0)}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            const SizedBox(height: 16),
            const Text(
              "Daftar Pengeluaran",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: expenses.length,
                itemBuilder: (context, index) {
                  final e = expenses[index];
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(
                          e.category[0].toUpperCase(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(e.title),
                      subtitle: Text("${e.category} • ${e.description}"),
                      trailing: Text("Rp ${e.amount.toStringAsFixed(0)}"),
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
