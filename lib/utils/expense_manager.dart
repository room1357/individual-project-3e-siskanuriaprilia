import '../models/expense.dart';
import '../utils/storage_helper.dart';
import '../utils/expense_manager.dart';


class ExpenseManager {
  static List<Expense> expenses = [];

  static Future<void> init() async {
    expenses = await StorageHelper.loadExpenses();
    if (expenses.isEmpty) {
      // Data contoh awal
      expenses = [
        Expense(
          id: 'e1',
          title: 'Sarapan Pagi',
          description: 'Nasi uduk + teh manis',
          amount: 20000,
          category: 'Makanan',
          date: DateTime.now(),
        ),
        Expense(
          id: 'e2',
          title: 'Transportasi',
          description: 'Grab',
          amount: 15000,
          category: 'Transportasi',
          date: DateTime.now().subtract(const Duration(days: 1)),
        ),
        Expense(
          id: 'e3',
          title: 'Nonton Film',
          description: 'Bioskop + popcorn',
          amount: 75000,
          category: 'Hiburan',
          date: DateTime.now().subtract(const Duration(days: 3)),
        ),
      ];
      await StorageHelper.saveExpenses(expenses);
    }
  }

  static Future<void> addExpense(Expense expense) async {
    expenses.add(expense);
    await StorageHelper.saveExpenses(expenses);
  }

  static Expense? getHighestExpense(List<Expense> expenses) {
    if (expenses.isEmpty) return null;
    return expenses.reduce((a, b) => a.amount > b.amount ? a : b);
  }

  static double getAverageDaily(List<Expense> expenses) {
    if (expenses.isEmpty) return 0;

    double total = expenses.fold(0, (sum, e) => sum + e.amount);
    Set<String> days = expenses
        .map((e) => '${e.date.year}-${e.date.month}-${e.date.day}')
        .toSet();
    return total / days.length;
  }
  
}

