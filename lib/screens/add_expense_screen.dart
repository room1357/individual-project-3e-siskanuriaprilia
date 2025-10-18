import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../utils/expense_manager.dart';

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

  Future<void> _submitData() async {
    if (_titleController.text.isEmpty ||
        _amountController.text.isEmpty ||
        double.tryParse(_amountController.text) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Harap isi semua field dengan benar")),
      );
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

    await ExpenseManager.addExpense(newExpense);
    widget.onAddExpense(newExpense);
    Navigator.pop(context);
  }

  void _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
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
  appBar: AppBar(
    title: const Text('Tambah Pengeluaran'),
    backgroundColor: Colors.blue,
    foregroundColor: Colors.white, // Tulisan dan panah back jadi putih
  ),
  body: Padding(
    padding: const EdgeInsets.all(16),
    child: ListView(
      children: [
        TextField(
          controller: _titleController,
          decoration: const InputDecoration(labelText: 'Judul'),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _descriptionController,
          decoration: const InputDecoration(labelText: 'Deskripsi'),
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          value: _selectedCategory,
          decoration: const InputDecoration(labelText: 'Kategori'),
          items: _categories
              .map((c) => DropdownMenuItem(
                    value: c,
                    child: Text(c),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              _selectedCategory = value!;
            });
          },
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _amountController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Jumlah (Rp)'),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Tanggal: ${_selectedDate.toLocal().toString().split(' ')[0]}'),
            TextButton(
              onPressed: _pickDate,
              child: const Text('Pilih Tanggal'),
            ),
          ],
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _submitData,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          child: const Text(
            'Simpan',
            style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
