import 'package:flutter/material.dart';
import '../models/category.dart';

class CategoryScreen extends StatefulWidget {
  final List<Category> categories;
  final Function(Category) onAdd;

  const CategoryScreen({
    super.key,
    required this.categories,
    required this.onAdd,
  });

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final _controller = TextEditingController();

  void _addCategory() {
    if (_controller.text.isNotEmpty) {
      final newCategory = Category(
        id: DateTime.now().toString(),
        name: _controller.text,
        icon: "📌",
      );
      widget.onAdd(newCategory);
      _controller.clear();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kelola Kategori')),
      body: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Nama kategori',
              contentPadding: EdgeInsets.all(8),
            ),
          ),
          ElevatedButton(
            onPressed: _addCategory,
            child: const Text('Tambah'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.categories.length,
              itemBuilder: (ctx, i) {
                final cat = widget.categories[i];
                return ListTile(
                  leading: Text(cat.icon),
                  title: Text(cat.name),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
