// lib/utils/download_helper_stub.dart
import 'dart:typed_data';

Future<void> downloadPDF(Uint8List pdfBytes, String filename) async {
  throw UnsupportedError('downloadPDF is not supported on this platform.');
}

Future<void> downloadCSV(String csv, String filename) async {
  throw UnsupportedError('downloadCSV is not supported on this platform.');
}
