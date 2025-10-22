import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';
import 'package:csv/csv.dart';
import 'package:pdf/widgets.dart' as pw;
import '../utils/save_utils.dart';

class ExportScreen extends StatelessWidget {
  final List<Expense> expenses;

  const ExportScreen({super.key, required this.expenses});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F2FA),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Export Data Pengeluaran',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.normal,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 2,
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pilih Format Export:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            // Tombol Export CSV
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () async => await _exportToCSV(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  width: double.infinity,
                  child: Row(
                    children: const [
                      Icon(Icons.table_chart, color: Colors.green, size: 32),
                      SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          'Export ke CSV',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, color: Colors.grey), // tetap panah di kanan card
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Tombol Export PDF
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () async => await _exportToPDF(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  width: double.infinity,
                  child: Row(
                    children: const [
                      Icon(Icons.picture_as_pdf, color: Colors.red, size: 32),
                      SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          'Export ke PDF',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, color: Colors.grey),
                    ],
                  ),
                ),
              ),
            ),

            const Spacer(),
            const Center(
              child: Text(
                'Catatan: File akan disimpan di folder default perangkat atau di-download jika menggunakan web.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
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

      await saveCSV(csvData, 'pengeluaran.csv');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(kIsWeb
                ? 'CSV berhasil di-download di Web'
                : 'CSV berhasil disimpan')),
      );
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
                  data: expenses
                      .map((e) => [
                            e.title,
                            e.category,
                            DateFormat('dd-MM-yyyy').format(e.date),
                            e.amount.toStringAsFixed(0),
                          ])
                      .toList(),
                ),
              ],
            );
          },
        ),
      );

      final pdfBytes = await pdf.save();
      await savePDF(pdfBytes, 'pengeluaran.pdf');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(kIsWeb
                ? 'PDF berhasil di-download di Web'
                : 'PDF berhasil disimpan')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal export PDF: $e')),
      );
    }
  }
}
