import 'package:intl/intl.dart';
import 'category.dart'; // Import model Category

class Expense {
  final String id;
  final String title;
  final String description;
  final double amount;
  final String category;
  final DateTime date;

  Expense({
    required this.id,
    required this.title,
    required this.description,
    required this.amount,
    required this.category,
    required this.date,
  });

  // 🔹 Format tanggal agar rapi di tampilan
  String get formattedDate {
    return DateFormat('dd MMM yyyy').format(date);
  }

  // 🔹 Format nominal dalam Rupiah
  String get formattedAmount {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatCurrency.format(amount);
  }

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'amount': amount,
      'date': date.toIso8601String(),
    };
  }
}

