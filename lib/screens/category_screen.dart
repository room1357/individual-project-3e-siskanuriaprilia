import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/category.dart';
import '../utils/expense_manager.dart'; // untuk sinkronisasi nama kategori
import 'package:shared_preferences/shared_preferences.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final _controller = TextEditingController();
  List<Category> _savedCategories = [];

  static const String _prefsKey = 'categories_json_list';

  @override
  void initState() {
    super.initState();
    _loadSavedCategories();
  }

  Future<void> _loadSavedCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? list = prefs.getStringList(_prefsKey);

    if (list == null || list.isEmpty) {
      // jika belum ada, inisialisasi dari ExpenseManager (nama kategori existing)
      // ExpenseManager menyimpan hanya nama kategori; buat objek Category sederhana
      _savedCategories = ExpenseManager.categories
          .map((name) => Category(id: name, name: name, icon: '📌'))
          .toList();
      await _saveCategoriesToPrefs(); // simpan agar persist
    } else {
      _savedCategories = list
          .map((s) => Category.fromJson(jsonDecode(s) as Map<String, dynamic>))
          .toList();
      // sinkron ke ExpenseManager agar nama kategori konsisten
      ExpenseManager.categories =
          _savedCategories.map((c) => c.name).toList();
    }

    setState(() {});
  }

  Future<void> _saveCategoriesToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = _savedCategories.map((c) => jsonEncode(c.toJson())).toList();
    await prefs.setStringList(_prefsKey, encoded);
  }

  Future<void> _addCategory() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    // jangan tambah duplicate nama
    if (_savedCategories.any((c) => c.name.toLowerCase() == text.toLowerCase())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kategori sudah ada')),
      );
      return;
    }

    final newCategory = Category(
      id: DateTime.now().toIso8601String(),
      name: text,
      icon: '📌',
    );

    setState(() {
      _savedCategories.add(newCategory);
    });

    // sinkron nama kategori ke ExpenseManager (yang menyimpan nama saja)
    await ExpenseManager.addCategory(newCategory.name);

    // simpan ke prefs
    await _saveCategoriesToPrefs();

    _controller.clear();
  }

  Future<void> _deleteCategory(int index) async {
    final removed = _savedCategories.removeAt(index);
    // sync ke ExpenseManager
    await ExpenseManager.deleteCategory(removed.name);
    await _saveCategoriesToPrefs();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kelola Kategori')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Nama kategori',
                contentPadding: EdgeInsets.all(8),
              ),
              onSubmitted: (_) => _addCategory(),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _addCategory,
                  child: const Text('Tambah'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    // reload dari ExpenseManager (opsional)
                    setState(() {
                      _savedCategories = ExpenseManager.categories
                          .map((name) => Category(id: name, name: name, icon: '📌'))
                          .toList();
                    });
                  },
                  child: const Text('Reset dari ExpenseManager'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _savedCategories.isEmpty
                  ? const Center(child: Text('Belum ada kategori'))
                  : ListView.builder(
                      itemCount: _savedCategories.length,
                      itemBuilder: (ctx, i) {
                        final cat = _savedCategories[i];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            leading: Text(cat.icon, style: const TextStyle(fontSize: 20)),
                            title: Text(cat.name),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteCategory(i),
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
