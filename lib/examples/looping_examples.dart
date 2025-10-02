import '../models/expense.dart';

class LoopingExamples {
  // Contoh data bawaan
  static List<Expense> expenses = [
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
      date: DateTime.now().subtract(Duration(days: 1)),
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

  // ===============================
  // 1. Hitung Total dengan berbagai looping
  // ===============================

  // Traditional for loop
  static double calculateTotalTraditional(List<Expense> expenses) {
    double total = 0;
    for (int i = 0; i < expenses.length; i++) {
      total += expenses[i].amount;
    }
    return total;
  }

  // For-in
  static double calculateTotalForIn(List<Expense> expenses) {
    double total = 0;
    for (Expense expense in expenses) {
      total += expense.amount;
    }
    return total;
  }

  // forEach
  static double calculateTotalForEach(List<Expense> expenses) {
    double total = 0;
    expenses.forEach((expense) {
      total += expense.amount;
    });
    return total;
  }

  // fold
  static double calculateTotalFold(List<Expense> expenses) {
    return expenses.fold(0, (sum, expense) => sum + expense.amount);
  }

  // reduce
  static double calculateTotalReduce(List<Expense> expenses) {
    if (expenses.isEmpty) return 0;
    return expenses.map((e) => e.amount).reduce((a, b) => a + b);
  }

  // ===============================
  // 2. Cari expense by ID
  // ===============================

  // Cara manual dengan for
  static Expense? findExpenseTraditional(List<Expense> expenses, String id) {
    for (int i = 0; i < expenses.length; i++) {
      if (expenses[i].id == id) {
        return expenses[i];
      }
    }
    return null;
  }

  // Dengan firstWhere
  static Expense? findExpenseWhere(List<Expense> expenses, String id) {
    try {
      return expenses.firstWhere((expense) => expense.id == id);
    } catch (e) {
      return null;
    }
  }

  // ===============================
  // 3. Filter by category
  // ===============================

  // Manual pakai for-in
  static List<Expense> filterByCategoryManual(
      List<Expense> expenses, String category) {
    List<Expense> result = [];
    for (Expense expense in expenses) {
      if (expense.category.toLowerCase() == category.toLowerCase()) {
        result.add(expense);
      }
    }
    return result;
  }

  // Dengan where
  static List<Expense> filterByCategoryWhere(
      List<Expense> expenses, String category) {
    return expenses
        .where((expense) =>
            expense.category.toLowerCase() == category.toLowerCase())
        .toList();
  }
}
