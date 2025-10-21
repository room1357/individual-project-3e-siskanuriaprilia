import 'package:flutter/material.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final TextEditingController _categoryController = TextEditingController();
  final List<String> _categories = [
                'Makanan',
                'Transportasi',
                'Hiburan',
                'Pendidikan',
                'Utilitas',
  ];

  void _addCategory() {
    if (_categoryController.text.isNotEmpty) {
      setState(() {
        _categories.add(_categoryController.text);
        _categoryController.clear();
      });
    }
  }

  void _deleteCategory(int index) {
    setState(() {
      _categories.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    
   return Scaffold(
  backgroundColor: const Color(0xFFF7F2FA),
  appBar: AppBar(
    title: const Text(
      'Category Management',
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.normal, // sama seperti di Settings
        fontSize: 20,
      ),
    ),
    backgroundColor: Colors.blue, // sama dengan Settings
    foregroundColor: Colors.white, // warna icon & teks
    elevation: 2, // sedikit bayangan lembut
    centerTitle: false,
  ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Input kategori baru
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _categoryController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Kategori',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addCategory,
                  child: const Text('Tambah'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Daftar kategori
            Expanded(
              child: ListView.builder(
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(_categories[index]),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteCategory(index),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
