// lib/utils/download_helper_web.dart
import 'dart:html' as html;
import 'dart:typed_data';

Future<void> downloadPDF(Uint8List pdfBytes, String filename) async {
  final blob = html.Blob([pdfBytes], 'application/pdf');
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement(href: url)
    ..setAttribute('download', filename)
    ..click();
  html.Url.revokeObjectUrl(url);
}

Future<void> downloadCSV(String csv, String filename) async {
  final bytes = <int>[]..addAll(csv.codeUnits);
  final blob = html.Blob([bytes], 'text/csv');
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.AnchorElement(href: url)
    ..setAttribute('download', filename)
    ..click();
  html.Url.revokeObjectUrl(url);
}
