class Expense {
  final String id;
  final String title;
  final String description;
  final double amount;
  final String category;
  final DateTime date;
  final List<String> sharedWith; // 🔹 Shared Expenses

  Expense({
    required this.id,
    required this.title,
    required this.description,
    required this.amount,
    required this.category,
    required this.date,
    this.sharedWith = const [], // default kosong
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date']),
      sharedWith: json['sharedWith'] != null
          ? List<String>.from(json['sharedWith'])
          : [],
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
      'sharedWith': sharedWith,
    };
  }
}
