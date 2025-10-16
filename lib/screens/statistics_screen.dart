import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';
import 'package:fl_chart/fl_chart.dart';

class StatisticsScreen extends StatelessWidget {
  final List<Expense> expenses;

  const StatisticsScreen({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    final grouped = _groupExpensesByCategory(expenses);
    final total = grouped.values.fold(0.0, (a, b) => a + b);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistik Pengeluaran'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ringkasan Pengeluaran',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),

            // Total pengeluaran
            Text(
              'Total: Rp ${NumberFormat('#,###').format(total)}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Grafik batang
            Expanded(
              child: BarChart(
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
            const SizedBox(height: 10),

            // Keterangan warna kategori
            Wrap(
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
          ],
        ),
      ),
    );
  }

  /// Mengelompokkan pengeluaran berdasarkan kategori
  Map<String, double> _groupExpensesByCategory(List<Expense> expenses) {
    final Map<String, double> grouped = {};
    for (var e in expenses) {
      grouped[e.category] = (grouped[e.category] ?? 0) + e.amount;
    }
    return grouped;
  }

  /// Membuat grup batang (bar) per kategori
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

  /// Mendapatkan batas maksimal Y (agar chart proporsional)
  double _getMaxY(Iterable<double> values) {
    if (values.isEmpty) return 100;
    final max = values.reduce((a, b) => a > b ? a : b);
    return (max / 10000).ceil() * 10000 + 10000;
  }

  /// Warna tiap kategori
  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Makanan':
        return Colors.orange;
      case 'Transportasi':
        return Colors.blue;
      case 'Utilitas':
        return Colors.green;
      case 'Hiburan':
        return Colors.purple;
      case 'Pendidikan':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
