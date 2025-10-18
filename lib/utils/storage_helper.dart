import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/expense.dart';

class StorageHelper {
  static const String _key = 'expenses_data';

  static Future<void> saveExpenses(List<Expense> expenses) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> expenseList =
        expenses.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_key, expenseList);
  }

  static Future<List<Expense>> loadExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_key) ?? [];
    return data.map((e) => Expense.fromJson(jsonDecode(e))).toList();
  }
}
