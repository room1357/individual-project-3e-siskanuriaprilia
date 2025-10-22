import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';
import '../utils/expense_manager.dart';
import 'package:fl_chart/fl_chart.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  List<Expense> _expenses = [];

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    await ExpenseManager.init();
    setState(() {
      _expenses = ExpenseManager.expenses;
    });
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'makanan':
        return const Color(0xFFFFA726);
      case 'transportasi':
        return const Color(0xFF66BB6A);
      case 'hiburan':
        return const Color(0xFFAB47BC);
      case 'belanja':
        return const Color(0xFFEC407A);
      default:
        return const Color(0xFF42A5F5);
    }
  }

  @override
  Widget build(BuildContext context) {
    final grouped = _groupExpensesByCategory(_expenses);
    final total = grouped.values.fold(0.0, (a, b) => a + b);
    final avgDaily = ExpenseManager.getAverageDaily(_expenses);
    final highest = ExpenseManager.getHighestExpense(_expenses);

    return Scaffold(
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
              // AppBar tema ExpenseScreen
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                    Icon(Icons.bar_chart, color: Colors.white, size: 28),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Statistik Keuangan',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 22,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Card Ringkas Statistik Keuangan
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16.0),
  child: Card(
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Rata-rata Harian
          Expanded(
            child: Column(
              children: [
                const Icon(Icons.trending_up, color: Colors.blueAccent, size: 20),
                const SizedBox(height: 4),
                const Text(
                  "Rata-rata",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Rp ${avgDaily.toStringAsFixed(0)}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.blueAccent,
                  ),
                ),
              ],
            ),
          ),

          // Divider vertikal
          Container(height: 40, width: 1, color: Colors.grey.shade300),

          // Pengeluaran Tertinggi
          if (highest != null)
            Expanded(
              child: Column(
                children: [
                  const Icon(Icons.arrow_upward, color: Colors.redAccent, size: 20),
                  const SizedBox(height: 4),
                  const Text(
                    "Tertinggi",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Rp ${highest.amount.toStringAsFixed(0)}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.redAccent,
                    ),
                  ),
                ],
              ),
            ),

          // Divider vertikal
          Container(height: 40, width: 1, color: Colors.grey.shade300),

          // Total Pengeluaran
          Expanded(
            child: Column(
              children: [
                const Icon(Icons.attach_money, color: Colors.green, size: 20),
                const SizedBox(height: 4),
                const Text(
                  "Total",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Rp ${total.toStringAsFixed(0)}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  ),
),


              const SizedBox(height: 24),

              // Grafik batang
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _expenses.isEmpty
                      ? const Center(child: Text("Belum ada data pengeluaran"))
                      : BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceAround,
                            maxY: _getMaxY(grouped.values),
                            gridData: FlGridData(show: true, horizontalInterval: 10000),
                            borderData: FlBorderData(show: false),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 45,
                                  interval: 10000,
                                  getTitlesWidget: (value, meta) => Text(
                                    'Rp ${value ~/ 1000}K',
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    final categories = grouped.keys.toList();
                                    if (value.toInt() < categories.length) {
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 6),
                                        child: Text(
                                          categories[value.toInt()],
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      );
                                    }
                                    return const Text('');
                                  },
                                ),
                              ),
                              rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                              topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                            ),
                            barGroups: _buildBarGroups(grouped),
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 16),

              // Keterangan kategori
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Wrap(
                  spacing: 12,
                  children: grouped.keys.map((category) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 14,
                          height: 14,
                          color: _getCategoryColor(category),
                        ),
                        const SizedBox(width: 4),
                        Text(category),
                      ],
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Map<String, double> _groupExpensesByCategory(List<Expense> expenses) {
    final Map<String, double> grouped = {};
    for (var e in expenses) {
      grouped[e.category] = (grouped[e.category] ?? 0) + e.amount;
    }
    return grouped;
  }

  List<BarChartGroupData> _buildBarGroups(Map<String, double> grouped) {
    final categories = grouped.keys.toList();
    return List.generate(categories.length, (index) {
      final category = categories[index];
      final amount = grouped[category]!;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: amount,
            color: _getCategoryColor(category),
            width: 22,
            borderRadius: BorderRadius.circular(6),
          ),
        ],
      );
    });
  }

  double _getMaxY(Iterable<double> values) {
    if (values.isEmpty) return 100;
    final max = values.reduce((a, b) => a > b ? a : b);
    return (max / 10000).ceil() * 10000 + 10000;
  }
}
