import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../models/category.dart';
import '../models/expense.dart';
import 'advance_expense_list_screen.dart';
import 'home_screen.dart';


class AddExpenseScreen extends StatefulWidget {
  final Function(Expense) onAddExpense;

  const AddExpenseScreen({super.key, required this.onAddExpense});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  String _selectedCategory = 'Makanan';
  DateTime _selectedDate = DateTime.now();

  final List<String> _categories = [
    'Makanan',
    'Transportasi',
    'Utilitas',
    'Hiburan',
    'Pendidikan',
  ];

  void _submitData() {
    if (_titleController.text.isEmpty ||
        _amountController.text.isEmpty ||
        double.tryParse(_amountController.text) == null) {
      return;
    }

    final newExpense = Expense(
      id: DateTime.now().toString(),
      title: _titleController.text,
      description: _descriptionController.text,
      amount: double.parse(_amountController.text),
      category: _selectedCategory,
      date: _selectedDate,
    );

    widget.onAddExpense(newExpense);
    Navigator.pop(context); // balik ke Home setelah tambah
  }

  void _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Pengeluaran")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: "Judul"),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: "Deskripsi"),
            ),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: "Jumlah (Rp)"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField(
              value: _selectedCategory,
              items: _categories.map((c) {
                return DropdownMenuItem(value: c, child: Text(c));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
              decoration: const InputDecoration(labelText: "Kategori"),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text("Tanggal: ${_selectedDate.toLocal()}".split(' ')[0]),
                TextButton(
                  onPressed: _pickDate,
                  child: const Text("Pilih Tanggal"),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitData,
              child: const Text("Simpan"),
            ),
          ],
        ),
      ),
    );
  }
}
