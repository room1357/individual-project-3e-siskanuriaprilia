import 'package:flutter/material.dart';
import '../models/expense.dart';

class EditExpenseScreen extends StatefulWidget {
  final Expense expense;
  final Function(Expense) onUpdateExpense;

  const EditExpenseScreen({
    super.key,
    required this.expense,
    required this.onUpdateExpense,
  });

  @override
  _EditExpenseScreenState createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends State<EditExpenseScreen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController amountController;
  late String selectedCategory;
  late DateTime selectedDate;
  List<String> selectedUsers = [];

  final List<String> categories = [
    'Makanan',
    'Transportasi',
    'Utilitas',
    'Hiburan',
    'Pendidikan',
  ];

  final List<String> users = ['Siska', 'Budi', 'Ani', 'Rina'];

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.expense.title);
    descriptionController =
        TextEditingController(text: widget.expense.description);
    amountController =
        TextEditingController(text: widget.expense.amount.toString());
    selectedCategory = widget.expense.category;
    selectedDate = widget.expense.date;
    selectedUsers = List<String>.from(widget.expense.sharedWith);
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    amountController.dispose();
    super.dispose();
  }

  void _saveExpense() {
    final updatedExpense = Expense(
      id: widget.expense.id,
      title: titleController.text,
      description: descriptionController.text,
      category: selectedCategory,
      amount: double.tryParse(amountController.text) ?? 0,
      date: selectedDate,
      sharedWith: selectedUsers,
    );

    widget.onUpdateExpense(updatedExpense);
    Navigator.pop(context);
  }

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Pengeluaran'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Judul'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Deskripsi'),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedCategory,
              decoration: const InputDecoration(labelText: 'Kategori'),
              items: categories
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (value) {
                setState(() => selectedCategory = value!);
              },
            ),
            const SizedBox(height: 10),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Jumlah (Rp)'),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Tanggal: ${selectedDate.toLocal().toString().split(' ')[0]}'),
                TextButton(
                  onPressed: _pickDate,
                  child: const Text('Pilih Tanggal'),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: _saveExpense,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text(
                'Simpan Perubahan',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
