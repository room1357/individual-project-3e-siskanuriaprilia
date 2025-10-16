import 'dart:io' show File;
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';
import 'download_csv.dart';
import 'download_pdf.dart';

/// ===================== SAVE CSV =====================
Future<void> saveCSV(String csv, String filename) async {
  if (kIsWeb) {
    downloadCSV(csv, filename);
  } else {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/$filename';
    final file = File(path);
    await file.writeAsString(csv);
    print('CSV berhasil disimpan di $path');
  }
}

/// ===================== SAVE PDF =====================
Future<void> savePDF(Uint8List pdfBytes, String filename) async {
  if (kIsWeb) {
    downloadPDF(pdfBytes, filename);
  } else {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/$filename';
    final file = File(path);
    await file.writeAsBytes(pdfBytes);
    print('PDF berhasil disimpan di $path');
  }
}
