import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';
import 'package:csv/csv.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_filex/open_filex.dart';
import '../utils/save_utils.dart';
import 'package:path_provider/path_provider.dart';


class ExportScreen extends StatelessWidget {
  final List<Expense> expenses;

  const ExportScreen({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Export Data Pengeluaran'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pilih Format Export:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            // Tombol Export CSV
            ElevatedButton.icon(
              icon: const Icon(Icons.table_chart),
              label: const Text('Export ke CSV'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () async {
                await _exportToCSV(context);
              },
            ),
            const SizedBox(height: 20),

            // Tombol Export PDF
            ElevatedButton.icon(
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text('Export ke PDF'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () async {
                await _exportToPDF(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// ===================== EXPORT KE CSV ======================
  Future<void> _exportToCSV(BuildContext context) async {
    try {
      final List<List<dynamic>> rows = [
        ['Judul', 'Kategori', 'Tanggal', 'Jumlah (Rp)'],
        ...expenses.map((e) => [
              e.title,
              e.category,
              DateFormat('dd-MM-yyyy').format(e.date),
              e.amount,
            ])
      ];

      String csvData = const ListToCsvConverter().convert(rows);

      // Simpan CSV universal
      await saveCSV(csvData, 'pengeluaran.csv');

      if (!kIsWeb) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('CSV berhasil disimpan')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal export CSV: $e')),
      );
    }
  }

  /// ===================== EXPORT KE PDF ======================
  Future<void> _exportToPDF(BuildContext context) async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Laporan Pengeluaran',
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Table.fromTextArray(
                  headers: ['Judul', 'Kategori', 'Tanggal', 'Jumlah (Rp)'],
                  data: expenses.map((e) => [
                        e.title,
                        e.category,
                        DateFormat('dd-MM-yyyy').format(e.date),
                        e.amount.toStringAsFixed(0),
                      ]).toList(),
                ),
              ],
            );
          },
        ),
      );

      // PDF hanya bisa disimpan di Mobile/Desktop
      if (!kIsWeb) {
        final directory = await getApplicationDocumentsDirectory();
        final path = '${directory.path}/pengeluaran.pdf';
        final file = File(path);
        await file.writeAsBytes(await pdf.save());

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('PDF berhasil disimpan di $path')),
        );

        await OpenFilex.open(path);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Export PDF belum support Web')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal export PDF: $e')),
      );
    }
  }
}
