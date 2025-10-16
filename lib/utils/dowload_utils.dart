// lib/utils/download_csv.dart
import 'dart:convert';
import 'dart:html' as html;

/// Fungsi untuk mendownload CSV di Flutter Web
void downloadCSV(String csv, String filename) {
  // Konversi string CSV ke bytes
  final bytes = utf8.encode(csv);
  final blob = html.Blob([bytes], 'text/csv');

  // Buat URL sementara untuk blob
  final url = html.Url.createObjectUrlFromBlob(blob);

  // Buat anchor element dan trigger download
  final anchor = html.AnchorElement(href: url)
    ..setAttribute('download', filename)
    ..click();

  // Hapus URL sementara
  html.Url.revokeObjectUrl(url);
}
