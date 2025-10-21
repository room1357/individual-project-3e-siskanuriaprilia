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
import '../utils/expense_manager.dart';

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

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final String? expenseData = prefs.getString('expenses');

    if (expenseData != null) {
      List<dynamic> decoded = jsonDecode(expenseData);
      setState(() {
        expenses = decoded.map((e) => Expense.fromJson(e)).toList();
        filteredExpenses = expenses;
      });
    } else {
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
    }
  }

  Future<void> _saveExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> expenseList =
        expenses.map((e) => e.toJson()).toList();
    await prefs.setString('expenses', jsonEncode(expenseList));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F2FA),
      appBar: AppBar(
        title: const Text(
          'Pengeluaran Advanced',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.normal,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 2,
        centerTitle: false,
        actions: [
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
          // Search bar
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

          // Filter kategori
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                'Semua',
                'Makanan',
                'Transportasi',
                'Hiburan',
                'Pendidikan',
                'Utilitas',
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

          // Statistik ringkas
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard('Total', _calculateTotal(filteredExpenses)),
                _buildStatCard('Jumlah', '${filteredExpenses.length} item'),
                _buildStatCard('Rata-rata', _calculateAverage(filteredExpenses)),
              ],
            ),
          ),

          // Daftar pengeluaran
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
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                backgroundColor:
                                    _getCategoryColor(expense.category),
                                child: Icon(
                                  _getCategoryIcon(expense.category),
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      expense.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${expense.category} • ${DateFormat('dd MMM yyyy').format(expense.date)}',
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
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
                                            color: Colors.blue, size: 20),
                                        onPressed: () =>
                                            _editExpense(expense),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red, size: 20),
                                        onPressed: () =>
                                            _deleteExpense(expense),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddExpenseScreen(
                onAddExpense: (Expense expense) async {
                  // Tambah ke ExpenseManager sekaligus SharedPreferences
                  await ExpenseManager.addExpense(expense);

                  setState(() {
                    expenses.add(expense); // tetap update list lokal
                    _filterExpenses();
                  });
                },
              ),
            ),
          );
        },
      ),

    );
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
            selectedCategory == 'Semua' ||
            expense.category == selectedCategory;

        return matchesSearch && matchesCategory;
      }).toList();
    });
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

  String _calculateTotal(List<Expense> expenses) {
    double total = expenses.fold(0, (sum, expense) => sum + expense.amount);
    return 'Rp ${total.toStringAsFixed(0)}';
  }

  String _calculateAverage(List<Expense> expenses) {
    if (expenses.isEmpty) return 'Rp 0';
    double average =
        expenses.fold(0.0, (sum, expense) => sum + expense.amount) /
            expenses.length;
    return 'Rp ${average.toStringAsFixed(0)}';
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
