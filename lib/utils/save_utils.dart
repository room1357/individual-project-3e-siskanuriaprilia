// lib/utils/save_utils.dart
import 'dart:typed_data';
import 'download_pdf.dart'; // conditional export

/// Simpel wrapper — panggil fungsi ini dari UI.
/// Contoh: await saveCSV(csvData, 'pengeluaran.csv');
Future<void> saveCSV(String csv, String filename) async {
  await downloadCSV(csv, filename);
}

/// Simpel wrapper — panggil fungsi ini dari UI.
/// Contoh: await savePDF(pdfBytes, 'pengeluaran.pdf');
Future<void> savePDF(Uint8List pdfBytes, String filename) async {
  await downloadPDF(pdfBytes, filename);
}
