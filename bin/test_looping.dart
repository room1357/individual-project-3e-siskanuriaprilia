import '../lib/models/expense.dart';
import '../lib/examples/looping_examples.dart';

void main() {
  List<Expense> expenses = LoopingExamples.expenses;

  // 1. Hitung total
  print("Total (for trad): ${LoopingExamples.calculateTotalTraditional(expenses)}");
  print("Total (for-in): ${LoopingExamples.calculateTotalForIn(expenses)}");
  print("Total (forEach): ${LoopingExamples.calculateTotalForEach(expenses)}");
  print("Total (fold): ${LoopingExamples.calculateTotalFold(expenses)}");
  print("Total (reduce): ${LoopingExamples.calculateTotalReduce(expenses)}");

  // 2. Cari expense by id
  var found = LoopingExamples.findExpenseWhere(expenses, 'e2');
  print("Expense ditemukan: ${found?.title}");

  // 3. Filter by category
  var food = LoopingExamples.filterByCategoryWhere(expenses, 'food');
  print("Jumlah Food: ${food.length}");
}