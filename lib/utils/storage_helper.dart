import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/expense.dart';

class StorageHelper {
  static const _expenseKey = 'expenses_data';
  static const _categoryKey = 'categories_data';

  // 🔹 Simpan semua pengeluaran
  static Future<void> saveExpenses(List<Expense> expenses) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = expenses.map((e) => e.toJson()).toList();
    await prefs.setString(_expenseKey, jsonEncode(jsonData));
  }

  // 🔹 Ambil semua pengeluaran
  static Future<List<Expense>> loadExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_expenseKey);
    if (data == null) return [];
    final List decoded = jsonDecode(data);
    return decoded.map((e) => Expense.fromJson(e)).toList();
  }

  // 🔹 Simpan kategori
  static Future<void> saveCategories(List<String> categories) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_categoryKey, categories);
  }

  // 🔹 Ambil kategori
  static Future<List<String>> loadCategories() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_categoryKey) ?? [];
  }
}
