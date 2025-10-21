import '../models/expense.dart';
import '../utils/storage_helper.dart';

class ExpenseManager {
  static List<Expense> expenses = [];
  static List<String> categories = [
    'Makanan',
    'Transportasi',
    'Hiburan',
    'Pendidikan',
    'Utilitas',
  ];

  static Future<void> init() async {
    expenses = await StorageHelper.loadExpenses();
    final savedCategories = await StorageHelper.loadCategories();
    if (savedCategories.isNotEmpty) {
      categories = savedCategories;
    }

    // Tambahkan contoh data jika kosong
    if (expenses.isEmpty) {
      expenses = [
        Expense(
          id: DateTime.now().toString(),
          title: 'Makan Siang',
          description: 'Nasi goreng + es teh',
          category: 'Makanan',
          amount: 25000,
          date: DateTime.now(),
        ),
        Expense(
          id: DateTime.now().subtract(const Duration(days: 1)).toString(),
          title: 'Ojek Online',
          description: 'Perjalanan ke kampus',
          category: 'Transportasi',
          amount: 15000,
          date: DateTime.now().subtract(const Duration(days: 1)),
        ),
        Expense(
          id: DateTime.now().subtract(const Duration(days: 3)).toString(),
          title: 'Streaming',
          description: 'Langganan bulanan',
          category: 'Hiburan',
          amount: 50000,
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

  static Future<void> deleteExpense(String id) async {
    expenses.removeWhere((e) => e.id == id);
    await StorageHelper.saveExpenses(expenses);
  }

  static Future<void> addCategory(String category) async {
    if (!categories.contains(category)) {
      categories.add(category);
      await StorageHelper.saveCategories(categories);
    }
  }

  static Future<void> deleteCategory(String category) async {
    categories.remove(category);
    await StorageHelper.saveCategories(categories);
  }

  static Future<List<Expense>> loadExpenses() async {
    expenses = await StorageHelper.loadExpenses();
    return expenses;
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
