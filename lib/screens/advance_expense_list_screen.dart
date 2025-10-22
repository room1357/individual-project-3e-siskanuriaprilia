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

class _AdvancedExpenseListScreenState
    extends State<AdvancedExpenseListScreen> {
  List<Expense> expenses = [];
  List<Expense> filteredExpenses = [];
  String selectedCategory = 'Semua';
  TextEditingController searchController = TextEditingController();
  DateTimeRange? selectedDateRange;

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

        bool matchesDate = true;
        if (selectedDateRange != null) {
          matchesDate = expense.date.isAfter(
                  selectedDateRange!.start.subtract(const Duration(days: 1))) &&
              expense.date.isBefore(
                  selectedDateRange!.end.add(const Duration(days: 1)));
        }

        return matchesSearch && matchesCategory && matchesDate;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  await ExpenseManager.addExpense(expense);
                  setState(() {
                    expenses.add(expense);
                    _filterExpenses();
                  });
                },
              ),
            ),
          );
        },
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE3F2FD), Color(0xFFF3E5F5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom AppBar
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue, Colors.purpleAccent],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: const [
                    Icon(
                      Icons.account_balance_wallet,
                      color: Colors.white,
                      size: 28,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Pengeluaran Kamu',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Export & Category buttons (dipindahkan ke atas search bar)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ExportScreen(expenses: expenses),
                          ),
                        );
                      },
                      icon: const Icon(Icons.upload_file,
                          color: Colors.blue, size: 28),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CategoryScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.category,
                          color: Colors.blue, size: 28),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Search bar + filter kategori + filter tanggal
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        decoration: const InputDecoration(
                          hintText: 'Cari pengeluaran...',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        onChanged: (value) => _filterExpenses(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    DropdownButton<String>(
                      value: selectedCategory,
                      items: [
                        'Semua',
                        'Makanan',
                        'Transportasi',
                        'Hiburan',
                        'Pendidikan',
                        'Utilitas',
                      ].map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value!;
                          _filterExpenses();
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () async {
                        final picked = await showDateRangePicker(
                          context: context,
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                          initialDateRange: selectedDateRange,
                        );
                        if (picked != null) {
                          setState(() {
                            selectedDateRange = picked;
                            _filterExpenses();
                          });
                        }
                      },
                      child: const Icon(Icons.date_range, size: 24),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Statistik ringkas
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatCard('Total', _calculateTotal(filteredExpenses)),
                    _buildStatCard(
                        'Jumlah', '${filteredExpenses.length} item'),
                    _buildStatCard(
                        'Rata-rata', _calculateAverage(filteredExpenses)),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Daftar pengeluaran dengan animasi
              Expanded(
                child: filteredExpenses.isEmpty
                    ? const Center(
                        child: Text('Tidak ada pengeluaran ditemukan'))
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 80),
                        itemCount: filteredExpenses.length,
                        itemBuilder: (context, index) {
                          final e = filteredExpenses[index];
                          return TweenAnimationBuilder(
                            tween: Tween<double>(begin: 0, end: 1),
                            duration: Duration(milliseconds: 300 + (index * 50)),
                            builder: (context, double value, child) {
                              return Opacity(
                                opacity: value,
                                child: Transform.translate(
                                  offset: Offset(0, 20 * (1 - value)),
                                  child: child,
                                ),
                              );
                            },
                            child: Card(
                              color: Colors.white,
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                leading: CircleAvatar(
                                  radius: 28,
                                  backgroundColor:
                                      _getCategoryColor(e.category).withOpacity(0.9),
                                  child: Icon(
                                    _getCategoryIcon(e.category),
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                title: Text(
                                  e.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                                subtitle: Text(
                                  "${e.category} • ${DateFormat('dd MMM yyyy').format(e.date)}",
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Rp ${e.amount.toStringAsFixed(0)}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      icon: const Icon(Icons.edit,
                                          color: Colors.blue, size: 20),
                                      onPressed: () => _editExpense(e),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red, size: 20),
                                      onPressed: () => _deleteExpense(e),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
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
