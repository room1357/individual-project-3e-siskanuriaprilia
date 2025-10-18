import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/expense.dart';
import 'add_expense_screen.dart';
import 'edit_expense_screen.dart';
import 'category_expense.dart';
import 'statistics_screen.dart';
import 'export_screen.dart';

class AdvancedExpenseListScreen extends StatefulWidget {
  const AdvancedExpenseListScreen({super.key});

  @override
  _AdvancedExpenseListScreenState createState() =>
      _AdvancedExpenseListScreenState();
}

class _AdvancedExpenseListScreenState extends State<AdvancedExpenseListScreen> {
  List<Expense> expenses = [];
  List<Expense> filteredExpenses = [];
  String selectedCategory = 'Semua';
  TextEditingController searchController = TextEditingController();

  double totalAmount = 0;
  double averageAmount = 0;

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  // 🔹 Muat data dari SharedPreferences
  Future<void> _loadExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final String? expenseData = prefs.getString('expenses');

    if (expenseData != null) {
      List<dynamic> decoded = jsonDecode(expenseData);
      setState(() {
        expenses = decoded.map((e) => Expense.fromJson(e)).toList();
        filteredExpenses = expenses;
        _updateStats();
      });
    } else {
      // Data awal jika belum ada yang disimpan
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
      filteredExpenses = expenses;
      _saveExpenses();
      _updateStats();
    }
  }

  // 🔹 Simpan data ke SharedPreferences
  Future<void> _saveExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> expenseList =
        expenses.map((e) => e.toJson()).toList();
    await prefs.setString('expenses', jsonEncode(expenseList));
  }

  // 🔹 Hitung ulang total dan rata-rata
  void _updateStats() {
    if (filteredExpenses.isEmpty) {
      totalAmount = 0;
      averageAmount = 0;
    } else {
      totalAmount =
          filteredExpenses.fold(0, (sum, e) => sum + e.amount);
      averageAmount = totalAmount / filteredExpenses.length;
    }
  }

  void _filterExpenses() {
    setState(() {
      filteredExpenses = expenses.where((expense) {
        bool matchesSearch = searchController.text.isEmpty ||
            expense.title
                .toLowerCase()
                .contains(searchController.text.toLowerCase()) ||
            expense.description
                .toLowerCase()
                .contains(searchController.text.toLowerCase());

        bool matchesCategory =
            selectedCategory == 'Semua' || expense.category == selectedCategory;

        return matchesSearch && matchesCategory;
      }).toList();
      _updateStats(); // ✅ Hitung ulang setiap kali filter berubah
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengeluaran Advanced'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            tooltip: 'Lihat Statistik',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => StatisticsScreen(expenses: expenses),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.upload_file),
            tooltip: 'Export Pengeluaran',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ExportScreen(expenses: expenses),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.category),
            tooltip: 'Kelola Kategori',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CategoryScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 🔍 Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: 'Cari pengeluaran...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => _filterExpenses(),
            ),
          ),

          // 🔹 Filter kategori
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                'Semua',
                'Makanan',
                'Transportasi',
                'Utilitas',
                'Hiburan',
                'Pendidikan',
              ].map((category) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category),
                    selected: selectedCategory == category,
                    onSelected: (selected) {
                      setState(() {
                        selectedCategory = category;
                        _filterExpenses();
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          // 🔹 Statistik ringkas (selalu update)
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard('Total', 'Rp ${totalAmount.toStringAsFixed(0)}'),
                _buildStatCard('Jumlah', '${filteredExpenses.length} item'),
                _buildStatCard(
                    'Rata-rata', 'Rp ${averageAmount.toStringAsFixed(0)}'),
              ],
            ),
          ),

          // 🔹 Daftar pengeluaran
          Expanded(
            child: filteredExpenses.isEmpty
                ? const Center(child: Text('Tidak ada pengeluaran ditemukan'))
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: filteredExpenses.length,
                    itemBuilder: (context, index) {
                      final expense = filteredExpenses[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                _getCategoryColor(expense.category),
                            child: Icon(
                              _getCategoryIcon(expense.category),
                              color: Colors.white,
                            ),
                          ),
                          title: Text(expense.title),
                          subtitle: Text(
                            '${expense.category} • ${DateFormat('dd MMM yyyy').format(expense.date)}',
                          ),
                          // ✅ Fix Overflow di trailing
                          trailing: SizedBox(
                            height: 60,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Rp ${expense.amount.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red[600],
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit,
                                          color: Colors.blue, size: 18),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      onPressed: () => _editExpense(expense),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red, size: 18),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      onPressed: () => _deleteExpense(expense),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          onTap: () => _showExpenseDetails(context, expense),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddExpenseScreen(
                onAddExpense: (Expense expense) {
                  setState(() {
                    expenses.add(expense);
                    _filterExpenses();
                    _updateStats(); // ✅ langsung update statistik
                  });
                  _saveExpenses();
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Makanan':
        return Icons.fastfood;
      case 'Transportasi':
        return Icons.directions_car;
      case 'Utilitas':
        return Icons.lightbulb;
      case 'Hiburan':
        return Icons.movie;
      case 'Pendidikan':
        return Icons.school;
      default:
        return Icons.category;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Makanan':
        return Colors.orange;
      case 'Transportasi':
        return Colors.green;
      case 'Utilitas':
        return Colors.blue;
      case 'Hiburan':
        return Colors.purple;
      case 'Pendidikan':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showExpenseDetails(BuildContext context, Expense expense) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(expense.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Kategori: ${expense.category}'),
            Text('Deskripsi: ${expense.description}'),
            Text('Tanggal: ${DateFormat('dd MMM yyyy').format(expense.date)}'),
            Text('Jumlah: Rp ${expense.amount.toStringAsFixed(0)}'),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Tutup'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void _editExpense(Expense expense) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditExpenseScreen(
          expense: expense,
          onUpdateExpense: (updatedExpense) {
            setState(() {
              final index = expenses.indexWhere((e) => e.id == expense.id);
              if (index != -1) {
                expenses[index] = updatedExpense;
                _filterExpenses();
                _updateStats(); // ✅ update ulang
              }
            });
            _saveExpenses();
          },
        ),
      ),
    );
  }

  void _deleteExpense(Expense expense) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus Pengeluaran'),
        content:
            const Text('Apakah kamu yakin ingin menghapus pengeluaran ini?'),
        actions: [
          TextButton(
            child: const Text('Batal'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
            onPressed: () {
              setState(() {
                expenses.removeWhere((e) => e.id == expense.id);
                _filterExpenses();
                _updateStats(); // ✅ update ulang setelah hapus
              });
              _saveExpenses();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
