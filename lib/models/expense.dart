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

     String get formattedDate {
    return DateFormat('dd MMM yyyy').format(date);
  }

  String get formattedAmount {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatCurrency.format(amount);
  }
}

