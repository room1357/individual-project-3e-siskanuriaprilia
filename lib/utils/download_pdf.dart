import 'dart:html' as html;
import 'dart:typed_data';

/// Download PDF di Flutter Web
void downloadPDF(Uint8List pdfBytes, String filename) {
  final blob = html.Blob([pdfBytes], 'application/pdf');
  final url = html.Url.createObjectUrlFromBlob(blob);

  final anchor = html.AnchorElement(href: url)
    ..setAttribute('download', filename)
    ..click();

  html.Url.revokeObjectUrl(url);
}
