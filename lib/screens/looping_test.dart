import '../models/expense.dart';
import '../examples/looping_examples.dart';

void main() {
  // Data pengeluaran
  List<Expense> expenses = [
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

  // ============================
  // 1. Hitung Total
  // ============================
  print("=== Hitung Total Pengeluaran ===");
  print("Total (for trad): ${LoopingExamples.calculateTotalTraditional(expenses)}");
  print("Total (for-in): ${LoopingExamples.calculateTotalForIn(expenses)}");
  print("Total (forEach): ${LoopingExamples.calculateTotalForEach(expenses)}");
  print("Total (fold): ${LoopingExamples.calculateTotalFold(expenses)}");
  print("Total (reduce): ${LoopingExamples.calculateTotalReduce(expenses)}");

  // ============================
  // 2. Cari Expense by ID
  // ============================
  print("\n=== Cari Expense by ID ===");
  var found = LoopingExamples.findExpenseWhere(expenses, 'e2');
  if (found != null) {
    print("Expense ditemukan: ${found.title} - Rp${found.amount}");
  } else {
    print("Expense tidak ditemukan");
  }

  // ============================
  // 3. Filter by Category
  // ============================
  print("\n=== Filter by Category ===");
  var food = LoopingExamples.filterByCategoryWhere(expenses, 'Food');
  print("Jumlah kategori Food: ${food.length}");
  for (var e in food) {
    print("- ${e.title} (${e.amount})");
  }
}
